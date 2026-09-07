private import AsmSupport
private import LinkerSupport

private struct BlockEntry {
    private let type: DescriptorType = .block
    var attrs: BlockEntryAttrs
    var outputAddr: UInt

    @inline(always)
    var rawValue: UInt {
        self.outputAddr | UInt(self.type.rawValue) | self.attrs.rawValue
    }
}

private enum DescriptorType: UInt8 {
    case block = 0b01
    case table = 0b11
}

private struct BlockEntryAttrs {
    var index: UInt
    var ns: SecurityBit
    var ap: AccessPermission
    var sh: Shareability
    var af: AccessFlag
    var pxn: Executability
    var uxn: Executability

    @inline(always)
    var rawValue: UInt {
        self.index &<< 2
            | UInt(self.ns.rawValue) &<< 5
            | UInt(self.ap.rawValue) &<< 6
            | UInt(self.sh.rawValue) &<< 8
            | UInt(self.af.rawValue) &<< 10
            | UInt(self.pxn.rawValue) &<< 53
            | UInt(self.uxn.rawValue) &<< 54
    }
}

// This only works at EL3 or Secure EL1.
private enum SecurityBit: UInt8 {
    case secure = 0
    case nonSecure = 1
}

private enum AccessPermission: UInt8 {
    case privilegedRW = 0b00
    case fullRW = 0b01
    case privilegedRO = 0b10
    case fullRO = 0b11
}

private enum Shareability: UInt8 {
    case nonShareable = 0b00
    case outerShareable = 0b10
    case innerShareable = 0b11
}

private enum AccessFlag: UInt8 {
    case notUsed = 0
    case used = 1
}

private enum Executability: UInt8 {
    case executable = 0
    case nonExecutable = 1
}

private let dramIndex: UInt = 0
private let mmioIndex: UInt = 1
private let dramDescAttrs = BlockEntryAttrs(
    index: dramIndex,
    ns: .secure,  // ignored at non-secure EL1
    ap: .privilegedRW,
    sh: .innerShareable,
    af: .used,
    pxn: .executable,
    uxn: .executable,
)
private let mmioDescAttrs = BlockEntryAttrs(
    index: mmioIndex,
    ns: .secure,  // ignored at non-secure EL1
    ap: .privilegedRW,
    sh: .nonShareable,
    af: .used,
    pxn: .nonExecutable,
    uxn: .nonExecutable,
)
private let dramMemAttr = MAIRAttr.normalWBRAWANonTransient
private let mmioMemAttr = MAIRAttr.deviceNGNRNE

package func enableInitialMMU() {
    // We cannot query the physical memory size before enabling the MMU.
    // Use a fixed size for the initial memory mapping.
    let initialDRAMSize: UInt = 1 << 30

    let l2BlockSize: UInt = 1 << 21
    precondition(initialDRAMSize.isMultiple(of: l2BlockSize), "Mapped RAM size must be 2 MiB aligned")

    // Get physical addresses of L2 tables
    let paddr0 = UInt(bitPattern: unsafe l2Table0)
    let paddr1 = UInt(bitPattern: unsafe l2Table1)
    let paddr2 = UInt(bitPattern: unsafe l2Table2)
    let paddr3 = UInt(bitPattern: unsafe l2Table3)

    // Set L1 entries pointing to L2 tables
    unsafe l1Table[0] = paddr0 | 3
    unsafe l1Table[1] = paddr1 | 3
    unsafe l1Table[2] = paddr2 | 3
    unsafe l1Table[3] = paddr3 | 3

    // Populate L2 tables mapping the 4 GiB space block by block
    for i in 0..<2048 {
        let addr = UInt(i) &* l2BlockSize
        let (tableIndex, entryIndex) = i.quotientAndRemainder(dividingBy: 512)

        let table: UnsafeMutablePointer<UInt> =
            switch tableIndex {
            case 0: unsafe l2Table0
            case 1: unsafe l2Table1
            case 2: unsafe l2Table2
            case 3: unsafe l2Table3
            case _: preconditionFailure("unreachable")
            }

        // FIXME: The physical memory map is currently BCM2711-specific.
        unsafe table[entryIndex] =
            switch addr {
            case 0..<initialDRAMSize: BlockEntry(attrs: dramDescAttrs, outputAddr: addr).rawValue
            case 0xfc00_0000...0xffff_ffff: BlockEntry(attrs: mmioDescAttrs, outputAddr: addr).rawValue
            case _: 0 as UInt
            }
    }

    var mair = MAIR_EL1(rawValue: 0)
    mair[Int(dramIndex)] = dramMemAttr
    mair[Int(mmioIndex)] = mmioMemAttr
    let paRange = ID_AA64MMFR0_EL1.read().paRange
    let ips = tcrIPS(from: paRange)

    enableMMU(
        mair: mair.rawValue,
        // TCR_EL1:
        // T0SZ = 25 (39-bit VA)
        // EPD1 = 1 (Disable TTBR1 walks)
        // TG0 = 0 (4 KiB granule)
        // SH0 = 3 (Inner Shareable)
        // ORGN0 = 1 (Outer WB WA cacheable)
        // IRGN0 = 1 (Inner WB WA cacheable)
        // IPS = paRange
        tcr: (1 << 23) | (3 << 12) | (1 << 10) | (1 << 8) | 25 | (ips &<< 32),
        ttbr0: UInt64(UInt(bitPattern: unsafe l1Table)),
    )
}

@_transparent
private func tcrIPS(from paRange: UInt8) -> UInt64 {
    switch paRange {
    case 0b0000: 0b000  // 32-bit
    case 0b0001: 0b001  // 36-bit
    case 0b0010: 0b010  // 40-bit
    case 0b0011: 0b011  // 42-bit
    case 0b0100: 0b100  // 44-bit
    case 0b0101: 0b101  // 48-bit
    case _: preconditionFailure("unsupported PARange")
    }
}
