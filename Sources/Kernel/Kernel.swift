#if RASPI
    private import RaspberryPi
    private import UART0
#endif

@main
struct Kernel {
    static func main() {
        uart_init()
        putchar(UInt8(UInt32("A" as Unicode.Scalar)))
        repeat { putchar(getchar()) } while true
    }
}
