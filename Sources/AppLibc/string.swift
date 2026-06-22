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
        var i = n - 1
        while i >= 0 {
            unsafe d[i] = s[i]
            i -= 1
        }
    }
    return unsafe dst
}

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
        i += 1
    }
    return unsafe dst
}
