package protocol RenderTarget<Depth>: ~Copyable, ~Escapable {
    associatedtype Depth: VolatileMappable

    var width: UInt32 { get }
    var height: UInt32 { get }

    @unsafe
    subscript(uncheckedX x: Int, y y: Int) -> Depth { get set }
}
