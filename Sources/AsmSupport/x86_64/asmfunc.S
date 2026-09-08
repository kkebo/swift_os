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

.global enable_cpu_irq
enable_cpu_irq:
    sti
    ret

.global disable_cpu_irq
disable_cpu_irq:
    cli
    ret

#endif
