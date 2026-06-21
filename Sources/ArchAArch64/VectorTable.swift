private import AsmSupport

private typealias VectorEntry = (
    UInt32,  // ldr x16, #8
    UInt32,  // br x16
    @convention(c) () -> Void,  // handler
    [14 of UInt64]  // padding
)

@section(".vectors")
@used
nonisolated(unsafe) private var vectorTable: [16 of VectorEntry] = [
    // Current EL with SP_EL0
    (0x5800_0050, 0xd61f_0200, handleCurrentELSPEL0Sync, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
    (0x5800_0050, 0xd61f_0200, handleCurrentELSPEL0IRQ, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
    (0x5800_0050, 0xd61f_0200, handleCurrentELSPEL0FIQ, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
    (0x5800_0050, 0xd61f_0200, handleCurrentELSPEL0SError, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),

    // Current EL with SP_ELx
    (0x5800_0050, 0xd61f_0200, handleCurrentELSPELxSync, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
    (0x5800_0050, 0xd61f_0200, handleCurrentELSPELxIRQ, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
    (0x5800_0050, 0xd61f_0200, handleCurrentELSPELxFIQ, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
    (0x5800_0050, 0xd61f_0200, handleCurrentELSPELxSError, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),

    // Lower EL using AArch64
    (0x5800_0050, 0xd61f_0200, handleLowerELAArch64Sync, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
    (0x5800_0050, 0xd61f_0200, handleLowerELAArch64IRQ, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
    (0x5800_0050, 0xd61f_0200, handleLowerELAArch64FIQ, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
    (0x5800_0050, 0xd61f_0200, handleLowerELAArch64SError, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),

    // Lower EL using AArch32
    (0x5800_0050, 0xd61f_0200, handleLowerELAArch32Sync, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
    (0x5800_0050, 0xd61f_0200, handleLowerELAArch32IRQ, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
    (0x5800_0050, 0xd61f_0200, handleLowerELAArch32FIQ, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
    (0x5800_0050, 0xd61f_0200, handleLowerELAArch32SError, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
]

@c
private func handleCurrentELSPEL0Sync() {
    print("Exception: handleCurrentELSPEL0Sync")
    repeat { halt() } while true
}

@c
private func handleCurrentELSPEL0IRQ() {
    print("Exception: handleCurrentELSPEL0IRQ")
    repeat { halt() } while true
}

@c
private func handleCurrentELSPEL0FIQ() {
    print("Exception: handleCurrentELSPEL0FIQ")
    repeat { halt() } while true
}

@c
private func handleCurrentELSPEL0SError() {
    print("Exception: handleCurrentELSPEL0SError")
    repeat { halt() } while true
}

@c
private func handleCurrentELSPELxSync() {
    print("Exception: handleCurrentELSPELxSync")
    repeat { halt() } while true
}

@c
private func handleCurrentELSPELxIRQ() {
    print("Exception: handleCurrentELSPELxIRQ")
    repeat { halt() } while true
}

@c
private func handleCurrentELSPELxFIQ() {
    print("Exception: handleCurrentELSPELxFIQ")
    repeat { halt() } while true
}

@c
private func handleCurrentELSPELxSError() {
    print("Exception: handleCurrentELSPELxSError")
    repeat { halt() } while true
}

@c
private func handleLowerELAArch64Sync() {
    print("Exception: handleLowerELAArch64Sync")
    repeat { halt() } while true
}

@c
private func handleLowerELAArch64IRQ() {
    print("Exception: handleLowerELAArch64IRQ")
    repeat { halt() } while true
}

@c
private func handleLowerELAArch64FIQ() {
    print("Exception: handleLowerELAArch64FIQ")
    repeat { halt() } while true
}

@c
private func handleLowerELAArch64SError() {
    print("Exception: handleLowerELAArch64SError")
    repeat { halt() } while true
}

@c
private func handleLowerELAArch32Sync() {
    print("Exception: handleLowerELAArch32Sync")
    repeat { halt() } while true
}

@c
private func handleLowerELAArch32IRQ() {
    print("Exception: handleLowerELAArch32IRQ")
    repeat { halt() } while true
}

@c
private func handleLowerELAArch32FIQ() {
    print("Exception: handleLowerELAArch32FIQ")
    repeat { halt() } while true
}

@c
private func handleLowerELAArch32SError() {
    print("Exception: handleLowerELAArch32SError")
    repeat { halt() } while true
}

/// Registers the AArch64 exception vector table.
package func registerVectorTable() {
    unsafe withUnsafeMutablePointer(to: &vectorTable) { ptr in
        unsafe registerVectorTable(bitPattern: ptr)
    }
}
