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

.global enable_mmu
enable_mmu:
    msr mair_el1, x0
    msr tcr_el1, x1
    msr ttbr0_el1, x2
    isb

    dsb ishst  // ensure write has completed
    tlbi vmalle1  // invalidate all TLB entries for current OS (single core)
    dsb ish  // ensure completion of TLB invalidation
    isb

    mrs x3, sctlr_el1
    orr x3, x3, #1          // M = 1 (MMU enabled)
    orr x3, x3, #(1 << 2)   // C = 1 (Data cache enabled)
    orr x3, x3, #(1 << 12)  // I = 1 (Instruction cache enabled)
    msr sctlr_el1, x3
    isb
    ret

.global set_timer_period
set_timer_period:
    msr CNTP_TVAL_EL0, x0
    ret

.global enable_timer
enable_timer:
    mov x0, #0b11  // IMASK = 1, ENABLE = 1
    msr CNTP_CTL_EL0, x0
    ret

.global disable_timer
disable_timer:
    msr CNTP_CTL_EL0, xzr
    ret

.macro DEFINE_SYSREG name
.global get_\name
get_\name:
    mrs x0, \name
    ret

.global set_\name
set_\name:
    msr \name, x0
    ret
.endm

.macro DEFINE_RO_SYSREG name
.global get_\name
get_\name:
    mrs x0, \name
    ret
.endm

DEFINE_RO_SYSREG cntfrq_el0
DEFINE_RO_SYSREG cntpct_el0
DEFINE_RO_SYSREG cntp_ctl_el0
DEFINE_RO_SYSREG currentel
DEFINE_RO_SYSREG id_aa64mmfr0_el1
DEFINE_SYSREG mair_el1

#endif
