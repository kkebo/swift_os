package import Hardware

package struct UARTConsole<T: ~Copyable & UART>: ~Copyable {
    package let uart: T

    @_transparent
    package init(uart: consuming T) {
        self.uart = uart
    }
}

extension UARTConsole: Console {
    @_transparent
    package func write(_ c: UInt8) {
        self.uart.putchar(c)
    }
}
