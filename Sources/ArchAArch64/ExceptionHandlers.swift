private import AsmSupport

#if RASPI
    private import RaspberryPi
#endif

// MARK: - IRQ Dispatcher

/// Central IRQ handler called from the EL1/SPx IRQ vector.
///
/// Reads the GIC Interrupt Acknowledge Register to determine which device
/// fired, dispatches to the appropriate driver handler, then signals
/// End-Of-Interrupt back to the GIC.
@inline(__always)
private func dispatchIRQ() {
    #if RASPI
        // Acknowledge: read IAR, which also signals the GIC that we are
        // servicing the interrupt. The returned ID encodes the SPI/PPI number.
        let irqID = gicAcknowledge()

        if irqID == gicSpuriousID {
            // Spurious interrupt – nothing to do.
            return
        }

        switch irqID {
        case gicUART0SPI:
            // UART0 (PL011) Receive interrupt
            handleUART0RX()
        case _:
            // Unknown / unhandled interrupt – log and move on.
            print("IRQ: unhandled GIC ID ", terminator: "")
            print(irqID)
        }

        // Signal End-Of-Interrupt so the GIC deactivates the interrupt line.
        gicEndOfInterrupt(irqID)
    #else
        print("IRQ: no GIC driver for this platform")
    #endif
}

// MARK: - EL1 SP_EL0 handlers

@c
@export(interface)
package func handleCurrentELSP0Sync() -> Never {
    print("Exception: handleCurrentELSP0Sync")
    repeat { halt() } while true
}

@c
@export(interface)
package func handleCurrentELSP0IRQ() -> Never {
    print("Exception: handleCurrentELSP0IRQ")
    repeat { halt() } while true
}

@c
@export(interface)
package func handleCurrentELSP0FIQ() -> Never {
    print("Exception: handleCurrentELSP0FIQ")
    repeat { halt() } while true
}

@c
@export(interface)
package func handleCurrentELSP0SError() -> Never {
    print("Exception: handleCurrentELSP0SError")
    repeat { halt() } while true
}

// MARK: - EL1 SP_ELx handlers (the ones we run in)

@c
@export(interface)
package func handleCurrentELSPxSync(esr: UInt64, elr: UnsafeMutablePointer<UInt64>) {
    let ec = (esr >> 26) & 0x3F
    switch ec {
    case 0x3c:  // brk
        let imm = esr & 0xffff
        print("Exception: handleCurrentELSPxSync: brk #", terminator: "")
        print(imm)
        unsafe elr[0] += 4
    case 0x15:  // svc
        let imm = esr & 0xffff
        print("Exception: handleCurrentELSPxSync: svc #", terminator: "")
        print(imm)
    case _:
        print("Exception: handleCurrentELSPxSync: ec=", terminator: "")
        print(ec)
        repeat { halt() } while true
    }
}

/// EL1/SPx IRQ handler — the main interrupt entry point for kernel code.
@c
@export(interface)
package func handleCurrentELSPxIRQ() {
    dispatchIRQ()
}

@c
@export(interface)
package func handleCurrentELSPxFIQ() -> Never {
    print("Exception: handleCurrentELSPxFIQ")
    repeat { halt() } while true
}

@c
@export(interface)
package func handleCurrentELSPxSError() -> Never {
    print("Exception: handleCurrentELSPxSError")
    repeat { halt() } while true
}

// MARK: - Lower EL (AArch64) handlers

@c
@export(interface)
package func handleLowerELAArch64Sync() -> Never {
    print("Exception: handleLowerELAArch64Sync")
    repeat { halt() } while true
}

@c
@export(interface)
package func handleLowerELAArch64IRQ() {
    // Interrupts from a lower EL are unusual in our single-EL kernel,
    // but dispatch them the same way.
    dispatchIRQ()
}

@c
@export(interface)
package func handleLowerELAArch64FIQ() -> Never {
    print("Exception: handleLowerELAArch64FIQ")
    repeat { halt() } while true
}

@c
@export(interface)
package func handleLowerELAArch64SError() -> Never {
    print("Exception: handleLowerELAArch64SError")
    repeat { halt() } while true
}

// MARK: - Lower EL (AArch32) handlers

@c
@export(interface)
package func handleLowerELAArch32Sync() -> Never {
    print("Exception: handleLowerELAArch32Sync")
    repeat { halt() } while true
}

@c
@export(interface)
package func handleLowerELAArch32IRQ() -> Never {
    print("Exception: handleLowerELAArch32IRQ")
    repeat { halt() } while true
}

@c
@export(interface)
package func handleLowerELAArch32FIQ() -> Never {
    print("Exception: handleLowerELAArch32FIQ")
    repeat { halt() } while true
}

@c
@export(interface)
package func handleLowerELAArch32SError() -> Never {
    print("Exception: handleLowerELAArch32SError")
    repeat { halt() } while true
}
