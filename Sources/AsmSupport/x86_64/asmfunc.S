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

.global enable_irq
enable_irq:
    sti
    ret

.global disable_irq
disable_irq:
    cli
    ret

#endif
