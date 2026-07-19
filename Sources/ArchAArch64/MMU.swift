private import AsmSupport
private import LinkerSupport

package func enableInitialMMU() {
    // We cannot query the physical memory size before enabling the MMU.
    // Use a fixed size for the initial memory mapping.
    let initialDRAMSize: UInt = 1 << 30

    let l2BlockSize: UInt = 1 << 21
    precondition(initialDRAMSize.isMultiple(of: l2BlockSize), "Mapped RAM size must be 2 MiB aligned")

    // Get physical addresses of L2 tables
    let paddr0 = UInt(bitPattern: unsafe PageTable.l2Table0)
    let paddr1 = UInt(bitPattern: unsafe PageTable.l2Table1)
    let paddr2 = UInt(bitPattern: unsafe PageTable.l2Table2)
    let paddr3 = UInt(bitPattern: unsafe PageTable.l2Table3)

    // Set L1 entries pointing to L2 tables
    unsafe PageTable.l1[0] = paddr0 | 3
    unsafe PageTable.l1[1] = paddr1 | 3
    unsafe PageTable.l1[2] = paddr2 | 3
    unsafe PageTable.l1[3] = paddr3 | 3

    // Populate L2 tables mapping the 4 GiB space block by block
    for i in 0..<2048 {
        let addr = UInt(i) * l2BlockSize
        let (tableIndex, entryIndex) = i.quotientAndRemainder(dividingBy: 512)

        // FIXME: The physical memory map is currently BCM2711-specific.
        let descriptor =
            switch addr {
            case 0..<initialDRAMSize:
                // DRAM -> Normal Non-Cacheable, Inner Shareable
                // Lower attributes: AF=1, SH=3 (Inner Shareable), AP=0, AttrIndx=0
                addr | 0x701
            case 0xfc00_0000...0xffff_ffff:
                // MMIO -> Device-nGnRnE
                // Lower attributes: AF=1, SH=0, AP=0, AttrIndx=1
                // Upper attributes: PXN=1, UXN=1
                addr | 0x0060_0000_0000_0405
            case _: 0 as UInt
            }

        switch tableIndex {
        case 0: unsafe PageTable.l2Table0[entryIndex] = descriptor
        case 1: unsafe PageTable.l2Table1[entryIndex] = descriptor
        case 2: unsafe PageTable.l2Table2[entryIndex] = descriptor
        case 3: unsafe PageTable.l2Table3[entryIndex] = descriptor
        case _: preconditionFailure("unreachable")
        }
    }

    let paRange = getMMFR0() & 0xf
    let ips = tcrIPS(from: paRange)

    enableMMU(
        // MAIR_EL1:
        // Index 0 = 0x44 (Normal Non-Cacheable)
        // Index 1 = 0x00 (Device nGnRnE)
        mair: 0x44 | (0x00 << 8),
        // TCR_EL1:
        // T0SZ = 25 (39-bit VA)
        // EPD1 = 1 (Disable TTBR1 walks)
        // TG0 = 0 (4 KiB granule)
        // SH0 = 3 (Inner Shareable)
        // ORGN0 = 1 (Outer WB WA cacheable)
        // IRGN0 = 1 (Inner WB WA cacheable)
        // IPS = paRange
        tcr: (1 << 23) | (3 << 12) | (1 << 10) | (1 << 8) | 25 | (ips << 32),
        ttbr0: UInt64(UInt(bitPattern: unsafe PageTable.l1)),
    )
}

@_transparent
private func tcrIPS(from paRange: UInt64) -> UInt64 {
    switch paRange {
    case 0b0000: 0b000  // 32-bit
    case 0b0001: 0b001  // 36-bit
    case 0b0010: 0b010  // 40-bit
    case 0b0011: 0b011  // 42-bit
    case 0b0100: 0b100  // 44-bit
    case 0b0101: 0b101  // 48-bit
    case _: preconditionFailure("unsupported PARange")
    }
}
