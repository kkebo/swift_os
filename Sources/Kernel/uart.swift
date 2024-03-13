#if RASPI4
    let mmioBase: UInt = 0xFE000000
#elseif RASPI3 || RASPI2
    let mmioBase: UInt = 0x3F000000
#else
    let mmioBase: UInt = 0x20000000
#endif

let gpioBase = mmioBase + 0x200000
let gpfsel1 = gpioBase + 0x4
let gppud = gpioBase + 0x94
let gppudclk0 = gpioBase + 0x98

let uartBase = gpioBase + 0x1000
let uartDR = uartBase
let uartFR = uartBase + 0x18
let uartIBRD = uartBase + 0x24
let uartFBRD = uartBase + 0x28
let uartLCRH = uartBase + 0x2C
let uartCR = uartBase + 0x30
let uartIMSC = uartBase + 0x38
let uartICR = uartBase + 0x44

@inline(__always)
private func transmitFIFOFull() -> Bool {
    mmioLoad(uartFR) & 1 << 5 > 0
}

@inline(__always)
private func receiveFIFOEmpty() -> Bool {
    mmioLoad(uartFR) & 1 << 4 > 0
}

@usableFromInline
func putchar(_ c: UInt8) {
    while transmitFIFOFull() {}
    mmioStore(UInt32(c), to: uartDR)
}

@usableFromInline
func getchar() -> UInt8 {
    while receiveFIFOEmpty() {}
    return UInt8(mmioLoad(uartDR))
}

func initUART() {
    // disable UART0
    mmioStore(0, to: uartCR)

    #if RASPI4 || RASPI3
        // set up clock to 3 MHz
        guard mboxCall(ch: 8) else { while true {} }
    #endif

    // map UART0 to GPIO pins
    var selector = mmioLoad(gpfsel1)
    selector &= ~(7 << 12 | 7 << 15)  // GPIO14, GPIO15
    selector |= 4 << 12 | 4 << 15  // ALT0
    mmioStore(selector, to: gpfsel1)

    // disable pull up/down for pins 14 and 15
    mmioStore(0, to: gppud)
    delay(150)
    mmioStore(1 << 14 | 1 << 15, to: gppudclk0)
    delay(150)
    mmioStore(0, to: gppudclk0)  // flush GPIO setup

    mmioStore(0x7FF, to: uartICR)  // clear pending interrupts
    mmioStore(1, to: uartIBRD)  // 3000000 / (16 * 115200) = 1.627 = ~1
    mmioStore(40, to: uartFBRD)  // (0.627 * 64) + 0.5 = 40.6 = ~40
    mmioStore(0b1110000, to: uartLCRH)  // enable FIFO & 8 bit data transmission (1 stop bit, no parity)
    mmioStore(0b11111110010, to: uartIMSC)  // mask all interrupts
    mmioStore(0b1100000001, to: uartCR)  // enable Tx, Rx, UART0
}
