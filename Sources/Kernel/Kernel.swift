import AsmSupport
#if RASPI
    import RaspberryPi
#endif

func testMemory(from start: UInt, to end: UInt) -> UInt {
    let pat0: UInt64 = 0xaa55aa55aa55aa55
    let pat1: UInt64 = 0x55aa55aa55aa55aa
    var i = start
    while i <= end {
        let p = unsafe UnsafeMutablePointer<UInt64>(bitPattern: i + 0xffff8)!
        let old = unsafe p[0]
        defer { unsafe p[0] = old }
        unsafe p[0] = pat0
        unsafe p[0] ^= 0xffffffffffffffff
        guard unsafe p[0] == pat1 else { break }
        unsafe p[0] ^= 0xffffffffffffffff
        guard unsafe p[0] == pat0 else { break }
        i += 0x100000
    }
    return i
}

@main
struct Kernel {
    static func main() {
        #if RASPI
            initUART()

            print("Hello Swift!")
            let size: UInt = testMemory(from: 0, to: 0x3b3fffff) / 1024 / 1024
            print("memory ", terminator: "")
            print(size, terminator: "")
            print("MB")

            var fb = Framebuffer<UInt32>(width: 1920, height: 1080, pixelOrder: .rgb)
            fb.fillRect(x0: 0, y0: 0, x1: 100, y1: 100, color: 0xffffff)
            fb.drawString("Hello Swift!", x: 0, y: 100, color: 0xffffff)

            repeat { putchar(getchar()) } while true
        #else
            repeat { halt() } while true
        #endif
    }
}
