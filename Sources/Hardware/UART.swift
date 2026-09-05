// FIXME: Use the package access level when swiftlang/swift#90225 is fixed
// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
public protocol UART: ~Copyable, ~Escapable {
    func putchar(_ c: UInt8)
    func getchar() -> UInt8
}
