package import Hardware

package struct Graphics<Target: RenderTarget & ~Copyable>: ~Copyable {
    var target: Target

    @_transparent
    package var width: Int { Int(self.target.width) }
    @_transparent
    package var height: Int { Int(self.target.height) }

    package init(target: consuming Target) {
        self.target = target
    }

    package mutating func drawPoint(x: Int, y: Int, color: Target.Depth) {
        // TODO: check bounds
        unsafe self.target[uncheckedX: x, y: y] = color
    }

    @_transparent
    package mutating func fill(color: Target.Depth) {
        self.fillRect(x0: 0, y0: 0, x1: self.width - 1, y1: self.height - 1, color: color)
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

    package mutating func copyRect(
        x0: Int,
        y0: Int,
        x1: Int,
        y1: Int,
        toX dstX0: Int,
        toY dstY0: Int,
    ) {
        guard x0 < x1 && y0 < y1 else { return }

        let width = x1 &- x0
        let height = y1 &- y0

        let xRange =
            if x0 < dstX0 {
                stride(from: width &- 1, through: 0, by: -1)
            } else {
                stride(from: 0, through: width &- 1, by: 1)
            }
        let yRange =
            if y0 < dstY0 {
                stride(from: height &- 1, through: 0, by: -1)
            } else {
                stride(from: 0, through: height &- 1, by: 1)
            }

        let validX = 0..<self.width
        let validY = 0..<self.height
        for dy in yRange {
            let srcY = y0 &+ dy
            let dstY = dstY0 &+ dy
            guard validY.contains(srcY) && validY.contains(dstY) else { continue }
            for dx in xRange {
                let srcX = x0 &+ dx
                let dstX = dstX0 &+ dx
                guard validX.contains(srcX) && validX.contains(dstX) else { continue }
                unsafe self.target[uncheckedX: dstX, y: dstY] = self.target[uncheckedX: srcX, y: srcY]
            }
        }
    }

    package func synchronize() {
        self.target.synchronize()
    }
}
