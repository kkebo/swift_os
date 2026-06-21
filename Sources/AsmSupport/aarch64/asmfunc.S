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

#endif
