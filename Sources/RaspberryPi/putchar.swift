/// Write a character to UART.
@_cdecl("putchar")
@discardableResult
@inlinable
public func putchar(_ c: CInt) -> CInt {
    putchar(UInt8(c))
    return c
}
