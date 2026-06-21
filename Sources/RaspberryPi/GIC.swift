import _Volatile

// MARK: - GIC-400 (GICv2) for BCM2711 / Raspberry Pi 4
//
// Address map (Low Peripheral Mode, as used by QEMU raspi4b):
//   GICD (Distributor)  : 0x40041000
//   GICC (CPU Interface): 0x40042000
//
// Reference: BCM2711 TRM, ARM GIC-400 TRM (ARM IHI0048B)
//
// Interrupt IDs:
//   0–15   SGI  (Software Generated Interrupts)
//   16–31  PPI  (Private Peripheral Interrupts, per-CPU)
//   32–    SPI  (Shared Peripheral Interrupts)
//
// UART0 (PL011 @ 0x7e201000): SPI 0x79 = 121 → GIC ID = 121 + 32 = 153

// MARK: GICD Registers

private let gicdBase: UInt = 0x4004_1000

/// GICD_CTLR – Distributor Control Register
private let gicdCTLR = unsafe VolatileMappedRegister<UInt32>(
    unsafeBitPattern: gicdBase + 0x000)

/// GICD_TYPER – Interrupt Controller Type Register
private let gicdTYPER = unsafe VolatileMappedRegister<UInt32>(
    unsafeBitPattern: gicdBase + 0x004)

/// GICD_ISENABLERn – Interrupt Set-Enable Registers (32 bits × n)
@inline(__always)
private func gicdISENABLER(_ n: Int) -> VolatileMappedRegister<UInt32> {
    unsafe VolatileMappedRegister<UInt32>(
        unsafeBitPattern: gicdBase + 0x100 + UInt(n) * 4)
}

/// GICD_ICENABLERn – Interrupt Clear-Enable Registers
@inline(__always)
private func gicdICENABLER(_ n: Int) -> VolatileMappedRegister<UInt32> {
    unsafe VolatileMappedRegister<UInt32>(
        unsafeBitPattern: gicdBase + 0x180 + UInt(n) * 4)
}

/// GICD_IPRIORITYRn – Interrupt Priority Registers (8 bits per interrupt)
@inline(__always)
private func gicdIPRIORITYR(_ n: Int) -> VolatileMappedRegister<UInt32> {
    unsafe VolatileMappedRegister<UInt32>(
        unsafeBitPattern: gicdBase + 0x400 + UInt(n) * 4)
}

/// GICD_ITARGETSRn – Interrupt Processor Targets Registers (8 bits per interrupt)
@inline(__always)
private func gicdITARGETSR(_ n: Int) -> VolatileMappedRegister<UInt32> {
    unsafe VolatileMappedRegister<UInt32>(
        unsafeBitPattern: gicdBase + 0x800 + UInt(n) * 4)
}

/// GICD_ICFGRn – Interrupt Configuration Registers (2 bits per interrupt)
@inline(__always)
private func gicdICFGR(_ n: Int) -> VolatileMappedRegister<UInt32> {
    unsafe VolatileMappedRegister<UInt32>(
        unsafeBitPattern: gicdBase + 0xC00 + UInt(n) * 4)
}

// MARK: GICC Registers

private let giccBase: UInt = 0x4004_2000

/// GICC_CTLR – CPU Interface Control Register
private let giccCTLR = unsafe VolatileMappedRegister<UInt32>(
    unsafeBitPattern: giccBase + 0x000)

/// GICC_PMR – Interrupt Priority Mask Register
private let giccPMR = unsafe VolatileMappedRegister<UInt32>(
    unsafeBitPattern: giccBase + 0x004)

/// GICC_BPR – Binary Point Register
private let giccBPR = unsafe VolatileMappedRegister<UInt32>(
    unsafeBitPattern: giccBase + 0x008)

/// GICC_IAR – Interrupt Acknowledge Register (read to acknowledge)
let giccIAR = unsafe VolatileMappedRegister<UInt32>(
    unsafeBitPattern: giccBase + 0x00C)

/// GICC_EOIR – End Of Interrupt Register (write to signal EOI)
let giccEOIR = unsafe VolatileMappedRegister<UInt32>(
    unsafeBitPattern: giccBase + 0x010)

// MARK: - Public API

/// GIC spurious interrupt ID (returned by IAR when no real interrupt is pending)
package let gicSpuriousID: UInt32 = 1023

/// GIC SPI ID for UART0 (PL011): SPI 121 → GIC interrupt ID 153
package let gicUART0SPI: UInt32 = 153

/// Initialise GIC-400 Distributor and CPU Interface.
///
/// Call once before enabling IRQs on the CPU (`enableIRQ()`).
package func initGIC() {
    // ---- Distributor ----

    // Disable distributor while configuring
    gicdCTLR.store(0)

    // Read number of SPI interrupt lines (GICD_TYPER bits [4:0] = N,
    // total lines = 32*(N+1))
    let typer = gicdTYPER.load()
    let numIRQWords = Int((typer & 0x1F) + 1)  // number of 32-bit ISENABLER words
    print("GICD_TYPER = ", terminator: "")
    print(typer)

    // Disable all SPI interrupts
    for i in 1..<numIRQWords {
        gicdICENABLER(i).store(0xFFFF_FFFF)
    }

    // Set all SPI interrupt priorities to 0xA0 (non-secure default, below 0xFF mask)
    // Priority registers are byte-addressable, packed 4 per word
    let numPrioWords = numIRQWords * 8  // 32 IRQs per word, 4 IRQs per priority word
    for i in 8..<numPrioWords {  // start at word 8 (skip SGI/PPI range)
        gicdIPRIORITYR(i).store(0xA0A0_A0A0)
    }

    // Route all SPI interrupts to CPU0 (target mask = 0x01)
    let numTargetWords = numIRQWords * 8
    for i in 8..<numTargetWords {
        gicdITARGETSR(i).store(0x0101_0101)
    }

    // Configure all SPIs as level-sensitive (ICFGR bit[2n+1] = 0)
    for i in 2..<(numIRQWords * 2) {
        gicdICFGR(i).store(0)
    }

    // Enable distributor
    gicdCTLR.store(1)

    // ---- CPU Interface ----

    // Set priority mask to 0xFF → accept all interrupts
    giccPMR.store(0xFF)

    // Binary point = 0 (no preemption grouping)
    giccBPR.store(0)

    // Enable CPU interface (enable group 0 interrupts)
    giccCTLR.store(1)
}

/// Enable a specific SPI interrupt in the GIC Distributor.
///
/// - Parameter irqID: The GIC interrupt ID (>= 32 for SPIs).
package func gicEnableIRQ(_ irqID: UInt32) {
    let word = Int(irqID / 32)
    let bit = irqID % 32
    gicdISENABLER(word).store(1 << bit)
}

/// Disable a specific SPI interrupt in the GIC Distributor.
///
/// - Parameter irqID: The GIC interrupt ID (>= 32 for SPIs).
package func gicDisableIRQ(_ irqID: UInt32) {
    let word = Int(irqID / 32)
    let bit = irqID % 32
    gicdICENABLER(word).store(1 << bit)
}

/// Acknowledge the current IRQ and return its ID.
///
/// Must be called at the start of an IRQ handler.
/// Returns `gicSpuriousID` (1023) if no real interrupt is pending.
@inline(__always)
package func gicAcknowledge() -> UInt32 {
    giccIAR.load() & 0x3FF  // bits [9:0] = interrupt ID
}

/// Signal End-Of-Interrupt to the GIC CPU Interface.
///
/// Must be called after the IRQ handler has finished processing.
/// - Parameter irqID: The ID returned by `gicAcknowledge()`.
@inline(__always)
package func gicEndOfInterrupt(_ irqID: UInt32) {
    giccEOIR.store(irqID)
}
