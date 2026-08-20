import Hardware
import KernelCore

#if RASPI
    import RaspberryPi
#endif

#if RASPI
    typealias GFXRenderTarget = RPiFramebuffer<UInt32>
    private nonisolated(unsafe) var serialConsole: UARTConsole<UART0>?
#else
    // typealias GFXRenderTarget = OtherRenderTarget
    // private nonisolated(unsafe) var console: OtherConsole?
#endif
nonisolated(unsafe) var gfxConsole: GraphicsConsole<GFXRenderTarget>?

func enableSerialConsole() {
    #if RASPI
        unsafe serialConsole = .init(uart: UART0())
    #else
        // unsafe console = OtherConsole()
        fatalError("not implemented")
    #endif
}

func enableGraphicsConsole(gfx: inout Graphics<GFXRenderTarget>, fgColor: UInt32, bgColor: UInt32) {
    unsafe gfxConsole = .init(gfx: &gfx, fgColor: fgColor, bgColor: bgColor)
}

/// Write a character to the global console.
@c(__kernel_putchar)
@export(interface)
package func putchar(_ c: UInt8) {
    unsafe serialConsole?.write(c)
    unsafe gfxConsole?.write(c)
}
