/// <https://pubs.opengroup.org/onlinepubs/9799919799/functions/memset.html>.
@c
@export(interface)
public func memset(
    _ dst: UnsafeMutableRawPointer,
    _ val: CInt,
    _ len: Int,
) -> UnsafeMutableRawPointer {
    let d = unsafe dst.bindMemory(to: UInt8.self, capacity: len)
    var i = 0
    while i < len {
        unsafe d[i] = UInt8(truncatingIfNeeded: val)
        i &+= 1
    }
    return unsafe dst
}
