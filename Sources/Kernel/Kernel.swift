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

        enableConsole()

        #if arch(arm64)
            registerVectorTable()
        #endif
        enableIRQ()

        print("Hello Swift!")

        #if RASPI
            let memoryManager = MemoryManager()
            let ramLabel: StaticString = "RAM:"
            let ramTotal = memoryManager.total / 1024 / 1024
            print(ramLabel, terminator: " ")
            print(ramTotal, terminator: " ")
            print("MiB")
        #endif

        #if RASPI
            let fb = RPiFramebuffer<UInt32>(width: 1024, height: 576, pixelOrder: .rgb)
        #else
            // let fb = OtherFramebuffer()
            fatalError("not implemented")
        #endif
        var gfx = Graphics(target: fb)
        let bg: UInt32 = 0xf4faef
        let fg: UInt32 = 0x3a5324
        let accent: UInt32 = 0x68af2f
        gfx.fillRect(x0: 0, y0: 0, x1: gfx.width - 1, y1: gfx.height - 1, color: bg)
        gfx.drawString("Hello Swift!", x: 0, y: 0, color: fg)

        #if RASPI
            gfx.drawString(ramLabel, x: 0, y: fontHeight, color: fg)
            gfx.drawString(ramTotal, x: (ramLabel.utf8CodeUnitCount + 1) * fontWidth, y: fontHeight, color: accent)
        #endif

        #if arch(arm64)
            // For debugging
            brk0()

            let el = getEL()
            let elLabel: StaticString = "Exception Level:"
            print(elLabel, terminator: " ")
            print(el)
            gfx.drawString(elLabel, x: 0, y: 2 * fontHeight, color: fg)
            gfx.drawString(el, x: (elLabel.utf8CodeUnitCount + 1) * fontWidth, y: 2 * fontHeight, color: accent)
        #endif

        gfx.synchronize()

        repeat { halt() } while true
    }
}
