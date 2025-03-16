import var MailboxMessage.mbox

enum PixelOrder: UInt32 {
    case bgr = 0
    case rgb
}

@unsafe
struct Framebuffer: ~Copyable {
    /// Actual physical width.
    let width: UInt32
    /// Actual physical height.
    let height: UInt32
    /// Number of bytes per line.
    let pitch: UInt32
    /// Pixel order.
    let pixelOrder: PixelOrder
    /// Frame buffer base address.
    let baseAddress: UnsafeMutablePointer<UInt32>

    // FIXME: I don't know why, but if `init` is optimized, then the execution stops before reaching the last line.
    @_optimize(none)
    init(
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
        unsafe mbox.29 = 0

        unsafe mbox.30 = MboxTag.getPitch
        unsafe mbox.31 = 4  // TODO: Understand what this is.
        unsafe mbox.32 = 4  // TODO: Understand what this is.
        unsafe mbox.33 = 0

        unsafe mbox.34 = MboxTag.end

        guard
            mboxCall(ch: .property),  // success
            unsafe mbox.20 == depth,
            unsafe mbox.28 != 0  // pointer is not null
        else { fatalError() }

        // GPU address to ARM address
        unsafe mbox.28 &= 0x3FFF_FFFF

        unsafe self.width = mbox.10
        unsafe self.height = mbox.11
        unsafe self.pitch = mbox.33
        // swift-format-ignore: NeverForceUnwrap
        unsafe self.pixelOrder = .init(rawValue: mbox.24)!
        // swift-format-ignore: NeverForceUnwrap
        unsafe self.baseAddress = .init(bitPattern: UInt(mbox.28))!

        print("Framebufer is ready")
    }

    // FIXME: I don't know why, but if this function is optimized, memory writes won't happen.
    @_optimize(none)
    @inlinable
    func drawPoint(x: Int, y: Int, color: UInt32) {
        unsafe self.baseAddress[y * Int(self.width) + x] = color
    }

    func fillRect(x0: Int, y0: Int, x1: Int, y1: Int, color: UInt32) {
        for y in y0...y1 {
            for x in x0...x1 {
                unsafe self.drawPoint(x: x, y: y, color: color)
            }
        }
    }
}
