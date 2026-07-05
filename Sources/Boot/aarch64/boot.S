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
    ldr x0, =__stack_top
    mov sp, x0

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
