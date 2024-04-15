.global delay
delay:
    subs x0, x0, #1
    bne delay
    ret
