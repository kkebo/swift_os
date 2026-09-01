import AsmSupport

package struct CNTFRQ_EL0: BitwiseCopyable, Equatable, Hashable, Sendable {
    package var freq: UInt32

    package init(rawValue: UInt64) {
        self.freq = UInt32(truncatingIfNeeded: rawValue)
    }

    package static func read() -> Self { Self(rawValue: getCNTFRQ_EL0()) }
}

package struct CNTPCT_EL0: BitwiseCopyable, Equatable, Hashable, Sendable {
    package var count: UInt64

    package init(rawValue: UInt64) {
        self.count = rawValue
    }

    package static func read() -> Self { Self(rawValue: getCNTPCT_EL0()) }
}

package struct CNTP_CTL_EL0: BitwiseCopyable, Equatable, Hashable, Sendable {
    private var rawValue: UInt64

    package var enable: Bool { self.rawValue & 1 != 0 }
    package var mask: Bool { self.rawValue >> 1 & 1 != 0 }
    package var status: Bool { self.rawValue >> 2 & 1 != 0 }

    package init(rawValue: UInt64) {
        self.rawValue = rawValue
    }

    package static func read() -> Self { Self(rawValue: getCNTP_CTL_EL0()) }
}

package struct CurrentEL: BitwiseCopyable, Equatable, Hashable, Sendable {
    package var el: UInt8

    package init(rawValue: UInt64) {
        self.el = UInt8(truncatingIfNeeded: rawValue >> 2 & 0b11)
    }

    package static func read() -> Self { Self(rawValue: getCurrentEL()) }
}

package struct ID_AA64MMFR0_EL1: BitwiseCopyable, Equatable, Hashable, Sendable {
    private var rawValue: UInt64

    package var paRange: UInt8 { UInt8(truncatingIfNeeded: self.rawValue & 0xf) }
    package var asidBits: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 4 & 0xf) }
    package var bigEnd: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 8 & 0xf) }
    package var snsMem: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 12 & 0xf) }
    package var bigEndEL0: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 16 & 0xf) }
    package var tGran16: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 20 & 0xf) }
    package var tGran64: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 24 & 0xf) }
    package var tGran4: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 28 & 0xf) }
    package var tGran16Stg2: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 32 & 0xf) }
    package var tGran64Stg2: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 36 & 0xf) }
    package var tGran4Stg2: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 40 & 0xf) }
    package var exS: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 44 & 0xf) }
    package var fgt: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 56 & 0xf) }
    package var ecv: UInt8 { UInt8(truncatingIfNeeded: self.rawValue >> 60 & 0xf) }

    package init(rawValue: UInt64) {
        self.rawValue = rawValue
    }

    package static func read() -> Self { Self(rawValue: getID_AA64MMFR0_EL1()) }
}
