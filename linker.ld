ENTRY(_start)
SECTIONS {
    . = 0x80000;  /* aarch64 */
    __kernel_start = .;
    .text : {
        KEEP(*(.text.boot))
        *(.text*)
        . = ALIGN(2048);
        KEEP(*(.vectors))
    }
    .data : { *(.rodata* .got* .data*) }
    .bss (NOLOAD) : ALIGN(16) {  /* ALIGN(16) prevents unaligned stores */
        __bss_start = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(16);
        KEEP(*(.mbox))

        . = ALIGN(4096);
        __l1_table = .;
        . += 4096;
        __l2_table_0 = .;
        . += 4096;
        __l2_table_1 = .;
        . += 4096;
        __l2_table_2 = .;
        . += 4096;
        __l2_table_3 = .;
        . += 4096;

        . = ALIGN(8);
        __bss_end = .;
    }
    __kernel_end = ALIGN(16);
    .stack (NOLOAD) : ALIGN(16) {
        __stack_bottom = .;
        . += 0x20000;  /* 128 KiB */
        __stack_top = .;
    }
    __kernel_image_end = .;
    .nonalloc : {
        *(.symtab)
        *(.strtab)
        *(.shstrtab)
    }
    /DISCARD/ : {
        *(.comment)
        *(.debug*)
        *(.eh_frame*)
        *(.swift_modhash*)
        *(.swift_ast)
    }
}
