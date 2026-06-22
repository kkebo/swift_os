/// <https://pubs.opengroup.org/onlinepubs/9799919799/functions/memcpy.html>.
@c
@export(interface)
public func memcpy(
    _ dst: UnsafeMutableRawPointer,
    _ src: UnsafeRawPointer,
    _ n: Int,
) -> UnsafeMutableRawPointer {
    let d = unsafe dst.bindMemory(to: UInt8.self, capacity: n)
    let s = unsafe src.bindMemory(to: UInt8.self, capacity: n)
    var i = 0
    while i < n {
        unsafe d[i] = s[i]
        i += 1
    }
    return unsafe dst
}
