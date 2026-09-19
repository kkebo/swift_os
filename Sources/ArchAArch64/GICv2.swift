private import Hardware
public import _Volatile

// FIXME: Use the package access level when swiftlang/swift#90225 is fixed
// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
public struct GICv2: ~Copyable, Sendable {
    @export(implementation)
    private let distributorBase: UInt
    @export(implementation)
    private let cpuInterfaceBase: UInt

    public init(distributorBase: UInt, cpuInterfaceBase: UInt) {
        self.distributorBase = distributorBase
        self.cpuInterfaceBase = cpuInterfaceBase

        let gicdCTLR = self.gicdCTLR
        let giccCTLR = self.giccCTLR

        gicdCTLR.store(0)
        giccCTLR.store(0)

        // TODO: Initialize GIC properly.

        for i in UInt(0)..<1020 {
            self.setPriority(for: i)
        }

        // Accept all interrupt priorities.
        self.giccPMR.store(0xff)

        gicdCTLR.store(1)
        giccCTLR.store(1)
    }

    @_transparent
    private var gicdCTLR: VolatileMappedRegister<UInt32> {
        unsafe VolatileMappedRegister(unsafeBitPattern: self.distributorBase)
    }

    @_transparent
    private var giccCTLR: VolatileMappedRegister<UInt32> {
        unsafe VolatileMappedRegister(unsafeBitPattern: self.cpuInterfaceBase)
    }

    @_transparent
    private var giccPMR: VolatileMappedRegister<UInt32> {
        unsafe VolatileMappedRegister(unsafeBitPattern: self.cpuInterfaceBase + 0x004)
    }

    @_transparent
    private func gicdIPRIORITYR(_ intID: UInt) -> VolatileMappedRegister<UInt32> {
        let offset = intID / 4 * UInt(MemoryLayout<UInt32>.stride)
        return unsafe VolatileMappedRegister(unsafeBitPattern: self.distributorBase + 0x400 + offset)
    }

    @_transparent
    @export(implementation)
    private func gicdISENABLER(_ intID: UInt) -> VolatileMappedRegister<UInt32> {
        let offset = intID / 32 * UInt(MemoryLayout<UInt32>.stride)
        return unsafe VolatileMappedRegister(unsafeBitPattern: self.distributorBase + 0x100 + offset)
    }

    @_transparent
    @export(implementation)
    private var giccIAR: VolatileMappedRegister<UInt32> {
        unsafe VolatileMappedRegister(unsafeBitPattern: self.cpuInterfaceBase + 0x00c)
    }

    @_transparent
    @export(implementation)
    private var giccEOIR: VolatileMappedRegister<UInt32> {
        unsafe VolatileMappedRegister(unsafeBitPattern: self.cpuInterfaceBase + 0x010)
    }

    public func setPriority(_ priority: UInt8 = 0x80, for intID: UInt) {
        let reg = self.gicdIPRIORITYR(intID)
        let i = intID % 4
        let shiftWidth = i * 8

        var val = reg.load()
        val = val & ~(0xff << shiftWidth) | UInt32(priority) << shiftWidth
        reg.store(val)
    }

    @_transparent
    @export(implementation)
    public func enable(_ intID: UInt) {
        self.gicdISENABLER(intID).store(1 << (intID % 32))
    }

    @_transparent
    @export(implementation)
    public func readIAR() -> UInt32 { self.giccIAR.load() }

    @_transparent
    @export(implementation)
    public func writeEOIR(_ value: UInt32) { self.giccEOIR.store(value) }
}
