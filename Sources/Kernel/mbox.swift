import _Volatile

import var MailboxMessage.mbox

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

@inline(__always)
private func transmitMboxFull() -> Bool {
    mboxStatus.load() & mboxFull > 0
}

@inline(__always)
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
