#ifdef __aarch64__

.section ".text.boot"

.global _start
_start:
    // read cpu id, stop slave cores
    mrs x1, mpidr_el1
    and x1, x1, #3
    cbz w1, 2f
    // cpu id > 0, stop
1:  wfe
    b 1b
2:  // cpu id == 0

    // set top of stack just before our code
    ldr x1, =_start
    mov sp, x1

    // clear bss
    ldr x1, =__bss_start
    ldr w2, =__bss_size
3:  cbz w2, 4f
    str xzr, [x1], #8  // stores a 64-bit doubleword so __bss_end must be 8-byte aligned
    sub w2, w2, #1
    cbnz w2, 3b

    // jump to Swift code, should not return
4:  bl Kernel_main
    // for failsafe, halt this core too
    b 1b

#endif
