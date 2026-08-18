private import KernelCore

#if RASPI
    private import RaspberryPi
#endif

#if RASPI
    private nonisolated(unsafe) var console: UARTConsole<UART0>?
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
@c(__kernel_putchar)
@export(interface)
package func putchar(_ c: UInt8) {
    unsafe console?.write(c)
}
