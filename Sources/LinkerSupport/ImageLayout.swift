@_extern(c, "__kernel_start")
private nonisolated(unsafe) var kernelStartHead: UInt8
@_extern(c, "__kernel_end")
private nonisolated(unsafe) var kernelEndHead: UInt8
@_extern(c, "__bss_start")
private nonisolated(unsafe) var bssStartHead: UInt8
@_extern(c, "__bss_end")
private nonisolated(unsafe) var bssEndHead: UInt8
@_extern(c, "__stack_start")
private nonisolated(unsafe) var stackStartHead: UInt8
@_extern(c, "__stack_end")
private nonisolated(unsafe) var stackEndHead: UInt8
@_extern(c, "__kernel_image_end")
private nonisolated(unsafe) var kernelImageEndHead: UInt8

package enum ImageLayout {
    @inline(always)
    @export(implementation)
    package static var kernelStart: UInt {
        unsafe withUnsafePointer(to: &kernelStartHead, UInt.init(bitPattern:))
    }
    @inline(always)
    @export(implementation)
    package static var kernelEnd: UInt {
        unsafe withUnsafePointer(to: &kernelEndHead, UInt.init(bitPattern:))
    }
    @inline(always)
    @export(implementation)
    package static var bssStart: UInt {
        unsafe withUnsafePointer(to: &bssStartHead, UInt.init(bitPattern:))
    }
    @inline(always)
    @export(implementation)
    package static var bssEnd: UInt {
        unsafe withUnsafePointer(to: &bssEndHead, UInt.init(bitPattern:))
    }
    @inline(always)
    @export(implementation)
    package static var stackStart: UInt {
        unsafe withUnsafePointer(to: &stackStartHead, UInt.init(bitPattern:))
    }
    @inline(always)
    @export(implementation)
    package static var stackEnd: UInt {
        unsafe withUnsafePointer(to: &stackEndHead, UInt.init(bitPattern:))
    }
    @inline(always)
    @export(implementation)
    package static var kernelImageEnd: UInt {
        unsafe withUnsafePointer(to: &kernelImageEndHead, UInt.init(bitPattern:))
    }
}
