@_silgen_name("putchar")
@discardableResult
@inlinable
public func putchar(_ c: CInt) -> CInt {
    putchar(UInt8(c))
    return c
}
