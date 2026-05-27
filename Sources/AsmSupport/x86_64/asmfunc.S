#ifdef __x86_64__

.global delay
delay:
    dec rdi
    jne delay
    ret

.global halt
halt:
    hlt
    ret

#endif
