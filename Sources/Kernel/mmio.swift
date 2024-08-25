import _Volatile

@inlinable
func mmioLoad(_ address: UInt) -> UInt32 {
    VolatileMappedRegister(unsafeBitPattern: address).load()
}

@inlinable
func mmioStore(_ value: UInt32, to address: UInt) {
    VolatileMappedRegister(unsafeBitPattern: address).store(value)
}
