/// Write a character to UART.
@c
@discardableResult
@inline(always)
public func putchar(_ c: CInt) -> CInt {
    putchar(UInt8(c))
    return c
}
