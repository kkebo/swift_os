/// <https://pubs.opengroup.org/onlinepubs/9799919799/functions/memcpy.html>.
@c
@export(interface)
public func memcpy(
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

/// <https://pubs.opengroup.org/onlinepubs/9799919799/functions/memmove.html>.
@c
@export(interface)
public func memmove(
    _ dst: UnsafeMutableRawPointer,
    _ src: UnsafeRawPointer,
    _ n: Int,
) -> UnsafeMutableRawPointer {
    let dst = unsafe dst.bindMemory(to: UInt8.self, capacity: n)
    var dstSpan = unsafe MutableSpan(_unsafeStart: dst, count: n)
    let src = unsafe src.bindMemory(to: UInt8.self, capacity: n)
    let srcSpan = unsafe Span(_unsafeStart: src, count: n)
    if unsafe dst < src {
        for i in dstSpan.indices {
            dstSpan[i] = srcSpan[i]
        }
    } else {
        for i in dstSpan.indices.reversed() {
            dstSpan[i] = srcSpan[i]
        }
    }
    return .init(dst)
}

/// <https://pubs.opengroup.org/onlinepubs/9799919799/functions/memset.html>.
@c
@export(interface)
public func memset(
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
