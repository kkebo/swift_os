private import AsmSupport

@freestanding(declaration, names: named(VectorEntry), named(vectorTable))
private macro vectorTable(
    _: @escaping @convention(c) () -> Void,
    _: @escaping @convention(c) () -> Void,
    _: @escaping @convention(c) () -> Void,
    _: @escaping @convention(c) () -> Void,
    _: @escaping @convention(c) () -> Void,
    _: @escaping @convention(c) () -> Void,
    _: @escaping @convention(c) () -> Void,
    _: @escaping @convention(c) () -> Void,
    _: @escaping @convention(c) () -> Void,
    _: @escaping @convention(c) () -> Void,
    _: @escaping @convention(c) () -> Void,
    _: @escaping @convention(c) () -> Void,
    _: @escaping @convention(c) () -> Void,
    _: @escaping @convention(c) () -> Void,
    _: @escaping @convention(c) () -> Void,
    _: @escaping @convention(c) () -> Void,
) = #externalMacro(module: "KernelMacros", type: "VectorTableMacro")

#vectorTable(
    // Current EL with SP_EL0
    handleCurrentELSPEL0Sync,
    handleCurrentELSPEL0IRQ,
    handleCurrentELSPEL0FIQ,
    handleCurrentELSPEL0SError,

    // Current EL with SP_ELx
    handleCurrentELSPELxSync,
    handleCurrentELSPELxIRQ,
    handleCurrentELSPELxFIQ,
    handleCurrentELSPELxSError,

    // Lower EL using AArch64
    handleLowerELAArch64Sync,
    handleLowerELAArch64IRQ,
    handleLowerELAArch64FIQ,
    handleLowerELAArch64SError,

    // Lower EL using AArch32
    handleLowerELAArch32Sync,
    handleLowerELAArch32IRQ,
    handleLowerELAArch32FIQ,
    handleLowerELAArch32SError,
)

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
