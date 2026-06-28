package import Hardware

package struct Graphics<Target: RenderTarget & ~Copyable>: ~Copyable {
    var target: Target

    package init(target: consuming Target) {
        self.target = target
    }

    package mutating func drawPoint(x: Int, y: Int, color: Target.Depth) {
        // TODO: check bounds
        unsafe self.target[uncheckedX: x, y: y] = color
    }

    package mutating func fillRect(x0: Int, y0: Int, x1: Int, y1: Int, color: Target.Depth) {
        // TODO: check bounds
        for y in y0...y1 {
            for x in x0...x1 {
                unsafe self.target[uncheckedX: x, y: y] = color
            }
        }
    }

    package mutating func drawChar(_ c: UInt8, x: Int, y: Int, color: Target.Depth) {
        // TODO: check bounds
        guard c < font.count else { return }
        let glyph = font[Int(c)]
        for i in 0..<fontHeight {
            for j in 0..<fontWidth where glyph[i] & 1 << j != 0 {
                unsafe self.target[uncheckedX: x &+ j, y: y &+ i] = color
            }
        }
    }

    package mutating func drawString(_ s: StaticString, x: Int, y: Int, color: Target.Depth) {
        s.withUTF8Buffer { buf in
            var x = x
            var y = y
            for unsafe c in unsafe buf {
                switch c {
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

    package mutating func drawString<T>(_ value: T, x: Int, y: Int, color: Target.Depth)
    where
        T: BinaryInteger & FixedWidthInteger
    {
        withASCIIBytes(from: value) { i, c in
            self.drawChar(c, x: x &+ i * fontWidth, y: y, color: color)
        }
    }
}
