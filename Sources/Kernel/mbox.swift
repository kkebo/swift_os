import Volatile

let videocoreMbox = mmioBase + 0xB880
let mboxRead = UnsafePointer<UInt32>(bitPattern: videocoreMbox)!
let mboxPoll = UnsafePointer<UInt32>(bitPattern: videocoreMbox + 0x10)!
let mboxSender = UnsafePointer<UInt32>(bitPattern: videocoreMbox + 0x14)!
let mboxStatus = UnsafePointer<UInt32>(bitPattern: videocoreMbox + 0x18)!
let mboxConfig = UnsafePointer<UInt32>(bitPattern: videocoreMbox + 0x1C)!
let mboxWrite = UnsafeMutablePointer<UInt32>(bitPattern: videocoreMbox + 0x20)!
let mboxResponse: UInt32 = 0x80000000
let mboxFull: UInt32 = 0x80000000
let mboxEmpty: UInt32 = 0x40000000

@inline(__always)
private func transmitMboxFull() -> Bool {
    volatile_load(mboxStatus) & mboxFull > 0
}

@inline(__always)
private func receiveMboxEmpty() -> Bool {
    volatile_load(mboxStatus) & mboxEmpty > 0
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

#if RASPI4 || RASPI3
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
#endif

func mboxCall(ch: UInt8) -> Bool {
    withUnsafePointer(to: mbox) { ptr in
        let addr = UInt32(UInt(bitPattern: ptr))
        let r = addr & ~0xF | UInt32(ch & 0xF)
        while transmitMboxFull() {}
        volatile_store(mboxWrite, r)
        while true {
            while receiveMboxEmpty() {}
            if volatile_load(mboxRead) == r {
                return ptr.pointee.v2 == mboxResponse
            }
        }
    }
}
