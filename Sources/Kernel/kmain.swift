@_cdecl("kmain")
public func kmain() {
    initUART()

    print("Hello Swift!")

    Framebuffer.shared.fillRect(x0: 0, y0: 0, x1: 100, y1: 100, color: 0xffffff)

    repeat { putchar(getchar()) } while true
}
