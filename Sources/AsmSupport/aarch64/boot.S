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

    cmp x0, #3
    b.eq from_el3

    cmp x0, #2
    b.eq from_el2

    b hang

from_el2:
    mov x0, #(1 << 31)  // aarch64
    msr hcr_el2, x0

    msr cntvoff_el2, xzr

    mov x0, #5  // EL1h
    orr x0, x0, #(0xF << 6)  // mask DAIF
    msr spsr_el2, x0  // set return level to EL1

    adr x0, el1_entry
    msr elr_el2, x0

    isb
    eret

from_el3:
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

    isb
    eret

el1_entry:
    // set top of stack just before our code
    ldr x1, =_start
    mov sp, x1

    // clear bss
    ldr x1, =__bss_start
    ldr w2, =__bss_size
clear_bss_loop:
    cbz w2, jump_to_main
    str xzr, [x1], #8  // stores a 64-bit doubleword so __bss_end must be 8-byte aligned
    sub w2, w2, #1
    cbnz w2, clear_bss_loop

jump_to_main:
    // jump to Swift code, should not return
    bl Kernel_main
    // for failsafe, halt this core too
    b hang

#endif
