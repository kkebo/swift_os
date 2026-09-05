public import AsmSupport

// FIXME: Use the package access level when swiftlang/swift#90225 is fixed
// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
public struct CNTFRQ_EL0: BitwiseCopyable, Equatable, Hashable, Sendable {
    public var freq: UInt32

    @_transparent
    @export(implementation)
    public init(rawValue: UInt64) {
        self.freq = UInt32(truncatingIfNeeded: rawValue)
    }

    @_transparent
    @export(implementation)
    public static func read() -> Self { Self(rawValue: getCNTFRQ_EL0()) }
}

// FIXME: Use the package access level when swiftlang/swift#90225 is fixed
// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
public struct CNTPCT_EL0: BitwiseCopyable, Equatable, Hashable, Sendable {
    public var count: UInt64

    @_transparent
    @export(implementation)
    public init(rawValue: UInt64) {
        self.count = rawValue
    }

    @_transparent
    @export(implementation)
    public static func read() -> Self { Self(rawValue: getCNTPCT_EL0()) }
}

// FIXME: Use the package access level when swiftlang/swift#90225 is fixed
// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
public struct CNTP_CTL_EL0: BitwiseCopyable, Equatable, Hashable, Sendable {
    @export(implementation)
    private var rawValue: UInt64

    @_transparent
    @export(implementation)
    public var enable: Bool { self.rawValue & 1 != 0 }
    @_transparent
    @export(implementation)
    public var mask: Bool { self.rawValue &>> 1 & 1 != 0 }
    @_transparent
    @export(implementation)
    public var status: Bool { self.rawValue &>> 2 & 1 != 0 }

    @_transparent
    @export(implementation)
    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }

    @_transparent
    @export(implementation)
    public static func read() -> Self { Self(rawValue: getCNTP_CTL_EL0()) }
}

// FIXME: Use the package access level when swiftlang/swift#90225 is fixed
// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
public struct CurrentEL: BitwiseCopyable, Equatable, Hashable, Sendable {
    public var el: UInt8

    @_transparent
    @export(implementation)
    public init(rawValue: UInt64) {
        self.el = UInt8(truncatingIfNeeded: rawValue &>> 2 & 0b11)
    }

    @_transparent
    @export(implementation)
    public static func read() -> Self { Self(rawValue: getCurrentEL()) }
}

// FIXME: Use the package access level when swiftlang/swift#90225 is fixed
// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
public struct ID_AA64MMFR0_EL1: BitwiseCopyable, Equatable, Hashable, Sendable {
    @export(implementation)
    private var rawValue: UInt64

    @_transparent
    @export(implementation)
    public var paRange: UInt8 { UInt8(truncatingIfNeeded: self.rawValue & 0xf) }
    @_transparent
    @export(implementation)
    public var asidBits: UInt8 { UInt8(truncatingIfNeeded: self.rawValue &>> 4 & 0xf) }
    @_transparent
    @export(implementation)
    public var bigEnd: UInt8 { UInt8(truncatingIfNeeded: self.rawValue &>> 8 & 0xf) }
    @_transparent
    @export(implementation)
    public var snsMem: UInt8 { UInt8(truncatingIfNeeded: self.rawValue &>> 12 & 0xf) }
    @_transparent
    @export(implementation)
    public var bigEndEL0: UInt8 { UInt8(truncatingIfNeeded: self.rawValue &>> 16 & 0xf) }
    @_transparent
    @export(implementation)
    public var tGran16: UInt8 { UInt8(truncatingIfNeeded: self.rawValue &>> 20 & 0xf) }
    @_transparent
    @export(implementation)
    public var tGran64: UInt8 { UInt8(truncatingIfNeeded: self.rawValue &>> 24 & 0xf) }
    @_transparent
    @export(implementation)
    public var tGran4: UInt8 { UInt8(truncatingIfNeeded: self.rawValue &>> 28 & 0xf) }
    @_transparent
    @export(implementation)
    public var tGran16Stg2: UInt8 { UInt8(truncatingIfNeeded: self.rawValue &>> 32 & 0xf) }
    @_transparent
    @export(implementation)
    public var tGran64Stg2: UInt8 { UInt8(truncatingIfNeeded: self.rawValue &>> 36 & 0xf) }
    @_transparent
    @export(implementation)
    public var tGran4Stg2: UInt8 { UInt8(truncatingIfNeeded: self.rawValue &>> 40 & 0xf) }
    @_transparent
    @export(implementation)
    public var exS: UInt8 { UInt8(truncatingIfNeeded: self.rawValue &>> 44 & 0xf) }
    @_transparent
    @export(implementation)
    public var fgt: UInt8 { UInt8(truncatingIfNeeded: self.rawValue &>> 56 & 0xf) }
    @_transparent
    @export(implementation)
    public var ecv: UInt8 { UInt8(truncatingIfNeeded: self.rawValue &>> 60 & 0xf) }

    @_transparent
    @export(implementation)
    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }

    @_transparent
    @export(implementation)
    public static func read() -> Self { Self(rawValue: getID_AA64MMFR0_EL1()) }
}
