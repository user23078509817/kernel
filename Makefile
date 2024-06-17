.PHONY: all build build-kernel build-libs build-arch clean

all: build

run:
	qemu-system-i386 floppy.img -monitor stdio

build: build-arch build-kernel

	dd if=/dev/zero of=floppy.img bs=512 count=2880

	dd if=arch/x86/boot/boot.bin of=floppy.img
	dd if=kernel/kernel.bin of=floppy.img bs=512 seek=1 conv=notrunc

	dd if=/dev/zero bs=512 count=2880 >> floppy.img

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
	$(MAKE) -C kernel clean
	$(MAKE) -C libs clean
	$(MAKE) -C arch clean