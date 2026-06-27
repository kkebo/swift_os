/// <https://pubs.opengroup.org/onlinepubs/9799919799/functions/memmove.html>.
@c
@export(interface)
public func memmove(
    _ dst: UnsafeMutableRawPointer,
    _ src: UnsafeRawPointer,
    _ n: Int,
) -> UnsafeMutableRawPointer {
    let d = unsafe dst.bindMemory(to: UInt8.self, capacity: n)
    let s = unsafe src.bindMemory(to: UInt8.self, capacity: n)
    if unsafe dst < src {
        var i = 0
        while i < n {
            unsafe d[i] = s[i]
            i += 1
        }
    } else {
        var i = n
        while i > 0 {
            i -= 1
            unsafe d[i] = s[i]
        }
    }
    return unsafe dst
}
