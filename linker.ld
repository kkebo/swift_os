ENTRY(_start)
SECTIONS {
    . = 0x80000;  /* aarch64 */
    __kernel_start = .;
    .text : { KEEP(*(.text.boot)) *(.text*) }
    .data : { *(.rodata* .data*) }
    .bss (NOLOAD) : ALIGN(16) {  /* ALIGN(16) prevents unaligned stores */
        __bss_start = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(8);
        __bss_end = .;
    }
    __kernel_end = .;
    .nonalloc (NOLOAD) : {
        *(.symtab)
        *(.strtab)
        *(.shstrtab)
    }
    /DISCARD/ : {
        *(.comment)
        *(.debug*)
        *(.eh_frame*)
        *(.swift_modhash*)
    }
}
