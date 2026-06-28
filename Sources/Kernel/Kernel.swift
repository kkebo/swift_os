private import AsmSupport
private import Hardware
private import KernelCore

#if arch(arm64)
    private import ArchAArch64
#endif

#if RASPI
    private import RaspberryPi
#endif

@main
struct Kernel {
    static func main() {
        Self.mainLoop()
    }

    @_transparent
    private static func mainLoop() -> Never {
        zeroBSS()

        #if RASPI
            let _ = UARTConsole(uart: UART0())
        #else
            // let console = OtherConsole()
            fatalError("not implemented")
        #endif

        #if arch(arm64)
            registerVectorTable()
        #endif
        enableIRQ()

        print("Hello Swift!")

        let memoryManager = MemoryManager()
        let ramLabel: StaticString = "RAM:"
        let ramTotal = memoryManager.total / 1024 / 1024
        print(ramLabel, terminator: " ")
        print(ramTotal, terminator: " ")
        print("MiB")

        #if RASPI
            let fb = RPiFramebuffer<UInt32>(width: 1920, height: 1080, pixelOrder: .rgb)
        #else
            // let fb = OtherFramebuffer()
            fatalError("not implemented")
        #endif
        var g = Graphics(target: fb)
        g.fillRect(x0: 0, y0: 0, x1: 100, y1: 100, color: 0xffffff)
        g.drawString("Hello Swift!", x: 0, y: 100, color: 0xffffff)

        #if RASPI
            g.drawString(ramLabel, x: 0, y: 100 + fontHeight, color: 0xffffff)
            g.drawString(
                ramTotal,
                x: (ramLabel.utf8CodeUnitCount + 1) * fontWidth,
                y: 100 + fontHeight,
                color: 0xffffff,
            )
        #endif

        #if arch(arm64)
            // For debugging
            brk0()

            let el = getEL()
            let elLabel: StaticString = "Exception Level:"
            print(elLabel, terminator: " ")
            print(el)
            #if RASPI
                g.drawString(elLabel, x: 0, y: 100 + 2 * fontHeight, color: 0xffffff)
                g.drawString(
                    el,
                    x: (elLabel.utf8CodeUnitCount + 1) * fontWidth,
                    y: 100 + 2 * fontHeight,
                    color: 0xffffff,
                )
            #endif
        #endif

        repeat { halt() } while true
    }
}
