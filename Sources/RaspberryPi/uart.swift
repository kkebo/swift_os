import AsmSupport
import _Volatile

#if RASPI4
    let mmioBase: UInt = 0xFE00_0000
#elseif RASPI3 || RASPI2
    let mmioBase: UInt = 0x3F00_0000
#else
    let mmioBase: UInt = 0x2000_0000
#endif

let gpioBase = mmioBase + 0x200000
let gpfsel1 = unsafe VolatileMappedRegister<UInt32>(unsafeBitPattern: gpioBase + 0x4)
let gppud = unsafe VolatileMappedRegister<UInt32>(unsafeBitPattern: gpioBase + 0x94)
let gppudclk0 = unsafe VolatileMappedRegister<UInt32>(unsafeBitPattern: gpioBase + 0x98)

let uartBase = gpioBase + 0x1000
let uartDR = unsafe VolatileMappedRegister<UInt32>(unsafeBitPattern: uartBase)
let uartFR = unsafe VolatileMappedRegister<UInt32>(unsafeBitPattern: uartBase + 0x18)
let uartIBRD = unsafe VolatileMappedRegister<UInt32>(unsafeBitPattern: uartBase + 0x24)
let uartFBRD = unsafe VolatileMappedRegister<UInt32>(unsafeBitPattern: uartBase + 0x28)
let uartLCRH = unsafe VolatileMappedRegister<UInt32>(unsafeBitPattern: uartBase + 0x2C)
let uartCR = unsafe VolatileMappedRegister<UInt32>(unsafeBitPattern: uartBase + 0x30)
let uartIMSC = unsafe VolatileMappedRegister<UInt32>(unsafeBitPattern: uartBase + 0x38)
let uartICR = unsafe VolatileMappedRegister<UInt32>(unsafeBitPattern: uartBase + 0x44)

@inline(always)
private func transmitFIFOFull() -> Bool {
    uartFR.load() & 1 << 5 > 0
}

@inline(always)
private func receiveFIFOEmpty() -> Bool {
    uartFR.load() & 1 << 4 > 0
}

@usableFromInline
package func putchar(_ c: UInt8) {
    while transmitFIFOFull() {}
    uartDR.store(UInt32(c))
}

@usableFromInline
package func getchar() -> UInt8 {
    while receiveFIFOEmpty() {}
    return UInt8(uartDR.load())
}

#if RASPI4 || RASPI3
    // set up clock to 3 MHz
    @_optimize(none)
    private func setClockRateMbox() {
        unsafe mbox[0] = 9 * 4
        unsafe mbox[1] = 0  // request
        unsafe mbox[2] = MboxTag.setClockRate
        unsafe mbox[3] = 12  // TODO: Understand what this is.
        unsafe mbox[4] = 8  // TODO: Understand what this is.
        unsafe mbox[5] = 2  // UART clock
        unsafe mbox[6] = 3_000_000  // 3 Mhz
        unsafe mbox[7] = 0  // clear turbo
        unsafe mbox[8] = MboxTag.end
    }
#endif

package func initUART() {
    // disable UART0
    uartCR.store(0)

    #if RASPI4 || RASPI3
        setClockRateMbox()
        guard mboxCall(ch: .property) else { fatalError() }
    #endif

    // map UART0 to GPIO pins
    var selector = gpfsel1.load()
    selector &= ~(7 << 12 | 7 << 15)  // GPIO14, GPIO15
    selector |= 4 << 12 | 4 << 15  // ALT0
    gpfsel1.store(selector)

    // disable pull up/down for pins 14 and 15
    gppud.store(0)
    delay(150)
    gppudclk0.store(1 << 14 | 1 << 15)
    delay(150)
    gppudclk0.store(0)  // flush GPIO setup

    uartICR.store(0x7FF)  // clear pending interrupts
    uartIBRD.store(1)  // 3000000 / (16 * 115200) = 1.627 = ~1
    uartFBRD.store(40)  // (0.627 * 64) + 0.5 = 40.6 = ~40
    uartLCRH.store(0b1110000)  // enable FIFO & 8 bit data transmission (1 stop bit, no parity)
    uartIMSC.store(0b111_11110010)  // mask all interrupts
    uartCR.store(0b11_00000001)  // enable Tx, Rx, UART0
}
