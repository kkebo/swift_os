// FIXME: Use the package access level when swiftlang/swift#90225 is fixed
// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
public protocol Timer: ~Copyable, ~Escapable {
    var counter: UInt64 { get }
    var freq: UInt64 { get }
    func enable()
    func disable()
}
