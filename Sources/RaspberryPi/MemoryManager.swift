private import AsmSupport
private import LinkerSupport

package struct MemoryManager: ~Copyable {
    /// The base address in bytes.
    package let baseAddress: UInt
    /// Total physical memory size in bytes.
    package let total: UInt

    package init() {
        unsafe mbox[0] = 8 * 4
        unsafe mbox[1] = 0  // request

        unsafe mbox[2] = MboxTag.getARMMemory
        unsafe mbox[3] = 8
        unsafe mbox[4] = 0  // request
        unsafe mbox[5] = 0
        unsafe mbox[6] = 0

        unsafe mbox[7] = MboxTag.end

        guard unsafe mbox.call(ch: .propertyARM2VC) else { fatalError() }

        let base = UInt(unsafe mbox[5])
        let size = UInt(unsafe mbox[6])

        precondition(ImageLayout.kernelStart >= base)
        precondition(ImageLayout.kernelEnd < base + size)

        self.baseAddress = base
        self.total = size
    }
}
