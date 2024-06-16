.code16

.equ CODE_SEG, gdt_code - gdt
.equ DATA_SEG, gdt_data - gdt

_start:
    jmp load_gdt

gdt:
gdt_null:
    .long 0
    .long 0

gdt_code:
    .word 0xFFFF         # Limit (16 bits)
    .word 0              # Base (16 bits)
    .byte 0              # Base (8 bits, continued)
    .byte 0x9A           # Access byte: present, ring 0, code segment, executable, conforming
    .byte 0xCF           # Granularity byte: 4KB granularity, 32-bit segment
    .byte 0              # Base (8 bits, continued)

gdt_data:
    .word 0xFFFF         # Limit (16 bits)
    .word 0              # Base (16 bits)
    .byte 0              # Base (8 bits, continued)
    .byte 0x92           # Access byte: present, ring 0, data segment, writable
    .byte 0xCF           # Granularity byte: 4KB granularity, 32-bit segment
    .byte 0              # Base (8 bits, continued)

gdt_end:

gdt_desc:
    .word gdt_end - gdt - 1  # Limit
    .long gdt                # Base

load_gdt:
    cli
    lgdt gdt_desc

    # Enter protected mode
    mov %cr0, %eax
    or $1, %eax
    mov %eax, %cr0
    ljmp $CODE_SEG, $clear_pipe

.code32
clear_pipe:

    # Set up the stack pointer
    mov $0xFFF0, %esp

    mov $DATA_SEG, %ax
    mov %ax, %ds        # Set DS to 0
    mov %ax, %es        # Set ES to 0
    mov %ax, %ss        # Set SS to 0

    # Infinite loop to halt the CPU
    #jmp 0x10000
