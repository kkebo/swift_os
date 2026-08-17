private import Hardware
private import KernelCore

#if RASPI
    private import RaspberryPi
#endif

#if RASPI
    private nonisolated(unsafe) var console: (any Console & ~Copyable)?
#else
    // private nonisolated(unsafe) var console: OtherConsole?
#endif

func enableConsole() {
    #if RASPI
        unsafe console = UARTConsole(uart: UART0())
    #else
        // unsafe console = OtherConsole()
        fatalError("not implemented")
    #endif
}

/// Write a character to the global console.
@c(__platform_putchar)
@export(interface)
package func putchar(_ c: UInt8) {
    if let console = unsafe console.ref {
        console.write(c)
    }
}
