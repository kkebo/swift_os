@preconcurrency import var MailboxMessage.mbox

enum PixelOrder {
    case bgr
    case rgb
}

struct Framebuffer: ~Copyable {
    /// Actual physical width.
    let width: UInt32
    /// Actual physical height.
    let height: UInt32
    /// Number of bytes per line.
    let pitch: UInt32
    /// Pixel order.
    let pixelOrder: PixelOrder
    /// Frame buffer base address in bytes.
    let baseAddress: UInt

    // swift-format-ignore: NeverForceUnwrap
    @inlinable
    var pointer: UnsafeMutablePointer<UInt32> {
        .init(bitPattern: self.baseAddress)!
    }

    // FIXME: it doesn't work on a real hardware
    // static let shared = Self()

    init() {
        mbox.0 = 35 * 4
        mbox.1 = 0  // request

        mbox.2 = MboxTag.setPhysicalWH
        mbox.3 = 8  // TODO: Understand what this is.
        mbox.4 = 0  // TODO: Understand what this is.
        mbox.5 = 1920
        mbox.6 = 1080

        mbox.7 = MboxTag.setVirtualWH
        mbox.8 = 8  // TODO: Understand what this is.
        mbox.9 = 8  // TODO: Understand what this is.
        mbox.10 = 1920
        mbox.11 = 1080

        mbox.12 = MboxTag.setVirtualOffset
        mbox.13 = 8  // TODO: Understand what this is.
        mbox.14 = 8  // TODO: Understand what this is.
        mbox.15 = 0
        mbox.16 = 0

        mbox.17 = MboxTag.setDepth
        mbox.18 = 4  // TODO: Understand what this is.
        mbox.19 = 4  // TODO: Understand what this is.
        mbox.20 = 32

        mbox.21 = MboxTag.setPixelOrder
        mbox.22 = 4  // TODO: Understand what this is.
        mbox.23 = 4  // TODO: Understand what this is.
        mbox.24 = 1  // RGB

        mbox.25 = MboxTag.allocateBuffer
        mbox.26 = 8  // TODO: Understand what this is.
        mbox.27 = 8  // TODO: Understand what this is.
        mbox.28 = 4096  // FrameBufferInfo.pointer
        mbox.29 = 0

        mbox.30 = MboxTag.getPitch
        mbox.31 = 4  // TODO: Understand what this is.
        mbox.32 = 4  // TODO: Understand what this is.
        mbox.33 = 0

        mbox.34 = MboxTag.end

        guard
            mboxCall(ch: .property),  // success
            mbox.20 == 32,  // depth
            mbox.28 != 0  // pointer is not null
        else { fatalError() }

        // GPU address to ARM address
        mbox.28 &= 0x3FFF_FFFF

        self.width = mbox.10
        self.height = mbox.11
        self.pitch = mbox.33
        self.pixelOrder =
            switch mbox.24 {
            case 0: .bgr
            case 1: .rgb
            case _: preconditionFailure("unreachable")
            }
        self.baseAddress = UInt(mbox.28)

        print("Framebufer is ready")
    }

    @inlinable
    func drawPoint(x: Int, y: Int, color: UInt32) {
        self.pointer.advanced(by: y * Int(self.width) + x).pointee = color
    }

    func fillRect(x0: Int, y0: Int, x1: Int, y1: Int, color: UInt32) {
        for y in y0...y1 {
            for x in x0...x1 {
                self.drawPoint(x: x, y: y, color: color)
            }
        }
    }
}
