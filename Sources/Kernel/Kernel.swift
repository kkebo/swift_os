private import AsmSupport

#if RASPI
    private import RaspberryPi
#endif

@main
struct Kernel {
    static func main() {
        #if RASPI
            initUART()

            print("Hello Swift!")

            let memoryManager = MemoryManager()
            print("RAM:", terminator: " ")
            print(memoryManager.total / 1024 / 1024, terminator: " ")
            print("MiB")

            var fb = Framebuffer<UInt32>(width: 1920, height: 1080, pixelOrder: .rgb)
            fb.fillRect(x0: 0, y0: 0, x1: 100, y1: 100, color: 0xffffff)
            fb.drawString("Hello Swift!", x: 0, y: 100, color: 0xffffff)

            repeat { putchar(getchar()) } while true
        #else
            repeat { halt() } while true
        #endif
    }
}
