@_extern(c, "__platform_putchar")
@usableFromInline
package func putchar(_ c: UInt8)

/// <https://pubs.opengroup.org/onlinepubs/9799919799/functions/putchar.html>.
@c
@discardableResult
@inline(always)
@inlinable  // @export(implementation, interface)
public func putchar(_ c: CInt) -> CInt {
    putchar(UInt8(c))
    return c
}
