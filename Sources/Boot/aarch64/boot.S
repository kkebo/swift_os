#ifdef __aarch64__

.section ".text.boot"

.global _start
_start:
    // read cpu id, stop slave cores
    mrs x1, mpidr_el1
    and x1, x1, #3
    cbz w1, primary
    // cpu id > 0, stop

hang:
    wfi
    b hang

primary:
    mrs x0, CurrentEL
    lsr x0, x0, #2
    cmp x0, #2
    b.eq el2_entry
    b.lt el1_entry

el3_entry:
    mov x0, #(1 << 31)  // aarch64
    msr hcr_el2, x0

    mov x0, #(1 << 11)  // set ST bit (disable trapping of timer control registers)
    orr x0, x0, #(1 << 10)  // set RW bit (next lower EL in aarch64)
    msr scr_el3, x0

    mov x0, #5  // EL1 with SP_EL1 (EL1h)
    orr x0, x0, #(0xF << 6)  // mask DAIF
    msr spsr_el3, x0  // set return level to EL1

    adr x0, el1_entry
    msr elr_el3, x0

    mov x0, xzr
    msr cptr_el3, x0  // disable SIMD/FP traps

    isb
    eret

el2_entry:
    mov x0, #(1 << 31)  // aarch64
    msr hcr_el2, x0

    msr cntvoff_el2, xzr

    mov x0, #5  // EL1 with SP_EL1 (EL1h)
    orr x0, x0, #(0xF << 6)  // mask DAIF
    msr spsr_el2, x0  // set return level to EL1

    adr x0, el1_entry
    msr elr_el2, x0

    mov x0, xzr
    msr cptr_el2, x0  // disable SIMD/FP traps

    isb
    eret

el1_entry:
    mrs x0, sctlr_el1
    bic x0, x0, #(1 << 0)   // M = 0 (MMU disabled)
    bic x0, x0, #(1 << 1)   // A = 0 (Alignment check disabled)
    bic x0, x0, #(1 << 2)   // C = 0 (Data cache disabled)
    bic x0, x0, #(1 << 12)  // I = 0 (Instruction cache disabled)
    msr sctlr_el1, x0

    mrs x0, cpacr_el1
    orr x0, x0, #(3 << 20)
    msr cpacr_el1, x0  // enable SIMD/FP access

    isb

    ldr x0, =__stack_top
    mov sp, x0

jump_to_main:
    // jump to Swift code, should not return
    bl Kernel_main
    // for failsafe, halt this core too
    b hang

#endif
