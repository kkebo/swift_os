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
