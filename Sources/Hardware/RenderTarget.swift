package protocol RenderTarget<Depth>: ~Copyable, ~Escapable {
    associatedtype Depth: UnsignedInteger

    func drawPoint(x: Int, y: Int, color: Depth)
}
