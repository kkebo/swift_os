import Volatile

@inlinable
func mmioLoad(_ address: UInt) -> UInt32 {
    volatile_load(UnsafePointer(bitPattern: address))
}

@inlinable
func mmioStore(_ value: UInt32, to address: UInt) {
    volatile_store(UnsafeMutablePointer(bitPattern: address), value)
}
