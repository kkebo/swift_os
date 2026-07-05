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

#endif
