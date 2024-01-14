ENTRY(_start)
SECTIONS {
    . = 0x80000;
    .startup . : { boot.o(.text) }
    .text : { *(.text .text.*) }
    .data : { *(.rodata .rodata.* .data .data.*) }
    __bss_start = .;
    .bss : { *(.bss .bss.* COMMON) }
    __bss_end = .;
    /DISCARD/ : { *(.comment) *(.debug*) *(.eh_frame*) }
}
__bss_size = __bss_end - __bss_start;
