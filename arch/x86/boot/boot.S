.global _start

.code16

STACK_SIZE = 1024   # Define stack size (adjust as needed)

.section .text
_start:
    cli                # Disable interrupts

    # Print a message
    mov $msg, %si
    call print_string

    movw $0x7e00, %bx    # Destination offset within segment (ES:BX)
    movb $0x02, %ah      # BIOS read sector function
    movb $0x02, %al      # Number of sectors to read (1 sector)
    movb $0x00, %ch      # Cylinder number
    movb $0x00, %dh      # Head number
    movb $0x02, %cl      # Sector number
    int $0x13            # BIOS interrupt

    jc disk_error        # Jump to disk_error on carry flag set

    xor %ax, %ax
    mov %ax, %es

    xor %ax, %ax

    jmp 0x7e00          # Jump to the loaded code (adjust as needed)


disk_error:
    # Print error message and halt
    mov $err_msg, %si
    call print_string
    hlt

print_string:
    .loop:
        lodsb           # Load byte from DS:SI into AL
        test %al, %al   # Test if AL is zero (end of string)
        jz .done
        mov $0x0E, %ah  # BIOS teletype function
        int $0x10       # BIOS interrupt
        jmp .loop
    .done:
        ret
 
msg:
    .asciz "Loading Kernelcore..."

err_msg:
    .asciz "Disk read error!"

.section .text
.org 510
.byte 0x55, 0xAA