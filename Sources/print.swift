// TODO: Remove when https://github.com/apple/swift/pull/70685 is merged
public func print(_ s: StaticString, terminator: StaticString = "\n") {
    var p = s.utf8Start
    while p.pointee != 0 {
        putchar(CInt(p.pointee))
        p += 1
    }
    p = terminator.utf8Start
    while p.pointee != 0 {
        putchar(CInt(p.pointee))
        p += 1
    }
}
