@_silgen_name("memset")
func memset(
    _ dst: UnsafeMutableRawPointer,
    _ val: CInt,
    _ len: Int,
) -> UnsafeMutableRawPointer {
    unsafe dst.withMemoryRebound(to: UInt8.self, capacity: len) { dst in
        for i in 0..<len {
            unsafe dst[i] = UInt8(truncatingIfNeeded: val)
        }
    }
    return unsafe dst
}
