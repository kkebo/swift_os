package protocol RenderTarget<Depth>: ~Copyable, ~Escapable {
    associatedtype Depth: FixedWidthInteger & UnsignedInteger

    mutating func drawPoint(x: Int, y: Int, color: Depth)
}
