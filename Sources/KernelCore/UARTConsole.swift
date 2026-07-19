package import Hardware

package struct UARTConsole<T: ~Copyable & UART>: ~Copyable {
    package let uart: T

    @_transparent
    @export(implementation)
    package init(uart: consuming T) {
        self.uart = uart
    }
}

extension UARTConsole: Console {
    @_transparent
    @export(implementation)
    package func write(_ c: UInt8) {
        self.uart.putchar(c)
    }
}
