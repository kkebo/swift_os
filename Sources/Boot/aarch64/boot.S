#ifdef __aarch64__

.section ".text.boot"

.global _start
_start:
    // read cpu id, stop slave cores
    mrs x1, mpidr_el1
    and x1, x1, #3
    cbz w1, primary
    // cpu id > 0, stop

hang:
    wfi
    b hang

primary:
    ldr x0, =__stack_top
    mov sp, x0

    // clear bss
    ldr x1, =__bss_start
    ldr w2, =__bss_size
clear_bss_loop:
    cbz w2, jump_to_main
    str xzr, [x1], #8  // stores a 64-bit doubleword so __bss_end must be 8-byte aligned
    sub w2, w2, #1
    cbnz w2, clear_bss_loop

jump_to_main:
    bl      uart_init

    mov     w0, #65
    bl      uart_putc

1:
    bl      uart_getc          // w0 = received character
    bl      uart_putc          // transmit it back
    b       1b

/* Raspberry Pi 4 MMIO base */
.equ MMIO_BASE,      0xFE000000

/* GPIO */
.equ GPIO_BASE,      MMIO_BASE + 0x00200000
.equ GPFSEL1,        0x04
.equ GPPUD,          0x94
.equ GPPUDCLK0,      0x98

/* UART0 */
.equ UART0_BASE,     MMIO_BASE + 0x00201000
.equ UART0_DR,       0x00
.equ UART0_FR,       0x18
.equ UART0_IBRD,     0x24
.equ UART0_FBRD,     0x28
.equ UART0_LCRH,     0x2C
.equ UART0_CR,       0x30
.equ UART0_IMSC,     0x38
.equ UART0_ICR,      0x44

/* Mailbox */
.equ MBOX_BASE,      MMIO_BASE + 0x0000B880
.equ MBOX_READ,      0x00
.equ MBOX_STATUS,    0x18
.equ MBOX_WRITE,     0x20

/* ------------------------------------------------------------ */

uart_init:
    /* x9 = GPIO base */
    movz    x9, #(GPIO_BASE >> 16), lsl #16
    movk    x9, #(GPIO_BASE & 0xffff)

    /* x10 = UART0 base */
    movz    x10, #(UART0_BASE >> 16), lsl #16
    movk    x10, #(UART0_BASE & 0xffff)

    /* x11 = Mailbox base */
    movz    x11, #(MBOX_BASE >> 16), lsl #16
    movk    x11, #(MBOX_BASE & 0xffff)

    /* Disable UART0 */
    str     wzr, [x10, #UART0_CR]

    /* GPIO14 = ALT0 (TXD0), GPIO15 = ALT0 (RXD0) */

    ldr     w0, [x9, #GPFSEL1]

    /* Clear FSEL14 (bits 12-14) and FSEL15 (bits 15-17) */
    bic     w0, w0, #(7 << 12)
    bic     w0, w0, #(7 << 15)

    /* Set both to ALT0 (100b) */
    orr     w0, w0, #(4 << 12)
    orr     w0, w0, #(4 << 15)

    str     w0, [x9, #GPFSEL1]

    /* Disable GPIO pull-up/down */
    str     wzr, [x9, #GPPUD]

    mov     w0, #150
1:
    subs    w0, w0, #1
    b.ne    1b

    mov     w0, #(1 << 14) | (1 << 15)
    str     w0, [x9, #GPPUDCLK0]

    mov     w0, #150
2:
    subs    w0, w0, #1
    b.ne    2b

    str     wzr, [x9, #GPPUDCLK0]

    /* Clear pending interrupts */
    mov     w0, #0x7FF
    str     w0, [x10, #UART0_ICR]

    /* ------------------------------------------------------------------ */
    /* Set UART clock to 3 MHz via mailbox                                */

    adrp    x0, mbox
    add     x0, x0, :lo12:mbox

    bic     x1, x0, #0xF
    orr     x1, x1, #8

3:  ldr     w2, [x11, #MBOX_STATUS]
    tbnz    w2, #31, 3b

    str     w1, [x11, #MBOX_WRITE]

4:  ldr     w2, [x11, #MBOX_STATUS]
    tbnz    w2, #30, 4b

    ldr     w2, [x11, #MBOX_READ]
    cmp     w2, w1
    b.ne    4b

    /* ------------------------------------------------------------------ */

    mov     w0, #1
    str     w0, [x10, #UART0_IBRD]

    mov     w0, #40
    str     w0, [x10, #UART0_FBRD]

    mov     w0, #(1 << 4) | (1 << 5) | (1 << 6)
    str     w0, [x10, #UART0_LCRH]

    mov     w0, #(1 << 1) | (1 << 4) | (1 << 5) | (1 << 6) | \
                 (1 << 7) | (1 << 8) | (1 << 9) | (1 << 10)
    str     w0, [x10, #UART0_IMSC]

    mov     w0, #(1 << 0) | (1 << 8) | (1 << 9)
    str     w0, [x10, #UART0_CR]

    ret

/* ------------------------------------------------------------ */

uart_putc:
    /* x1 = UART0 base */
    movz    x1, #(UART0_BASE >> 16), lsl #16
    movk    x1, #(UART0_BASE & 0xffff)

1:
    ldr     w2, [x1, #UART0_FR]
    tbnz    w2, #5, 1b        // Wait while TXFF == 1

    str     w0, [x1, #UART0_DR]
    ret

/* ------------------------------------------------------------ */

uart_getc:
    /* x1 = UART0 base */
    movz    x1, #(UART0_BASE >> 16), lsl #16
    movk    x1, #(UART0_BASE & 0xffff)

1:
    ldr     w2, [x1, #UART0_FR]
    tbnz    w2, #4, 1b        // Wait while RXFE == 1

    ldr     w0, [x1, #UART0_DR]
    ret

/* ------------------------------------------------------------ */

    .global putchar
    .type   putchar, %function

putchar:
    bl      uart_putc
    ret

    .size   putchar, . - putchar

    .section .data
    .balign 16
mbox:
    .word 36
    .word 0
    .word 0x38002
    .word 12
    .word 8
    .word 2
    .word 3000000
    .word 0
    .word 0

#endif
