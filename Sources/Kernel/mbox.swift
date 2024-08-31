@preconcurrency import var MailboxMessage.mbox

let videocoreMbox = mmioBase + 0xB880
let mboxRead = videocoreMbox
let mboxPoll = videocoreMbox + 0x10
let mboxSender = videocoreMbox + 0x14
let mboxStatus = videocoreMbox + 0x18
let mboxConfig = videocoreMbox + 0x1C
let mboxWrite = videocoreMbox + 0x20
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
}

@inline(__always)
private func transmitMboxFull() -> Bool {
    mmioLoad(mboxStatus) & mboxFull > 0
}

@inline(__always)
private func receiveMboxEmpty() -> Bool {
    mmioLoad(mboxStatus) & mboxEmpty > 0
}

func mboxCall(ch: MboxChannel) -> Bool {
    withUnsafePointer(to: &mbox) { ptr in
        let addr = UInt32(UInt(bitPattern: ptr))
        let r = addr & ~0xF | UInt32(ch.rawValue & 0xF)
        while transmitMboxFull() {}
        mmioStore(r, to: mboxWrite)
        repeat {
            while receiveMboxEmpty() {}
            if mmioLoad(mboxRead) == r {
                return mbox.1 == mboxResponse
            }
        } while true
    }
}
