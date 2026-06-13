package protocol RenderTarget<Depth>: ~Copyable, ~Escapable {
    associatedtype Depth: UnsignedInteger

    mutating func drawPoint(x: Int, y: Int, color: Depth)
}
