private import AsmSupport

struct ID_AA64MMFR0_EL1: BitwiseCopyable {
    private var rawValue: UInt64

    @_transparent
    var paRange: UInt8 { UInt8(truncatingIfNeeded: self.rawValue & 0xf) }
    @_transparent
    var asidBits: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 4 & 0xf) }
    @_transparent
    var bigEnd: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 8 & 0xf) }
    @_transparent
    var snsMem: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 12 & 0xf) }
    @_transparent
    var bigEndEL0: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 16 & 0xf) }
    @_transparent
    var tGran16: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 20 & 0xf) }
    @_transparent
    var tGran64: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 24 & 0xf) }
    @_transparent
    var tGran4: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 28 & 0xf) }
    @_transparent
    var tGran16Stg2: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 32 & 0xf) }
    @_transparent
    var tGran64Stg2: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 36 & 0xf) }
    @_transparent
    var tGran4Stg2: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 40 & 0xf) }
    @_transparent
    var exS: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 44 & 0xf) }
    @_transparent
    var fgt: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 56 & 0xf) }
    @_transparent
    var ecv: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 60 & 0xf) }

    @_transparent
    init(rawValue: UInt64) {
        self.rawValue = rawValue
    }

    @_transparent
    static func read() -> Self { Self(rawValue: getID_AA64MMFR0_EL1()) }
}

struct MAIR_EL1: BitwiseCopyable {
    private(set) var rawValue: UInt64

    subscript(i: Int) -> MAIRAttr? {
        @_transparent
        get {
            precondition(0..<8 ~= i, "index out of range")
            return .init(rawValue: UInt8(truncatingIfNeeded: self.rawValue >> (i * 8) & 0xff))
        }
        @_transparent
        set {
            precondition(0..<8 ~= i, "index out of range")
            let shiftWidth = i * 8
            guard let newValue else {
                self.rawValue = self.rawValue & ~(0xff << shiftWidth)
                return
            }
            self.rawValue = self.rawValue & ~(0xff << shiftWidth) | UInt64(newValue.rawValue) << shiftWidth
        }
    }

    @_transparent
    init(rawValue: UInt64) {
        self.rawValue = rawValue
    }

    @_transparent
    static func read() -> Self { Self(rawValue: getMAIR_EL1()) }

    @_transparent
    func write() { setMAIR_EL1(self.rawValue) }
}

enum MAIRAttr: UInt8 {
    case deviceNGNRNE = 0b00000000
    case deviceNGNRE = 0b00000100
    case deviceNGRE = 0b00001000
    case deviceGRE = 0b00001100
    case normalNonCacheable = 0b01000100
    case normalWBRAWANonTransient = 0b11111111
}
