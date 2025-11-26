#if RASPI
    public import RaspberryPi
#endif

/// <https://pubs.opengroup.org/onlinepubs/9799919799/functions/putchar.html>.
@c
@discardableResult
@inline(always)
@inlinable  // @export(implementation, interface)
public func putchar(_ c: CInt) -> CInt {
    #if RASPI
        putchar(UInt8(c))
    #endif
    return c
}
