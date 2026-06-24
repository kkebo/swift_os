private import AsmSupport

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

@c
@export(interface)
package func handleCurrentELSPxSync(esr: UInt64, elr: UnsafeMutablePointer<UInt64>) {
    let ec = (esr >> 26) & 0x3f
    switch ec {
    case 0x3c:  // brk
        let imm = UInt16(truncatingIfNeeded: esr)
        print("Exception: handleCurrentELSPxSync: brk #", terminator: "")
        print(imm)
        switch imm {
        // debug
        case 0: unsafe elr.pointee += 4
        case _: repeat { halt() } while true
        }
    case 0x15:  // svc
        let imm = UInt16(truncatingIfNeeded: esr)
        print("Exception: handleCurrentELSPxSync: svc #", terminator: "")
        print(imm)
    case _:
        print("Exception: handleCurrentELSPxSync: ", terminator: "")
        print(ec)
        repeat { halt() } while true
    }
}

@c
@export(interface)
package func handleCurrentELSPxIRQ() -> Never {
    print("Exception: handleCurrentELSPxIRQ")
    repeat { halt() } while true
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

@c
@export(interface)
package func handleLowerELAArch64Sync() -> Never {
    print("Exception: handleLowerELAArch64Sync")
    repeat { halt() } while true
}

@c
@export(interface)
package func handleLowerELAArch64IRQ() -> Never {
    print("Exception: handleLowerELAArch64IRQ")
    repeat { halt() } while true
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
