// FIXME: Use the package access level when swiftlang/swift#90225 is fixed
// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
public protocol RenderTarget<Depth>: ~Copyable, ~Escapable {
    associatedtype Depth: VolatileMappable

    var width: UInt32 { get }
    var height: UInt32 { get }

    @unsafe
    subscript(uncheckedX x: Int, y y: Int) -> Depth { get set }

    func synchronize()
}
