#include "../../../kernel/memlayout.h"

.code16
.text
.global _start
_start:
    jmp _realstart

_realstart:

	mov $0x4f00, %ax
	mov $(vesa_info-_start),%di
	int $0x10

	mov	$0x4f02, %ax
 	movw $0x4118, %bx
	int	$0x10

	mov	%ds, %ax		# Set up the extra segment
	mov	%ax, %es		# with the data segment

	mov	$(video_info-_start),%di
	mov	$0x4f01, %ax
	mov	%bx, %cx
	int	$0x10
	
	# enable A20 line
    inb $0x92, %al      
    orb $2, %al
    outb %al, $0x92

    # Load GDT
    lgdt (gdt_init-_start)

    # Enter protected mode
    mov %cr0, %eax
    or $1, %eax
    mov %eax, %cr0

    mov	$(2*8), %ax		# selector two is flat 4GB data data
	mov	%ax, %ds		# set data, extra, and stack segments to selector two
	mov	%ax, %es
	mov	%ax, %ss

    xor %ax, %ax
    mov %ax, %fs
    mov %ax, %gs

    mov	$INTERRUPT_STACK_TOP, %sp    # set up initial C stack
	mov	$INTERRUPT_STACK_TOP, %bp    # set up initial C stack

    # Far jump to flush prefetch queue and switch to protected mode
    ljmpl $(1*8), $pm_start

.code32

pm_start:
	mov $0xfd000000, %eax
	mov $0xff, (%eax);
	jmp .
	ljmpl $(1*8), $(kernel_main)

# The video_info structure is filled in by a BIOS
# call above, and is used to record the basic video
# layout for the graphics subsystem.  See page 30
# of the VBE specification for an explanation of this structure.

.align 4
vesa_info:
.rept 508
	.byte 0
.endr

.align 4
video_info:
	.word	0
	.byte	0,0
	.word	0,0,0,0
	.long	0
.global video_xbytes
video_xbytes:
	.word	0
.global video_xres
video_xres:
	.word	0 
.global video_yres
video_yres:
	.word	0
	.byte	0,0,0,0,0,0,0,0,0
	.byte	0,0,0,0,0,0,0,0,0
.global video_buffer
video_buffer:
	.long	0
	.long	0
	.word	0
	.word	0
	.byte	0,0,0,0,0,0,0,0,0,0
	.long	0
.rept 190
	.byte	0
.endr

.align 16
.global gdt
gdt:
	.word	0,0,0,0				# seg 0 - null
	.word	0xffff, 0x0000, 0x9a00, 0x00cf	# seg 1 - kernel flat 4GB code
	.word	0xffff, 0x0000, 0x9200, 0x00cf	# seg 2 - kernel flat 4GB data
	.word	0xffff, 0x0000, 0xfa00, 0x00cf	# seg 3 - user flat 4GB code
	.word	0xffff, 0x0000, 0xf200, 0x00cf	# seg 4 - user flat 4GB data
	
# This is the initializer for the global descriptor table.
# It simply tells us the size and location of the table.

gdt_init:
	.word	gdt_init-gdt
	.long	gdt

# First, the internal interrupts.
# Note that some already push their own detail
# code onto the stack.  For the others, we push
# a zero, just to get a common layout.

intr00: pushl $0 ; pushl $0  ; jmp intr_handler
intr01: pushl $0 ; pushl $1  ; jmp intr_handler
intr02: pushl $0 ; pushl $2  ; jmp intr_handler
intr03: pushl $0 ; pushl $3  ; jmp intr_handler
intr04: pushl $0 ; pushl $4  ; jmp intr_handler
intr05: pushl $0 ; pushl $5  ; jmp intr_handler
intr06: pushl $0 ; pushl $6  ; jmp intr_handler
intr07: pushl $0 ; pushl $7  ; jmp intr_handler
intr08:            pushl $8  ; jmp intr_handler
intr09: pushl $0 ; pushl $9  ; jmp intr_handler
intr10:            pushl $10 ; jmp intr_handler
intr11:            pushl $11 ; jmp intr_handler
intr12:            pushl $12 ; jmp intr_handler
intr13:            pushl $13 ; jmp intr_handler
intr14:            pushl $14 ; jmp intr_handler
intr15: pushl $0 ; pushl $15 ; jmp intr_handler
intr16: pushl $0 ; pushl $16 ; jmp intr_handler
intr17:            pushl $17 ; jmp intr_handler
intr18: pushl $0 ; pushl $18 ; jmp intr_handler
intr19: pushl $0 ; pushl $19 ; jmp intr_handler

# These interrupts are reserved, but could
# conceivably occur on the next processor model

intr20: pushl $0 ; pushl $20 ; jmp intr_handler
intr21: pushl $0 ; pushl $21 ; jmp intr_handler
intr22: pushl $0 ; pushl $22 ; jmp intr_handler
intr23: pushl $0 ; pushl $23 ; jmp intr_handler
intr24: pushl $0 ; pushl $24 ; jmp intr_handler
intr25: pushl $0 ; pushl $25 ; jmp intr_handler
intr26: pushl $0 ; pushl $26 ; jmp intr_handler
intr27: pushl $0 ; pushl $27 ; jmp intr_handler
intr28: pushl $0 ; pushl $28 ; jmp intr_handler
intr29: pushl $0 ; pushl $29 ; jmp intr_handler
intr30: pushl $0 ; pushl $30 ; jmp intr_handler
intr31: pushl $0 ; pushl $31 ; jmp intr_handler

# Now, the external hardware interrupts.

intr32: pushl $0 ; pushl $32 ; jmp intr_handler
intr33: pushl $0 ; pushl $33 ; jmp intr_handler
intr34: pushl $0 ; pushl $34 ; jmp intr_handler
intr35: pushl $0 ; pushl $35 ; jmp intr_handler
intr36: pushl $0 ; pushl $36 ; jmp intr_handler
intr37: pushl $0 ; pushl $37 ; jmp intr_handler
intr38: pushl $0 ; pushl $38 ; jmp intr_handler
intr39: pushl $0 ; pushl $39 ; jmp intr_handler
intr40: pushl $0 ; pushl $40 ; jmp intr_handler
intr41: pushl $0 ; pushl $41 ; jmp intr_handler
intr42: pushl $0 ; pushl $42 ; jmp intr_handler
intr43: pushl $0 ; pushl $43 ; jmp intr_handler
intr44: pushl $0 ; pushl $44 ; jmp intr_handler
intr45: pushl $0 ; pushl $45 ; jmp intr_handler
intr46: pushl $0 ; pushl $46 ; jmp intr_handler
intr47: pushl $0 ; pushl $47 ; jmp intr_handler
intr48: pushl $0 ; pushl $48 ; jmp intr_syscall

intr_handler:
	pushl	%ds		# push segment registers
	pushl	%es
	pushl	%fs
	pushl	%gs
	pushl	%ebp		# push general regs
	pushl	%edi
	pushl	%esi
	pushl	%edx
	pushl	%ecx
	pushl	%ebx
	pushl	%eax
	pushl	48(%esp)	# push interrupt code from above
	pushl	48(%esp)	# push interrupt number from above
	movl	$2*8, %eax	# switch to kernel data seg and extra seg
	movl	%eax, %ds
	movl	%eax, %es
	#call	interrupt_handler
	addl	$4, %esp	# remove interrupt number
	addl	$4, %esp	# remove interrupt code
	jmp	intr_return
	
intr_syscall:
	pushl	%ds		# push segment registers
	pushl	%es
	pushl	%fs
	pushl	%gs
	pushl	%ebp		# push general regs
	pushl	%edi
	pushl	%esi
	pushl	%edx
	pushl	%ecx
	pushl	%ebx
	pushl	%eax		# note these *are* the syscall args
	movl	$2*8, %eax	# switch to kernel data seg and extra seg
	movl	%eax, %ds
	movl	%eax, %es
	#call	syscall_handler
	addl	$4, %esp	# remove the old eax
	jmp	syscall_return	

.global intr_return
intr_return:
	popl	%eax
syscall_return:	
	popl	%ebx
	popl	%ecx
	popl	%edx
	popl	%esi
	popl	%edi
	popl	%ebp
	popl	%gs
	popl	%fs
	popl	%es
	popl	%ds
	addl	$4, %esp	# remove interrupt num
	addl	$4, %esp	# remove detail code
	iret			# iret gets the intr context
			
.align 2
idt:
	.word	intr00-_start,1*8,0x8e00,0x0001
	.word	intr01-_start,1*8,0x8e00,0x0001
	.word	intr02-_start,1*8,0x8e00,0x0001
	.word	intr03-_start,1*8,0x8e00,0x0001
	.word	intr04-_start,1*8,0x8e00,0x0001
	.word	intr05-_start,1*8,0x8e00,0x0001
	.word	intr06-_start,1*8,0x8e00,0x0001
	.word	intr07-_start,1*8,0x8e00,0x0001
	.word	intr08-_start,1*8,0x8e00,0x0001
	.word	intr09-_start,1*8,0x8e00,0x0001
	.word	intr10-_start,1*8,0x8e00,0x0001
	.word	intr11-_start,1*8,0x8e00,0x0001
	.word	intr12-_start,1*8,0x8e00,0x0001
	.word	intr13-_start,1*8,0x8e00,0x0001
	.word	intr14-_start,1*8,0x8e00,0x0001
	.word	intr15-_start,1*8,0x8e00,0x0001
	.word	intr16-_start,1*8,0x8e00,0x0001
	.word	intr17-_start,1*8,0x8e00,0x0001
	.word	intr18-_start,1*8,0x8e00,0x0001
	.word	intr19-_start,1*8,0x8e00,0x0001
	.word	intr20-_start,1*8,0x8e00,0x0001
	.word	intr21-_start,1*8,0x8e00,0x0001
	.word	intr22-_start,1*8,0x8e00,0x0001
	.word	intr23-_start,1*8,0x8e00,0x0001
	.word	intr24-_start,1*8,0x8e00,0x0001
	.word	intr25-_start,1*8,0x8e00,0x0001
	.word	intr26-_start,1*8,0x8e00,0x0001
	.word	intr27-_start,1*8,0x8e00,0x0001
	.word	intr28-_start,1*8,0x8e00,0x0001
	.word	intr29-_start,1*8,0x8e00,0x0001
	.word	intr30-_start,1*8,0x8e00,0x0001
	.word	intr31-_start,1*8,0x8e00,0x0001
	.word	intr32-_start,1*8,0x8e00,0x0001
	.word	intr33-_start,1*8,0x8e00,0x0001
	.word	intr34-_start,1*8,0x8e00,0x0001
	.word	intr35-_start,1*8,0x8e00,0x0001
	.word	intr36-_start,1*8,0x8e00,0x0001
	.word	intr37-_start,1*8,0x8e00,0x0001
	.word	intr38-_start,1*8,0x8e00,0x0001
	.word	intr39-_start,1*8,0x8e00,0x0001
	.word	intr40-_start,1*8,0x8e00,0x0001
	.word	intr41-_start,1*8,0x8e00,0x0001
	.word	intr42-_start,1*8,0x8e00,0x0001
	.word	intr43-_start,1*8,0x8e00,0x0001
	.word	intr44-_start,1*8,0x8e00,0x0001
	.word	intr45-_start,1*8,0x8e00,0x0001
	.word	intr46-_start,1*8,0x8e00,0x0001
	.word	intr47-_start,1*8,0x8e00,0x0001
	.word	intr48-_start,1*8,0xee00,0x0001
	
# This is the initializer for the global interrupt table.
# It simply gives the size and location of the interrupt table
	
idt_init:
	.word	idt_init-idt
	.long	idt

# This is the initializer for an invalid interrupt table.
# Its only purpose is to assist with the reboot routine.
	
idt_invalid:
	.word	0
	.long	0