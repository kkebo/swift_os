ENTRY(_start)
SECTIONS {
    . = 0x80000;  /* aarch64 */
    .text : { KEEP(*(.text.boot)) *(.text*) }
    .data : { *(.rodata* .data*) }
    .bss : ALIGN(16) {  /* ALIGN(16) prevents unaligned stores */
        __bss_start = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(8);
        __bss_end = .;
    }
    /DISCARD/ : {
        *(.comment)
        *(.debug*)
        *(.eh_frame*)
    }
}
__bss_size = (__bss_end - __bss_start) >> 3;
