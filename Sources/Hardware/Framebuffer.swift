// FIXME: Use the package access level when swiftlang/swift#90225 is fixed
// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
public enum PixelOrder: UInt32, BitwiseCopyable, Sendable {
    case bgr = 0
    case rgb
}

// FIXME: Use the package access level when swiftlang/swift#90225 is fixed
// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
public protocol Framebuffer: ~Copyable, ~Escapable, RenderTarget {
    var width: UInt32 { get }
    var height: UInt32 { get }
    var pixelOrder: PixelOrder { get }
    var baseAddress: UInt { get }
}

extension Framebuffer where Self: ~Copyable & ~Escapable {
    @inline(always)
    @export(implementation)
    @unsafe
    package subscript(uncheckedX x: Int, y y: Int) -> Depth {
        get {
            let x = UInt(x)
            let y = UInt(y)
            let width = UInt(self.width)
            let stride = UInt(MemoryLayout<Depth>.stride)
            return unsafe Depth.volatileLoad(from: self.baseAddress &+ (y &* width &+ x) &* stride)
        }
        set(color) {
            let x = UInt(x)
            let y = UInt(y)
            let width = UInt(self.width)
            let stride = UInt(MemoryLayout<Depth>.stride)
            unsafe Depth.volatileStore(color, to: self.baseAddress &+ (y &* width &+ x) &* stride)
        }
    }
}
