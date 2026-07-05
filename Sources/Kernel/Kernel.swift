#if RASPI
    private import RaspberryPi
#endif

@main
struct Kernel {
    static func main() {
        let uart = UART0()
        uart.putchar(UInt8(UInt32("A" as Unicode.Scalar)))
        repeat { uart.putchar(uart.getchar()) } while true
    }
}
