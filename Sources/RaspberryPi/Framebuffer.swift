// swift-format-ignore-file
import Font

package enum PixelOrder: UInt32, BitwiseCopyable, Sendable {
    case bgr = 0
    case rgb
}

@_optimize(none)
private func setFramebufferMbox(
    width: UInt32,
    height: UInt32,
    depth: UInt32,
    pixelOrder: PixelOrder,
) {
    unsafe mbox.0 = 35 * 4
    unsafe mbox.1 = 0  // request

    unsafe mbox.2 = MboxTag.setPhysicalWH
    unsafe mbox.3 = 8  // TODO: Understand what this is.
    unsafe mbox.4 = 0  // TODO: Understand what this is.
    unsafe mbox.5 = width
    unsafe mbox.6 = height

    unsafe mbox.7 = MboxTag.setVirtualWH
    unsafe mbox.8 = 8  // TODO: Understand what this is.
    unsafe mbox.9 = 8  // TODO: Understand what this is.
    unsafe mbox.10 = width
    unsafe mbox.11 = height

    unsafe mbox.12 = MboxTag.setVirtualOffset
    unsafe mbox.13 = 8  // TODO: Understand what this is.
    unsafe mbox.14 = 8  // TODO: Understand what this is.
    unsafe mbox.15 = 0
    unsafe mbox.16 = 0

    unsafe mbox.17 = MboxTag.setDepth
    unsafe mbox.18 = 4  // TODO: Understand what this is.
    unsafe mbox.19 = 4  // TODO: Understand what this is.
    unsafe mbox.20 = depth

    unsafe mbox.21 = MboxTag.setPixelOrder
    unsafe mbox.22 = 4  // TODO: Understand what this is.
    unsafe mbox.23 = 4  // TODO: Understand what this is.
    unsafe mbox.24 = pixelOrder.rawValue

    unsafe mbox.25 = MboxTag.allocateBuffer
    unsafe mbox.26 = 8  // TODO: Understand what this is.
    unsafe mbox.27 = 8  // TODO: Understand what this is.
    unsafe mbox.28 = 4096  // FrameBufferInfo.pointer
    unsafe mbox.29 = 0  //FrameBufferInfo.size

    unsafe mbox.30 = MboxTag.getPitch
    unsafe mbox.31 = 4  // TODO: Understand what this is.
    unsafe mbox.32 = 4  // TODO: Understand what this is.
    unsafe mbox.33 = 0

    unsafe mbox.34 = MboxTag.end
}

@safe
package struct Framebuffer<Depth: UnsignedInteger>: ~Copyable {
    /// Actual physical width.
    package let width: UInt32
    /// Actual physical height.
    package let height: UInt32
    /// Pixel order.
    package let pixelOrder: PixelOrder
    /// Framebuffer base address.
    private let baseAddress: UnsafeMutablePointer<Depth>
    /// The number of pixels of Framebuffer.
    private let pixelCount: Int

    package init(
        width: UInt32,
        height: UInt32,
        pixelOrder: PixelOrder,
    ) {
        let depth = UInt32(MemoryLayout<Depth>.size &* 8)
        setFramebufferMbox(width: width, height: height, depth: depth, pixelOrder: pixelOrder)

        // success?
        guard mboxCall(ch: .property) else { fatalError() }

        let pixelCount = unsafe Int(mbox.29) / MemoryLayout<Depth>.stride

        guard
            unsafe mbox.20 == depth,
            unsafe mbox.28 != 0,  // pointer is not null
            unsafe pixelCount == mbox.10 &* mbox.11
        else { fatalError() }

        self.width = unsafe mbox.10
        self.height = unsafe mbox.11
        // swift-format-ignore: NeverForceUnwrap
        self.pixelOrder = unsafe .init(rawValue: mbox.24)!
        // GPU address to ARM address
        let addr = unsafe UInt(mbox.28 & 0x3FFF_FFFF)
        // swift-format-ignore: NeverForceUnwrap
        unsafe self.baseAddress = UnsafeMutableRawPointer(bitPattern: addr)!
            .bindMemory(to: Depth.self, capacity: pixelCount)
        self.pixelCount = pixelCount

        print("Framebufer is ready")
    }

    @inlinable
    package func drawPoint(x: Int, y: Int, color: Depth) {
        let i = y &* Int(self.width) &+ x
        guard i < self.pixelCount else { fatalError() }
        unsafe self.baseAddress[i] = color
    }

    package func fillRect(x0: Int, y0: Int, x1: Int, y1: Int, color: Depth) {
        for y in y0...y1 {
            for x in x0...x1 {
                self.drawPoint(x: x, y: y, color: color)
            }
        }
    }

    package func drawChar(_ c: UInt8, x: Int, y: Int, color: Depth) {
        guard c < font.count else { return }
        for i in 0..<fontHeight {
            for j in 0..<fontWidth {
                if font[Int(c)][i] & 1 << j != 0 {
                    self.drawPoint(x: x &+ j, y: y &+ i, color: color)
                }
            }
        }
    }

    package func drawString(_ s: StaticString, x: Int, y: Int, color: Depth) {
        let span = unsafe Span(_unsafeStart: s.utf8Start, count: s.utf8CodeUnitCount)
        var x = x
        var y = y
        for i in span.indices {
            switch span[i] {
            case 0x0d: x = 0
            case 0x0a:
                x = 0
                y &+= fontHeight
            case let c:
                self.drawChar(c, x: x, y: y, color: color)
                x &+= fontWidth
            }
        }
    }
}
