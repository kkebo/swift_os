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

.global get_kernel_start
get_kernel_start:
    adrp x0, __kernel_start
    add x0, x0, :lo12:__kernel_start
    ret

.global get_kernel_end
get_kernel_end:
    adrp x0, __kernel_end
    add x0, x0, :lo12:__kernel_end
    ret

.global get_bss_start
get_bss_start:
    adrp x0, __bss_start
    add x0, x0, :lo12:__bss_start
    ret

.global get_bss_end
get_bss_end:
    adrp x0, __bss_end
    add x0, x0, :lo12:__bss_end
    ret

#endif
