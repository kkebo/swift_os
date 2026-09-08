private import ArchAArch64
private import AsmSupport
private import Hardware

#if RASPI4
    private let gic = GICv2(distributorBase: 0xff84_1000, cpuInterfaceBase: 0xff84_2000)
#endif

package struct RPiInterruptController {
    static func acknowledge() -> UInt32 {
        #if RASPI4
            gic.readIAR() & 0x3ff
        #else
            fatalError("not implemented")
        #endif
    }

    static func endOfInterrupt(_ intID: UInt32) {
        #if RASPI4
            gic.writeEOIR(intID)
        #else
            fatalError("not implemented")
        #endif
    }
}

extension RPiInterruptController: InterruptController {
    package static func enable() {
        #if RASPI4
            gic.enable(30)
        #else
            fatalError("not implemented")
        #endif
    }
}

private func handlePPI30() {
    print("Timer expired.")
    disableTimer()
}

@c(__platform_handle_irq)
@export(interface)
package func handleIRQ() {
    let intID = RPiInterruptController.acknowledge()

    switch intID {
    case 30: handlePPI30()
    case _:
        print("Unhandled IRQ INTID: ", terminator: "")
        print(intID)
    }

    RPiInterruptController.endOfInterrupt(intID)
}
