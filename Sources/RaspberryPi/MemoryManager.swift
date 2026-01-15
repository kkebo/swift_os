package struct MemoryManager: ~Copyable, ~Escapable {
    /// Total physical memory size in bytes.
    package let total: UInt

    @_lifetime(immortal)
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

        self.total = UInt(unsafe mbox[6])
    }
}
