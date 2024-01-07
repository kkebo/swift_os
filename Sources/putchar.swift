let uart = UnsafeMutablePointer<UInt8>(bitPattern: 0x09000000)!

@_silgen_name("putchar")
@discardableResult
public func putchar(_ c: CInt) -> CInt {
    uart[0] = UInt8(c)
    return c
}
