package enum PixelOrder: UInt32, BitwiseCopyable, Sendable {
    case bgr = 0
    case rgb
}

package protocol Framebuffer: ~Copyable, ~Escapable, RenderTarget {
    var width: UInt32 { get }
    var height: UInt32 { get }
    var pixelOrder: PixelOrder { get }
    var buffer: UnsafeMutableBufferPointer<Depth> { get }
}

extension Framebuffer where Self: ~Copyable {
    @inline(always)
    @export(implementation)
    package mutating func drawPoint(x: Int, y: Int, color: Depth) {
        let width = Int(self.width)
        var span = unsafe self.buffer.mutableSpan
        span[y &* width &+ x] = color
    }
}
