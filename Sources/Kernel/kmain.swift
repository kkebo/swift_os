@_cdecl("kmain")
public func kmain() {
    initUART()

    print("Hello Swift!")

    let fb = Framebuffer(width: 1920, height: 1080, depth: 32, pixelOrder: .rgb)
    fb.fillRect(x0: 0, y0: 0, x1: 100, y1: 100, color: 0xffffff)

    repeat { putchar(getchar()) } while true
}
