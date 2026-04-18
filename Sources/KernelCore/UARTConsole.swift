package import Hardware

package struct UARTConsole<T: ~Copyable & UART>: ~Copyable {
    package let uart: T

    package init(uart: consuming T) {
        self.uart = uart
    }
}

extension UARTConsole: Console {
    package func write(_ c: UInt8) {
        self.uart.putchar(c)
    }
}
