package struct MemoryManager {
    /// Total physical memory size in bytes.
    package let total: UInt

    package init() {
        unsafe mbox[0] = 8 * 4
        unsafe mbox[1] = 0  // request

        unsafe mbox[2] = MboxTag.getARMMemory
        unsafe mbox[3] = 8  // TODO: Understand what this is.
        unsafe mbox[4] = 8  // TODO: Understand what this is.
        unsafe mbox[5] = 0
        unsafe mbox[6] = 0

        unsafe mbox[7] = MboxTag.end

        guard mboxCall(ch: .property) else { fatalError() }

        self.total = UInt(unsafe mbox[6])
    }
}
