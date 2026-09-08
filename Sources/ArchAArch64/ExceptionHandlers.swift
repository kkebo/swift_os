private import AsmSupport

@c
@export(interface)
package func handleCurrentELSP0Sync() -> Never {
    print("Exception: ", terminator: "")
    print(#function)
    repeat { halt() } while true
}

@c
@export(interface)
package func handleCurrentELSP0IRQ() -> Never {
    print("Exception: ", terminator: "")
    print(#function)
    repeat { halt() } while true
}

@c
@export(interface)
package func handleCurrentELSP0FIQ() -> Never {
    print("Exception: ", terminator: "")
    print(#function)
    repeat { halt() } while true
}

@c
@export(interface)
package func handleCurrentELSP0SError() -> Never {
    print("Exception: ", terminator: "")
    print(#function)
    repeat { halt() } while true
}

@c
@export(interface)
package func handleCurrentELSPxSync(esr: UInt64, elr: UnsafeMutablePointer<UInt64>) {
    print("Exception: ", terminator: "")
    print(#function, terminator: ": ")

    let ec = (esr >> 26) & 0x3f
    let iss = esr & 0x01ff_ffff
    func printValues() {
        print("  ELR = ", terminator: "")
        print(unsafe elr.pointee)
        print("  ESR = ", terminator: "")
        print(esr)
        print("  EC  = ", terminator: "")
        print(ec)
        print("  ISS = ", terminator: "")
        print(iss)
    }

    switch ec {
    case 0x3c:
        print("Breakpoint")
        printValues()
        switch iss {
        // debug
        case 0: unsafe elr.pointee += 4
        case _: repeat { halt() } while true
        }
    case 0x15:
        print("SVC")
        printValues()
    case 0x25:
        print("Data Abort")
        printValues()
        let dfsc = iss & 0x3f
        print("  DFSC = ", terminator: "")
        print(dfsc)
        repeat { halt() } while true
    case _:
        print("Other")
        printValues()
        repeat { halt() } while true
    }
}

@c
@export(interface)
package func handleCurrentELSPxIRQ() -> Never {
    print("Exception: ", terminator: "")
    print(#function)
    repeat { halt() } while true
}

@c
@export(interface)
package func handleCurrentELSPxFIQ() -> Never {
    print("Exception: ", terminator: "")
    print(#function)
    repeat { halt() } while true
}

@c
@export(interface)
package func handleCurrentELSPxSError() -> Never {
    print("Exception: ", terminator: "")
    print(#function)
    repeat { halt() } while true
}

@c
@export(interface)
package func handleLowerELAArch64Sync() -> Never {
    print("Exception: ", terminator: "")
    print(#function)
    repeat { halt() } while true
}

@c
@export(interface)
package func handleLowerELAArch64IRQ() -> Never {
    print("Exception: ", terminator: "")
    print(#function)
    repeat { halt() } while true
}

@c
@export(interface)
package func handleLowerELAArch64FIQ() -> Never {
    print("Exception: ", terminator: "")
    print(#function)
    repeat { halt() } while true
}

@c
@export(interface)
package func handleLowerELAArch64SError() -> Never {
    print("Exception: ", terminator: "")
    print(#function)
    repeat { halt() } while true
}

@c
@export(interface)
package func handleLowerELAArch32Sync() -> Never {
    print("Exception: ", terminator: "")
    print(#function)
    repeat { halt() } while true
}

@c
@export(interface)
package func handleLowerELAArch32IRQ() -> Never {
    print("Exception: ", terminator: "")
    print(#function)
    repeat { halt() } while true
}

@c
@export(interface)
package func handleLowerELAArch32FIQ() -> Never {
    print("Exception: ", terminator: "")
    print(#function)
    repeat { halt() } while true
}

@c
@export(interface)
package func handleLowerELAArch32SError() -> Never {
    print("Exception: ", terminator: "")
    print(#function)
    repeat { halt() } while true
}
