@main
struct Kernel {
    static func main() {
        initUART()

        print("Hello Swift!")

        let fb = unsafe Framebuffer(width: 1920, height: 1080, depth: 32, pixelOrder: .rgb)
        unsafe fb.fillRect(x0: 0, y0: 0, x1: 100, y1: 100, color: 0xffffff)
        unsafe fb.drawString("Hello Swift!", x: 0, y: 100, color: 0xffffff)

        repeat { putchar(getchar()) } while true
    }
}
