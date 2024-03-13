import Volatile

@inline(__always)
func mmioLoad(_ address: UInt) -> UInt32 {
    volatile_load(UnsafePointer(bitPattern: address))
}

@inline(__always)
func mmioStore(_ value: UInt32, to address: UInt) {
    volatile_store(UnsafeMutablePointer(bitPattern: address), value)
}
