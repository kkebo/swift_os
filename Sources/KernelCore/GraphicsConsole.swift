public import Hardware

@export(implementation)
private let maxCols = 128
@export(implementation)
private let maxRows = 64

// FIXME: Use the package access level when swiftlang/swift#90225 is fixed
// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
public struct GraphicsConsole<Target: RenderTarget & ~Copyable>: ~Copyable, ~Escapable {
    public let cols: Int
    public let rows: Int
    public var fgColor: Target.Depth
    public var bgColor: Target.Depth

    @export(implementation)
    private var gfx: MutableRef<Graphics<Target>>
    @export(implementation)
    private var buf: [8192 of UInt8]  // maxCols * maxRows
    @export(implementation)
    private var head: Int
    @export(implementation)
    private var x: Int
    @export(implementation)
    private var y: Int

    @inline(always)
    @export(implementation)
    @_lifetime(&gfx)
    public init(gfx: inout Graphics<Target>, fgColor: Target.Depth, bgColor: Target.Depth) {
        self.init(
            gfx: &gfx,
            cols: Int(gfx.width) / fontWidth,
            rows: Int(gfx.height) / fontHeight,
            fgColor: fgColor,
            bgColor: bgColor,
        )
    }

    @inline(always)
    @export(implementation)
    @_lifetime(&gfx)
    public init(gfx: inout Graphics<Target>, cols: Int, rows: Int, fgColor: Target.Depth, bgColor: Target.Depth) {
        precondition(cols > 0 && rows > 0)
        self.gfx = .init(&gfx)
        self.cols = min(cols, maxCols)
        self.rows = min(rows, maxRows)
        self.fgColor = fgColor
        self.bgColor = bgColor
        self.buf = .init(repeating: 0x20)
        self.head = 0
        self.x = 0
        self.y = 0
    }

    private func index(row: Int, col: Int) -> Int {
        let trueRow = (self.head &+ row) % self.rows
        return trueRow &* maxCols &+ col
    }

    private mutating func newLine() {
        self.x = 0
        let lastRow = self.rows &- 1
        if self.y < lastRow {
            self.y &+= 1
        } else {
            var maxCol = 0
            for row in 0..<self.rows {
                for col in maxCol..<self.cols where self.buf[self.index(row: row, col: col)] != 0x20 {
                    maxCol = max(col, maxCol)
                }
            }
            maxCol &+= 1

            self.head = (self.head &+ 1) % self.rows

            for col in 0..<self.cols {
                self.buf[self.index(row: lastRow, col: col)] = 0x20
            }

            self.gfx.value.copyRect(
                x0: 0,
                y0: fontHeight,
                x1: maxCol &* fontWidth,
                y1: self.rows &* fontHeight,
                toX: 0,
                toY: 0,
            )
            self.gfx.value.fillRect(
                x0: 0,
                y0: lastRow &* fontHeight,
                x1: maxCol &* fontWidth,
                y1: self.rows &* fontHeight,
                color: self.bgColor,
            )
        }
    }
}

extension GraphicsConsole: Console where Target: ~Copyable {
    package mutating func write(_ c: UInt8) {
        switch c {
        case 0x0a: self.newLine()
        case 0x0d: self.x = 0
        case _ where self.x < self.cols:
            if c != 0x20 {
                self.gfx.value.drawChar(c, x: self.x &* fontWidth, y: self.y &* fontHeight, color: self.fgColor)
            }
            self.buf[self.index(row: self.y, col: self.x)] = c
            self.x &+= 1
            if self.x >= self.cols {
                self.newLine()
            }
        case _: break
        }
    }
}
