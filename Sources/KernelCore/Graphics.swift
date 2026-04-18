private import Font
package import Hardware

package struct Graphics<Target: RenderTarget & ~Copyable>: ~Copyable {
    let target: Target

    package init(target: consuming Target) {
        self.target = target
    }

    package func drawPoint(x: Int, y: Int, color: Target.Depth) {
        self.target.drawPoint(x: x, y: y, color: color)
    }

    package func fillRect(x0: Int, y0: Int, x1: Int, y1: Int, color: Target.Depth) {
        for y in y0...y1 {
            for x in x0...x1 {
                self.target.drawPoint(x: x, y: y, color: color)
            }
        }
    }

    package func drawChar(_ c: UInt8, x: Int, y: Int, color: Target.Depth) {
        guard c < font.count else { return }
        let glyph = font[Int(c)]
        for i in 0..<fontHeight {
            for j in 0..<fontWidth where glyph[i] & 1 << j != 0 {
                self.target.drawPoint(x: x &+ j, y: y &+ i, color: color)
            }
        }
    }

    package func drawString(_ s: StaticString, x: Int, y: Int, color: Target.Depth) {
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
