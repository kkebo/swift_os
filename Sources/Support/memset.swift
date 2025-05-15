@_cdecl("memset")
func memset(
    _ dst: UnsafeMutableRawPointer,
    _ val: CInt,
    _ len: Int,
) -> UnsafeMutableRawPointer {
    let dst = unsafe dst.bindMemory(to: UInt8.self, capacity: len)
    var span = unsafe MutableSpan(_unsafeStart: dst, count: len)
    for i in span.indices {
        span[i] = UInt8(truncatingIfNeeded: val)
    }
    return .init(dst)
}
