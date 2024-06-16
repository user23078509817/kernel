SECTIONS
{
    #Needed for global variables
    . = 0x10000;
    .text :
    {
        *(.text)
    }
    .data :
    {
        *(.data)
    }
    .bss :
    {
        *(.bss)
    }
}