.PHONY: all build build-kernel build-libs build-arch clean

all: build

run:
	qemu-system-x86_64 -drive format=raw,file=floppy.img -vga std -monitor stdio

build: build-arch build-kernel
	# Create a 1.44MB floppy image filled with zeros
	#dd if=/dev/zero of=floppy.img bs=512 count=2880

	# Write the boot sector to the first sector
	dd if=arch/x86/boot/boot.bin of=floppy.img bs=512 count=1 conv=notrunc

	# Calculate the size of the kernel in sectors (rounding up)
	# Pad the sectors where the kernel will be placed with zeros
	dd if=/dev/zero bs=512 seek=1 count=$(shell echo $$((($$(stat -c%s kernel/kernel.bin) + 511) / 512))) of=floppy.img conv=notrunc

	# Write the kernel to the image starting from the second sector
	dd if=kernel/kernel.bin of=floppy.img bs=512 seek=1 conv=notrunc

	# Write the kernel signature after the kernel
	cat arch/x86/boot/kernelsig.bin >> floppy.img

build-kernel:
	$(MAKE) -C kernel

build-libs:
	$(MAKE) -C libs

build-arch:
	$(MAKE) -C arch/x86

clean:
	find . -name "*.o" -type f -delete
	find . -name "*.bin" -type f -delete
	find . -name "*.elf" -type f -delete
	find . -name "*.img" -type f -delete
	$(MAKE) -C kernel clean
	$(MAKE) -C libs clean
	$(MAKE) -C arch clean