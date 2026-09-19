private import AsmSupport
private import EarlyKernel
private import Hardware
private import KernelCore

#if arch(arm64)
    private import ArchAArch64
    private import EarlyArchAArch64
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

        #if arch(arm64)
            enableInitialMMU()
        #endif

        enableSerialConsole()

        print("Starting swift_os...")

        #if arch(arm64)
            registerVectorTable()
        #endif
        #if RASPI
            typealias InterruptController = RPiInterruptController
        #else
            // typealias InterruptController = OtherInterruptController
            #error("not implemented")
        #endif
        InterruptController.enable()
        enableCPUIRQ()

        #if RASPI
            let memoryManager = MemoryManager()
            let ramTotal = memoryManager.total / 1024 / 1024
            print("RAM:", terminator: " ")
            print(ramTotal, terminator: " ")
            print("MiB")
        #endif

        #if RASPI
            let fb = RPiFramebuffer<UInt32>(width: 1024, height: 576, pixelOrder: .rgb)
        #else
            // let fb = OtherFramebuffer()
            #error("not implemented")
        #endif
        var gfx = Graphics(target: fb)
        let bg: UInt32 = 0xf4faef
        let fg: UInt32 = 0x3a5324
        enableGraphicsConsole(gfx: &gfx, fgColor: fg, bgColor: bg)
        gfx.fill(color: bg)

        #if arch(arm64)
            // For debugging
            brk0()

            print("Exception Level:", terminator: " ")
            print(CurrentEL.read().el)
        #endif

        #if arch(arm64)
            let timer = GenericTimer()
            timer.enable()
        #else
            // let timer = OtherTimer()
            #error("Timer is not yet implemented in this architecture.")
        #endif

        gfx.synchronize()

        repeat {
            gfx.fillRect(x0: 0, y0: gfx.height - fontHeight, x1: gfx.width, y1: gfx.height, color: bg)
            gfx.drawString(timer.counter / timer.freq, x: 0, y: gfx.height - fontHeight, color: fg)
            gfx.synchronize()

            halt()
        } while true
    }
}
