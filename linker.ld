ENTRY(_start)
SECTIONS {
    . = 0x80000;
    .startup . : { boot.o(.text) }
    .text : { *(.text .text.*) }
    .data : { *(.rodata .rodata.* .data .data.*) }
    .bss : {
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
