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

        #if arch(arm64)
            enableInitialMMU()
        #endif

        enableSerialConsole()

        print("Starting swift_os...")

        #if arch(arm64)
            registerVectorTable()
        #endif
        enableIRQ()

        #if RASPI
            let fb = RPiFramebuffer<UInt32>(width: 1024, height: 576, pixelOrder: .rgb)
        #else
            // let fb = OtherFramebuffer()
            fatalError("not implemented")
        #endif

        let bg: UInt32 = 0xf4faef
        let fg: UInt32 = 0x3a5324
        enableGraphicsConsole(target: fb, fgColor: fg, bgColor: bg)

        #if RASPI
            let memoryManager = MemoryManager()
            let ramTotal = memoryManager.total / 1024 / 1024
            print("RAM:", terminator: " ")
            print(ramTotal, terminator: " ")
            print("MiB")
        #endif

        var gfx = Graphics(target: fb)
        gfx.fill(color: bg)

        #if arch(arm64)
            // For debugging
            brk0()

            print("Exception Level:", terminator: " ")
            print(getEL())
        #endif

        unsafe gfxConsole?.render(on: &gfx)

        gfx.synchronize()

        repeat { halt() } while true
    }
}
