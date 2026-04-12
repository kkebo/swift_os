private import LinkerSupport

func zeroBSS() {
    let start = ImageLayout.bssStart
    let end = ImageLayout.bssEnd
    let size = end - start

    precondition(start % 8 == 0)
    precondition(size % 8 == 0)

    // swift-format-ignore: NeverForceUnwrap
    let ptr = unsafe UnsafeMutableRawPointer(bitPattern: start)!

    unsafe ptr.initializeMemory(as: UInt64.self, repeating: 0, count: Int(size >> 3))
}
