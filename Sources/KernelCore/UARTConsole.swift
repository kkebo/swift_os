public import Hardware

// FIXME: Use the package access level when swiftlang/swift#90225 is fixed
// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
public struct UARTConsole<T: ~Copyable & UART>: ~Copyable {
    public let uart: T

    @inline(always)
    @export(implementation)
    public init(uart: consuming T) {
        self.uart = uart
    }
}

extension UARTConsole: Console where T: ~Copyable {
    @inline(always)
    @export(implementation)
    package func write(_ c: UInt8) {
        self.uart.putchar(c)
    }
}
