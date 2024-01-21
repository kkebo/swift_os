import Volatile

#if RASPI4
    let mmioBase: UInt = 0xFE000000
#elseif RASPI3 || RASPI2
    let mmioBase: UInt = 0x3F000000
#else
    let mmioBase: UInt = 0x20000000
#endif

let gpioBase = mmioBase + 0x200000
let gpfsel1 = UnsafeMutablePointer<UInt32>(bitPattern: gpioBase + 0x4)!
let gppud = UnsafeMutablePointer<UInt32>(bitPattern: gpioBase + 0x94)!
let gppudclk0 = UnsafeMutablePointer<UInt32>(bitPattern: gpioBase + 0x98)!

let uartBase = gpioBase + 0x1000
let uartDR = UnsafeMutablePointer<UInt32>(bitPattern: uartBase)!
let uartFR = UnsafePointer<UInt32>(bitPattern: uartBase + 0x18)!
let uartIBRD = UnsafeMutablePointer<UInt32>(bitPattern: uartBase + 0x24)!
let uartFBRD = UnsafeMutablePointer<UInt32>(bitPattern: uartBase + 0x28)!
let uartLCRH = UnsafeMutablePointer<UInt32>(bitPattern: uartBase + 0x2C)!
let uartCR = UnsafeMutablePointer<UInt32>(bitPattern: uartBase + 0x30)!
let uartIMSC = UnsafeMutablePointer<UInt32>(bitPattern: uartBase + 0x38)!
let uartICR = UnsafeMutablePointer<UInt32>(bitPattern: uartBase + 0x44)!

let videocoreMbox = mmioBase + 0xB880
let mboxRead = UnsafePointer<UInt32>(bitPattern: videocoreMbox)!
let mboxStatus = UnsafePointer<UInt32>(bitPattern: videocoreMbox + 0x18)!
let mboxWrite = UnsafeMutablePointer<UInt32>(bitPattern: videocoreMbox + 0x20)!

private func transmitFIFOFull() -> Bool {
    volatile_load(uartFR) & 1 << 5 > 0
}

private func receiveFIFOEmpty() -> Bool {
    volatile_load(uartFR) & 1 << 4 > 0
}

@usableFromInline
func putchar(_ c: UInt8) {
    while transmitFIFOFull() {}
    volatile_store(uartDR, UInt32(c))
}

func getchar() -> UInt8 {
    while receiveFIFOEmpty() {}
    return UInt8(volatile_load(uartDR))
}

private func transmitMboxFull() -> Bool {
    volatile_load(mboxStatus) & 0x80000000 > 0
}

private func receiveMboxEmpty() -> Bool {
    volatile_load(mboxStatus) & 0x40000000 > 0
}

@_alignment(16)
struct Mbox {
    var v1: UInt32
    var v2: UInt32
    var v3: UInt32
    var v4: UInt32
    var v5: UInt32
    var v6: UInt32
    var v7: UInt32
    var v8: UInt32
    var v9: UInt32

    init(_ v1: UInt32, _ v2: UInt32, _ v3: UInt32, _ v4: UInt32, _ v5: UInt32, _ v6: UInt32, _ v7: UInt32, _ v8: UInt32, _ v9: UInt32) {
        self.v1 = v1
        self.v2 = v2
        self.v3 = v3
        self.v4 = v4
        self.v5 = v5
        self.v6 = v6
        self.v7 = v7
        self.v8 = v8
        self.v9 = v9
    }
}
let mbox = Mbox(
    9 * 4,
    0,  // request
    0x38002,  // set clock rate
    12,
    8,
    2,  // UART clock
    3000000,  // 3 Mhz
    0,  // clear turbo
    0  // mbox tag last
)

func initUART() {
    // disable UART0
    volatile_store(uartCR, 0)

    // set up clock to 3 MHz
    withUnsafePointer(to: mbox) { ptr in
        let addr = UInt32(UInt(bitPattern: ptr))
        let r = addr & ~0xF | 8
        while transmitMboxFull() {}
        volatile_store(mboxWrite, r)
        while receiveMboxEmpty() || volatile_load(mboxRead) != r {}
        // if ptr.pointee.v2 != 0x80000000 { while true {} }
    }

    // map UART0 to GPIO pins
    var selector = volatile_load(gpfsel1)
    selector &= ~(7 << 12 | 7 << 15)  // GPIO14, GPIO15
    selector |= 4 << 12 | 4 << 15  // ALT0
    volatile_store(gpfsel1, selector)

    // disable pull up/down for pins 14 and 15
    volatile_store(gppud, 0)
    delay(150)
    volatile_store(gppudclk0, 1 << 14 | 1 << 15)
    delay(150)
    volatile_store(gppudclk0, 0)  // flush GPIO setup

    volatile_store(uartICR, 0x7FF)  // clear pending interrupts
    volatile_store(uartIBRD, 1)  // 3000000 / (16 * 115200) = 1.627 = ~1
    volatile_store(uartFBRD, 40)  // (0.627 * 64) + 0.5 = 40.6 = ~40
    volatile_store(uartLCRH, 0b1110000)  // enable FIFO & 8 bit data transmission (1 stop bit, no parity)
    volatile_store(uartIMSC, 0b11111110010)  // mask all interrupts
    volatile_store(uartCR, 0b1100000001)  // enable Tx, Rx, UART0
}
