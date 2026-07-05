#if RASPI
    private import RaspberryPi
#endif

@main
struct Kernel {
    static func main() {
        putchar(UInt8(UInt32("A" as Unicode.Scalar)))
        repeat { putchar(getchar()) } while true
    }
}
