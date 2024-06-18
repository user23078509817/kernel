#include "../memlayout.h"

.global _start

.code16
.text

ljmp $BOOTBLOCK_SEGMENT, $_start

_start:
    cli                 # Disable interrupts
    cld				    # clear the direction flag
	mov	%cs, %ax		# set all segments to code
	mov	%ax, %ds
	mov	%ax, %es

    mov	$INTERRUPT_STACK_SEGMENT, %ax     # set up the stack
	mov	%ax, %ss
	mov	$INTERRUPT_STACK_OFFSET, %sp

    # Print a message
    mov $msg, %si
    call print_string

    mov $KERNEL_SEGMENT, %ax # Destination Segment -> es = KERNEL_SEGMENT
    mov %ax, %es

    movb $0x02, %cl      # Sector number

load:
    movw (last_sector), %bx    # Destination offset within segment (ES:BX)
    movb $0x02, %ah      # BIOS read sector function
    movb $0x01, %al      # Number of sectors to read (1 sector)
    movb $0x00, %ch      # Cylinder number
    movb $0x00, %dh      # Head number
    int $0x13            # BIOS interrupt

    jc disk_error        # Jump to disk_error on carry flag set
    
    jmp loadnext

loadnext:
    mov (last_sector), %bx
    add $512, %bx
    mov %bx, (last_sector)

    inc %cl

    mov $KERNEL_SEGMENT, %ax
    mov %ax, %ds

    movw -2(%bx), %ax

    cmpw $0x55aa, %ax

    mov %cs, %ax
    mov %ax, %ds

    je loaddone

    jmp load

loaddone:
    mov $KERNEL_SEGMENT, %ax
    mov %ax, %ds
    mov %ax, %ss
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs

    mov (sectors_loaded), %ax

    ljmp $KERNEL_SEGMENT, $KERNEL_OFFSET            # Jump to the loaded code (adjust as needed)

disk_error:
    # Print error message and halt
    mov $err_msg, %si
    call print_string
    hlt

#
# Helper Functions
#

hlt:
    jmp .

print_string:
    .loop:
        lodsb            # Load byte from DS:SI into AL
        test %al, %al    # Test if AL is zero (end of string)
        jz .done
        mov $0x0E, %ah   # BIOS teletype function
        int $0x10        # BIOS interrupt
        jmp .loop
    .done:
        ret

#
# Strings
#

msg:
    .asciz "Loading Kernelcore..."

err_msg:
    .asciz "Disk read error!"

#
# Data
#

sectors_loaded:
    .word 0x0000

last_sector:
    .word KERNEL_OFFSET

.org 510
.byte 0x55, 0xAA
