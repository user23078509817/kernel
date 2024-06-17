OUTPUT_FORMAT(binary)
ENTRY(_start)
SECTIONS
{
    . = 0x10000; /* Starting address of the kernel */

    .text : {
        *(.text)
    }

    .data : {
        *(.data)
    }

    .bss : {
        __bss_start = .;
        *(.bss)
        __bss_end = .;
    }
}
