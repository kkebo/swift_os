import Volatile

#if RASPI4
    let uartBase: UInt = 0xFE201000
#elseif RASPI3 || RASPI2
    let uartBase: UInt = 0x3F201000
#else
    let uartBase: UInt = 0x20201000
#endif

let uartDR = UnsafeMutablePointer<UInt32>(bitPattern: uartBase)!
let uartFR = UnsafePointer<UInt32>(bitPattern: uartBase + 0x18)!

private func transmitFIFOFull() -> Bool {
    volatile_load(uartFR) & (1 << 5) > 0
}

private func receiveFIFOEmpty() -> Bool {
    volatile_load(uartFR) & (1 << 4) > 0
}

@_silgen_name("putchar")
@discardableResult
public func putchar(_ c: CInt) -> CInt {
    while transmitFIFOFull() {}
    volatile_store(uartDR, UInt32(c))
    return c
}

func getchar() -> UInt8 {
    while receiveFIFOEmpty() {}
    return UInt8(volatile_load(uartDR))
}
