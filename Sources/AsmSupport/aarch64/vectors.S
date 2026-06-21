#ifdef __aarch64__

.macro save_context
    sub sp, sp, #272

    stp x0, x1, [sp, #0]
    stp x2, x3, [sp, #16]
    stp x4, x5, [sp, #32]
    stp x6, x7, [sp, #48]
    stp x8, x9, [sp, #64]
    stp x10, x11, [sp, #80]
    stp x12, x13, [sp, #96]
    stp x14, x15, [sp, #112]
    stp x16, x17, [sp, #128]
    stp x18, x19, [sp, #144]
    stp x20, x21, [sp, #160]
    stp x22, x23, [sp, #176]
    stp x24, x25, [sp, #192]
    stp x26, x27, [sp, #208]
    stp x28, x29, [sp, #224]
    str x30, [sp, #240]

    mrs x0, spsr_el1
    str x0, [sp, #248]
.endm

.macro restore_context
    ldr x0, [sp, #248]
    msr spsr_el1, x0

    ldr x30, [sp, #240]
    ldp x28, x29, [sp, #224]
    ldp x26, x27, [sp, #208]
    ldp x24, x25, [sp, #192]
    ldp x22, x23, [sp, #176]
    ldp x20, x21, [sp, #160]
    ldp x18, x19, [sp, #144]
    ldp x16, x17, [sp, #128]
    ldp x14, x15, [sp, #112]
    ldp x12, x13, [sp, #96]
    ldp x10, x11, [sp, #80]
    ldp x8, x9, [sp, #64]
    ldp x6, x7, [sp, #48]
    ldp x4, x5, [sp, #32]
    ldp x2, x3, [sp, #16]
    ldp x0, x1, [sp, #0]

    add sp, sp, #272
.endm

curr_el_sp0_sync:
    save_context
    bl handleCurrentELSP0Sync
    restore_context
    eret

curr_el_sp0_irq:
    save_context
    bl handleCurrentELSP0IRQ
    restore_context
    eret

curr_el_sp0_fiq:
    save_context
    bl handleCurrentELSP0FIQ
    restore_context
    eret

curr_el_sp0_serr:
    save_context
    bl handleCurrentELSP0SError
    restore_context
    eret

curr_el_spx_sync:
    save_context
    mrs x0, esr_el1
    mrs x1, elr_el1
    sub sp, sp, #16
    str x1, [sp]
    mov x1, sp
    bl handleCurrentELSPxSync
    ldr x1, [sp]
    add sp, sp, #16
    msr elr_el1, x1
    restore_context
    eret

curr_el_spx_irq:
    save_context
    bl handleCurrentELSPxIRQ
    restore_context
    eret

curr_el_spx_fiq:
    save_context
    bl handleCurrentELSPxFIQ
    restore_context
    eret

curr_el_spx_serr:
    save_context
    bl handleCurrentELSPxSError
    restore_context
    eret

lower_el_aarch64_sync:
    save_context
    bl handleLowerELAArch64Sync
    restore_context
    eret

lower_el_aarch64_irq:
    save_context
    bl handleLowerELAArch64IRQ
    restore_context
    eret

lower_el_aarch64_fiq:
    save_context
    bl handleLowerELAArch64FIQ
    restore_context
    eret

lower_el_aarch64_serr:
    save_context
    bl handleLowerELAArch64SError
    restore_context
    eret

lower_el_aarch32_sync:
    save_context
    bl handleLowerELAArch32Sync
    restore_context
    eret

lower_el_aarch32_irq:
    save_context
    bl handleLowerELAArch32IRQ
    restore_context
    eret

lower_el_aarch32_fiq:
    save_context
    bl handleLowerELAArch32FIQ
    restore_context
    eret

lower_el_aarch32_serr:
    save_context
    bl handleLowerELAArch32SError
    restore_context
    eret

.section ".vectors", "ax", @progbits
.global vector_table
.balign 2048
vector_table:
    // Current EL while using SP_EL0
    b curr_el_sp0_sync
    .balign 128
    b curr_el_sp0_irq
    .balign 128
    b curr_el_sp0_fiq
    .balign 128
    b curr_el_sp0_serr
    .balign 128

    // Current EL while using SP_ELx
    b curr_el_spx_sync
    .balign 128
    b curr_el_spx_irq
    .balign 128
    b curr_el_spx_fiq
    .balign 128
    b curr_el_spx_serr
    .balign 128

    // Lower EL using AArch64
    b lower_el_aarch64_sync
    .balign 128
    b lower_el_aarch64_irq
    .balign 128
    b lower_el_aarch64_fiq
    .balign 128
    b lower_el_aarch64_serr
    .balign 128

    // Lower EL using AArch32
    b lower_el_aarch32_sync
    .balign 128
    b lower_el_aarch32_irq
    .balign 128
    b lower_el_aarch32_fiq
    .balign 128
    b lower_el_aarch32_serr

#endif
