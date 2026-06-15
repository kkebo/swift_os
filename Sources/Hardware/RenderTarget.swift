package protocol RenderTarget<Depth>: ~Copyable, ~Escapable {
    associatedtype Depth: VolatileMappable

    @unsafe
    subscript(uncheckedX x: Int, y y: Int) -> Depth { get set }
}
