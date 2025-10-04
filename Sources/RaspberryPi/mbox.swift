import _Volatile

let videocoreMbox = mmioBase + 0xB880
let mboxRead = unsafe VolatileMappedRegister<UInt32>(unsafeBitPattern: videocoreMbox)
let mboxPoll = unsafe VolatileMappedRegister<UInt32>(unsafeBitPattern: videocoreMbox + 0x10)
let mboxSender = unsafe VolatileMappedRegister<UInt32>(unsafeBitPattern: videocoreMbox + 0x14)
let mboxStatus = unsafe VolatileMappedRegister<UInt32>(unsafeBitPattern: videocoreMbox + 0x18)
let mboxConfig = unsafe VolatileMappedRegister<UInt32>(unsafeBitPattern: videocoreMbox + 0x1C)
let mboxWrite = unsafe VolatileMappedRegister<UInt32>(unsafeBitPattern: videocoreMbox + 0x20)
let mboxResponse: UInt32 = 0x8000_0000
let mboxFull: UInt32 = 0x8000_0000
let mboxEmpty: UInt32 = 0x4000_0000

@_alignment(16)
struct Mbox {
    var `0`: UInt32 = 0
    var `1`: UInt32 = 0
    var `2`: UInt32 = 0
    var `3`: UInt32 = 0
    var `4`: UInt32 = 0
    var `5`: UInt32 = 0
    var `6`: UInt32 = 0
    var `7`: UInt32 = 0
    var `8`: UInt32 = 0
    var `9`: UInt32 = 0
    var `10`: UInt32 = 0
    var `11`: UInt32 = 0
    var `12`: UInt32 = 0
    var `13`: UInt32 = 0
    var `14`: UInt32 = 0
    var `15`: UInt32 = 0
    var `16`: UInt32 = 0
    var `17`: UInt32 = 0
    var `18`: UInt32 = 0
    var `19`: UInt32 = 0
    var `20`: UInt32 = 0
    var `21`: UInt32 = 0
    var `22`: UInt32 = 0
    var `23`: UInt32 = 0
    var `24`: UInt32 = 0
    var `25`: UInt32 = 0
    var `26`: UInt32 = 0
    var `27`: UInt32 = 0
    var `28`: UInt32 = 0
    var `29`: UInt32 = 0
    var `30`: UInt32 = 0
    var `31`: UInt32 = 0
    var `32`: UInt32 = 0
    var `33`: UInt32 = 0
    var `34`: UInt32 = 0
    var `35`: UInt32 = 0
}

nonisolated(unsafe) var mbox: Mbox = .init()

enum MboxChannel: UInt8 {
    case power = 0
    case framebuffer
    case virtualUART
    case vchiq
    case leds
    case buttons
    case touchScreen
    case count  // TODO: Understand what this is.
    case property  // ARM -> VC
    // case property  // VC -> ARM
}

enum MboxTag {
    static let end: UInt32 = 0
    static let setClockRate: UInt32 = 0x0003_8002
    static let allocateBuffer: UInt32 = 0x0004_0001
    static let setPhysicalWH: UInt32 = 0x0004_8003
    static let setVirtualWH: UInt32 = 0x0004_8004
    static let setDepth: UInt32 = 0x0004_8005
    static let setPixelOrder: UInt32 = 0x0004_8006
    static let getPitch: UInt32 = 0x0004_0008
    static let setVirtualOffset: UInt32 = 0x0004_8009
}

@inline(always)
private func transmitMboxFull() -> Bool {
    mboxStatus.load() & mboxFull > 0
}

@inline(always)
private func receiveMboxEmpty() -> Bool {
    mboxStatus.load() & mboxEmpty > 0
}

func mboxCall(ch: MboxChannel) -> Bool {
    unsafe withUnsafePointer(to: &mbox) { ptr in
        let addr = UInt32(UInt(bitPattern: ptr))
        let r = addr & ~0xF | UInt32(ch.rawValue & 0xF)
        while transmitMboxFull() {}
        mboxWrite.store(r)
        repeat {
            while receiveMboxEmpty() {}
            if mboxRead.load() == r {
                return unsafe mbox.1 == mboxResponse
            }
        } while true
    }
}
