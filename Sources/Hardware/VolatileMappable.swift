import _Volatile

// FIXME: Use the package access level when swiftlang/swift#90225 is fixed
// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
public protocol VolatileMappable: FixedWidthInteger, UnsignedInteger, BitwiseCopyable {
    @unsafe
    static func volatileLoad(from address: UInt) -> Self
    @unsafe
    static func volatileStore(_ value: Self, to address: UInt)
}

// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
extension UInt8: VolatileMappable {
    @unsafe
    public static func volatileLoad(from address: UInt) -> Self {
        unsafe VolatileMappedRegister(unsafeBitPattern: address).load()
    }

    @unsafe
    public static func volatileStore(_ value: Self, to address: UInt) {
        unsafe VolatileMappedRegister(unsafeBitPattern: address).store(value)
    }
}

// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
extension UInt16: VolatileMappable {
    @unsafe
    public static func volatileLoad(from address: UInt) -> Self {
        unsafe VolatileMappedRegister(unsafeBitPattern: address).load()
    }

    @unsafe
    public static func volatileStore(_ value: Self, to address: UInt) {
        unsafe VolatileMappedRegister(unsafeBitPattern: address).store(value)
    }
}

// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
extension UInt32: VolatileMappable {
    @unsafe
    public static func volatileLoad(from address: UInt) -> Self {
        unsafe VolatileMappedRegister(unsafeBitPattern: address).load()
    }

    @unsafe
    public static func volatileStore(_ value: Self, to address: UInt) {
        unsafe VolatileMappedRegister(unsafeBitPattern: address).store(value)
    }
}

// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
extension UInt64: VolatileMappable {
    @unsafe
    public static func volatileLoad(from address: UInt) -> Self {
        unsafe VolatileMappedRegister(unsafeBitPattern: address).load()
    }

    @unsafe
    public static func volatileStore(_ value: Self, to address: UInt) {
        unsafe VolatileMappedRegister(unsafeBitPattern: address).store(value)
    }
}
