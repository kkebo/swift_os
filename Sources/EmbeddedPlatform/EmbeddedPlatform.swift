@_extern(c, "__kernel_putchar")
private func putchar(_ c: UInt8)

/// Writes a sequence of UTF-8 code points to standard output.
@c(_swift_writeToStandardOutput)
@export(interface)
@discardableResult
public func writeToStdout(_ ptr: UnsafePointer<UInt8>?, _ count: Int) -> Int {
    guard let ptr = unsafe ptr else { return 0 }
    var i = 0
    while i < count {
        putchar(unsafe ptr[i])
        i += 1
    }
    return count
}

/// Acquires the standard output stream lock.
@c(_swift_lockStandardOutput)
@export(interface)
public func lockStdout() {}

/// Releases one level of ownership of the standard output stream lock.
@c(_swift_unlockStandardOutput)
@export(interface)
public func unlockStdout() {}

private func withASCIIBytes<T>(from value: T, _ consumer: (UInt8) -> Void)
where
    T: UnsignedInteger & FixedWidthInteger
{
    guard value != 0 else {
        consumer(48)
        return
    }

    var magnitude = value
    var divisor: T = 1

    while magnitude / divisor >= 10 {
        divisor *= 10
    }

    while divisor != 0 {
        let (q, r) = magnitude.quotientAndRemainder(dividingBy: divisor)
        consumer(UInt8(q) + 48)
        magnitude = r
        divisor /= 10
    }
}

/// Reports a fatal error at a given file/line.
@c(_swift_reportErrorAt)
@export(interface)
public func reportErrorAt(
    _ message: UnsafePointer<UInt8>?,
    _ messageCount: Int,
    _ fileName: UnsafePointer<UInt8>?,
    _ fileNameCount: Int,
    _ line: Int,
    _ flags: UInt64,
) {
    let prefix: StaticString =
        switch flags & 0xff {
        case 1: "Precondition failed"
        case 2: "Assertion failed"
        case _: "Fatal error"
        }

    if let fileName = unsafe fileName, fileNameCount > 0 {
        unsafe writeToStdout(fileName, fileNameCount)
        putchar(UInt8(ascii: ":"))
        withASCIIBytes(from: UInt(line), putchar)
        putchar(UInt8(ascii: ":"))
        putchar(UInt8(ascii: " "))
    }

    prefix.withUTF8Buffer { _ = unsafe writeToStdout($0.baseAddress, $0.count) }
    if let message = unsafe message, messageCount > 0 {
        putchar(UInt8(ascii: ":"))
        putchar(UInt8(ascii: " "))
        unsafe writeToStdout(message, messageCount)
    }
    putchar(UInt8(ascii: "\n"))
}
