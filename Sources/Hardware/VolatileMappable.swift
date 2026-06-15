import _Volatile

package protocol VolatileMappable: FixedWidthInteger, UnsignedInteger, BitwiseCopyable {
    @unsafe
    static func volatileLoad(from address: UInt) -> Self
    @unsafe
    static func volatileStore(_ value: Self, to address: UInt)
}

extension UInt8: VolatileMappable {
    @unsafe
    package static func volatileLoad(from address: UInt) -> Self {
        unsafe VolatileMappedRegister(unsafeBitPattern: address).load()
    }

    @unsafe
    package static func volatileStore(_ value: Self, to address: UInt) {
        unsafe VolatileMappedRegister(unsafeBitPattern: address).store(value)
    }
}

extension UInt16: VolatileMappable {
    @unsafe
    package static func volatileLoad(from address: UInt) -> Self {
        unsafe VolatileMappedRegister(unsafeBitPattern: address).load()
    }

    @unsafe
    package static func volatileStore(_ value: Self, to address: UInt) {
        unsafe VolatileMappedRegister(unsafeBitPattern: address).store(value)
    }
}

extension UInt32: VolatileMappable {
    @unsafe
    package static func volatileLoad(from address: UInt) -> Self {
        unsafe VolatileMappedRegister(unsafeBitPattern: address).load()
    }

    @unsafe
    package static func volatileStore(_ value: Self, to address: UInt) {
        unsafe VolatileMappedRegister(unsafeBitPattern: address).store(value)
    }
}

extension UInt64: VolatileMappable {
    @unsafe
    package static func volatileLoad(from address: UInt) -> Self {
        unsafe VolatileMappedRegister(unsafeBitPattern: address).load()
    }

    @unsafe
    package static func volatileStore(_ value: Self, to address: UInt) {
        unsafe VolatileMappedRegister(unsafeBitPattern: address).store(value)
    }
}
