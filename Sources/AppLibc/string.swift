/// <https://pubs.opengroup.org/onlinepubs/9799919799/functions/memcpy.html>.
@c
@export(interface)
public func memcpy(
    _ dst: UnsafeMutableRawPointer,
    _ src: UnsafeRawPointer,
    _ n: Int,
) -> UnsafeMutableRawPointer {
    // TODO: copy word-by-word if possible
    var i = 0
    while i < n {
        unsafe dst.storeBytes(of: src.load(fromByteOffset: i, as: UInt8.self), toByteOffset: i, as: UInt8.self)
        i &+= 1
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
    if unsafe dst < src {
        // TODO: copy word-by-word if possible
        var i = 0
        while i < n {
            unsafe dst.storeBytes(of: src.load(fromByteOffset: i, as: UInt8.self), toByteOffset: i, as: UInt8.self)
            i &+= 1
        }
    } else {
        // TODO: copy word-by-word if possible
        var i = n
        while i > 0 {
            i &-= 1
            unsafe dst.storeBytes(of: src.load(fromByteOffset: i, as: UInt8.self), toByteOffset: i, as: UInt8.self)
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
    // TODO: copy word-by-word if possible
    var i = 0
    while i < len {
        unsafe dst.storeBytes(of: UInt8(truncatingIfNeeded: val), toByteOffset: i, as: UInt8.self)
        i &+= 1
    }
    return unsafe dst
}
