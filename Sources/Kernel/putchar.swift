#if compiler(>=6.1)
    @_cdecl("putchar")
#else
    @_silgen_name("putchar")
#endif
@discardableResult
@inlinable
public func putchar(_ c: CInt) -> CInt {
    putchar(UInt8(c))
    return c
}
