#ifdef __aarch64__

.global delay
delay:
    subs x0, x0, #1
    bne delay
    ret

.global halt
halt:
    wfi
    ret

.global enable_irq
enable_irq:
    msr daifclr, #2
    ret

.global disable_irq
disable_irq:
    msr daifset, #2
    ret

.macro DCACHE_RANGE op
    cbz x1, 2f
    add x1, x0, x1
    mrs x2, ctr_el0
    lsr x2, x2, #16
    and x2, x2, #0xf
    mov x3, #4
    lsl x3, x3, x2
    sub x4, x3, #1
    bic x0, x0, x4
1:
    dc \op, x0
    add x0, x0, x3
    cmp x0, x1
    b.lo 1b
    dsb ish
2:
    ret
.endm

.global clean_dcache_range
clean_dcache_range:
    DCACHE_RANGE cvac

.global invalidate_dcache_range
invalidate_dcache_range:
    DCACHE_RANGE ivac

.global get_el
get_el:
    mrs x0, CurrentEL
    lsr x0, x0, #2
    ret

.global register_vector_table
register_vector_table:
    adrp x0, vector_table
    add  x0, x0, :lo12:vector_table
    msr vbar_el1, x0
    isb
    ret

.global brk0
brk0:
    brk #0
    ret

.global get_mmfr0
get_mmfr0:
    mrs x0, id_aa64mmfr0_el1
    ret

.global enable_mmu
enable_mmu:
    msr mair_el1, x0
    msr tcr_el1, x1
    msr ttbr0_el1, x2
    isb

    // Invalidate TLB (single core)
    dsb sy
    tlbi vmalle1
    dsb sy
    isb

    mrs x3, sctlr_el1
    orr x3, x3, #1          // M = 1 (MMU enabled)
    orr x3, x3, #(1 << 2)   // C = 1 (Data cache enabled)
    orr x3, x3, #(1 << 12)  // I = 1 (Instruction cache enabled)
    msr sctlr_el1, x3
    isb
    ret

#endif
