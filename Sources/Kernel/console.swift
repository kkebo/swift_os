import Hardware
import KernelCore

#if RASPI
    private import RaspberryPi
#endif

#if RASPI
    private nonisolated(unsafe) var serialConsole: UARTConsole<UART0>?
    nonisolated(unsafe) var gfxConsole: GraphicsConsole<UInt32>?
#else
    // private nonisolated(unsafe) var console: OtherConsole?
#endif

func enableSerialConsole() {
    #if RASPI
        unsafe serialConsole = .init(uart: UART0())
    #else
        // unsafe console = OtherConsole()
        fatalError("not implemented")
    #endif
}

func enableGraphicsConsole<Target>(target: borrowing Target, fgColor: UInt32, bgColor: UInt32)
where
    Target: RenderTarget & ~Copyable,
    Target.Depth == UInt32
{
    unsafe gfxConsole = .init(target: target, fgColor: fgColor, bgColor: bgColor)
}

/// Write a character to the global console.
@c(__kernel_putchar)
@export(interface)
package func putchar(_ c: UInt8) {
    unsafe serialConsole?.write(c)
    unsafe gfxConsole?.write(c)
}
