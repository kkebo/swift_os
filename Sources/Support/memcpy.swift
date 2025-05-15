@_cdecl("memcpy")
func memcpy(
    _ dst: UnsafeMutableRawPointer,
    _ src: UnsafeRawPointer,
    _ n: Int,
) -> UnsafeMutableRawPointer {
    let dst = unsafe dst.bindMemory(to: UInt8.self, capacity: n)
    var dstSpan = unsafe MutableSpan(_unsafeStart: dst, count: n)
    let src = unsafe src.bindMemory(to: UInt8.self, capacity: n)
    let srcSpan = unsafe Span(_unsafeStart: src, count: n)
    for i in dstSpan.indices {
        dstSpan[i] = srcSpan[i]
    }
    return .init(dst)
}
