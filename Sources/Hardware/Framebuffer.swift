package enum PixelOrder: UInt32, BitwiseCopyable, Sendable {
    case bgr = 0
    case rgb
}

package protocol Framebuffer: ~Copyable, ~Escapable, RenderTarget {
    var width: UInt32 { get }
    var height: UInt32 { get }
    var pixelOrder: PixelOrder { get }
    var baseAddress: UnsafeMutablePointer<Depth> { get }
    var pixelCount: Int { get }
}

extension Framebuffer where Self: ~Copyable {
    @inline(always)
    @export(implementation)
    package func drawPoint(x: Int, y: Int, color: Depth) {
        let width = Int(self.width)
        var buf = unsafe MutableSpan(_unsafeStart: self.baseAddress, count: self.pixelCount)
        buf[y &* width &+ x] = color
    }
}
