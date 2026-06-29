/// <https://pubs.opengroup.org/onlinepubs/9799919799/functions/memset.html>.
@c
@export(interface)
public func memset(
    _ dst: UnsafeMutableRawPointer,
    _ val: CInt,
    _ len: Int,
) -> UnsafeMutableRawPointer {
    // TODO: copy word-by-word if possible
    var i = 0
    while i < len {
        unsafe dst.storeBytes(of: UInt8(truncatingIfNeeded: val), toByteOffset: i, as: UInt8.self)
        i &+= 1
    }
    return unsafe dst
}
