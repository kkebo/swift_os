package protocol UART: ~Copyable, ~Escapable {
    func putchar(_ c: UInt8)
    func getchar() -> UInt8
}
