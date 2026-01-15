private import Font

package enum PixelOrder: UInt32, BitwiseCopyable, Sendable {
    case bgr = 0
    case rgb
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
    @usableFromInline
    let baseAddress: UnsafeMutablePointer<Depth>
    /// The number of pixels of Framebuffer.
    @usableFromInline
    let pixelCount: Int
    /// Framebuffer.
    @inline(always)
    @export(implementation)
    package var buffer: MutableSpan<Depth> {
        mutating get { unsafe .init(_unsafeStart: self.baseAddress, count: self.pixelCount) }
    }

    package init(
        width: UInt32,
        height: UInt32,
        pixelOrder: PixelOrder,
    ) {
        let depth = UInt32(MemoryLayout<Depth>.size &* 8)
        unsafe mbox[0] = 35 * 4
        unsafe mbox[1] = 0  // request

        unsafe mbox[2] = MboxTag.setPhysicalWH
        unsafe mbox[3] = 8
        unsafe mbox[4] = 0  // request
        unsafe mbox[5] = width
        unsafe mbox[6] = height

        unsafe mbox[7] = MboxTag.setVirtualWH
        unsafe mbox[8] = 8
        unsafe mbox[9] = 0  // request
        unsafe mbox[10] = width
        unsafe mbox[11] = height

        unsafe mbox[12] = MboxTag.setVirtualOffset
        unsafe mbox[13] = 8
        unsafe mbox[14] = 0  // request
        unsafe mbox[15] = 0
        unsafe mbox[16] = 0

        unsafe mbox[17] = MboxTag.setDepth
        unsafe mbox[18] = 4
        unsafe mbox[19] = 0  // request
        unsafe mbox[20] = depth

        unsafe mbox[21] = MboxTag.setPixelOrder
        unsafe mbox[22] = 4
        unsafe mbox[23] = 0  // request
        unsafe mbox[24] = pixelOrder.rawValue

        unsafe mbox[25] = MboxTag.allocateBuffer
        unsafe mbox[26] = 8
        unsafe mbox[27] = 0  // request
        unsafe mbox[28] = 4096  // FrameBufferInfo.pointer
        unsafe mbox[29] = 0  //FrameBufferInfo.size

        unsafe mbox[30] = MboxTag.getPitch
        unsafe mbox[31] = 4
        unsafe mbox[32] = 0  // request
        unsafe mbox[33] = 0

        unsafe mbox[34] = MboxTag.end

        // success?
        guard mboxCall(ch: .propertyARM2VC) else { fatalError() }

        let pixelCount = unsafe Int(mbox[10] &* mbox[11])
        let byteCount = unsafe mbox[29]
        let gpuAddr = unsafe mbox[28]

        guard
            unsafe mbox[20] == depth,
            gpuAddr != 0,
            byteCount >= pixelCount &* MemoryLayout<Depth>.size
        else { fatalError() }

        self.width = unsafe mbox[10]
        self.height = unsafe mbox[11]
        // swift-format-ignore: NeverForceUnwrap
        self.pixelOrder = unsafe .init(rawValue: mbox[24])!
        // GPU address to ARM address
        let addr = UInt(gpuAddr & 0x3FFF_FFFF)
        // swift-format-ignore: NeverForceUnwrap
        unsafe self.baseAddress = UnsafeMutableRawPointer(bitPattern: addr)!
            .bindMemory(to: Depth.self, capacity: pixelCount)
        self.pixelCount = pixelCount

        print("Framebufer is ready")
    }

    @inline(always)
    @export(implementation)
    package mutating func drawPoint(x: Int, y: Int, color: Depth) {
        let width = Int(self.width)
        var buf = self.buffer
        buf[y &* width &+ x] = color
    }

    package mutating func fillRect(x0: Int, y0: Int, x1: Int, y1: Int, color: Depth) {
        for y in y0...y1 {
            for x in x0...x1 {
                self.drawPoint(x: x, y: y, color: color)
            }
        }
    }

    package mutating func drawChar(_ c: UInt8, x: Int, y: Int, color: Depth) {
        guard c < font.count else { return }
        let glyph = font[Int(c)]
        for i in 0..<fontHeight {
            for j in 0..<fontWidth where glyph[i] & 1 << j != 0 {
                self.drawPoint(x: x &+ j, y: y &+ i, color: color)
            }
        }
    }

    package mutating func drawString(_ s: StaticString, x: Int, y: Int, color: Depth) {
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
