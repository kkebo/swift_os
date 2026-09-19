private import AsmSupport
public import Hardware

// FIXME: Use the package access level when swiftlang/swift#90225 is fixed
// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
public struct GenericTimer: ~Copyable {
    public var freq: UInt64

    public init() {
        self.freq = UInt64(CNTFRQ_EL0.read().freq)
    }
}

// FIXME: Use the package access level when swiftlang/swift#90225 is fixed
// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
extension GenericTimer: Timer {
    @_transparent
    @export(implementation)
    public var counter: UInt64 { CNTPCT_EL0.read().count }

    public func enable() {
        enableTimer()
    }

    public func disable() {
        disableTimer()
    }
}
