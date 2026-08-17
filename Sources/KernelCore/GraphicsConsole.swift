package import Hardware

private let maxCols = 128
private let maxRows = 64

package struct GraphicsConsole<Depth: VolatileMappable>: ~Copyable {
    package let cols: Int
    package let rows: Int
    package var fgColor: Depth
    package var bgColor: Depth

    private var chars: [8192 of UInt8]  // maxCols * maxRows
    private var x: Int
    private var y: Int
    private var isDirty: Bool

    package init<Target>(target: borrowing Target, fgColor: Depth, bgColor: Depth)
    where
        Target: RenderTarget & ~Copyable,
        Target.Depth == Depth
    {
        self.init(
            cols: Int(target.width) / fontWidth,
            rows: Int(target.height) / fontHeight,
            fgColor: fgColor,
            bgColor: bgColor,
        )
    }

    package init(cols: Int, rows: Int, fgColor: Depth, bgColor: Depth) {
        precondition(cols > 0 && rows > 0)
        self.cols = min(cols, maxCols)
        self.rows = min(rows, maxRows)
        self.fgColor = fgColor
        self.bgColor = bgColor
        self.chars = .init(repeating: 0x20)
        self.x = 0
        self.y = 0
        self.isDirty = true
    }

    private mutating func newLine() {
        self.x = 0
        if self.y < self.rows - 1 {
            self.y += 1
        } else {
            for row in 0..<self.rows - 1 {
                for col in 0..<self.cols {
                    self.chars[row * maxCols + col] = self.chars[(row + 1) * maxCols + col]
                }
            }
            let lastRow = self.rows - 1
            for col in 0..<self.cols {
                self.chars[lastRow * maxCols + col] = 0x20
            }
            self.y = lastRow
        }
    }

    package mutating func render<Target>(on gfx: inout Graphics<Target>)
    where
        Target: RenderTarget & ~Copyable,
        Target.Depth == Depth
    {
        guard self.isDirty else { return }

        for row in 0..<self.rows {
            for col in 0..<self.cols {
                let c = self.chars[row * maxCols + col]
                let x = col * fontWidth
                let y = row * fontHeight

                gfx.fillRect(
                    x0: x,
                    y0: y,
                    x1: x + fontWidth - 1,
                    y1: y + fontHeight - 1,
                    color: self.bgColor,
                )

                if c != 0x20 {
                    gfx.drawChar(c, x: x, y: y, color: self.fgColor)
                }
            }
        }

        self.isDirty = false
    }
}

extension GraphicsConsole: Console {
    package mutating func write(_ c: UInt8) {
        switch c {
        case 0x0a: self.newLine()
        case 0x0d: self.x = 0
        case _ where self.x < self.cols && self.y < self.rows:
            self.chars[self.y * maxCols + self.x] = c
            self.x += 1
            if self.x >= self.cols {
                self.newLine()
            }
        case _: break
        }
        self.isDirty = true
    }
}
