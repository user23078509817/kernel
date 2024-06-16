.PHONY: all build build-kernel build-libs build-arch clean

all: build

run:
	qemu-system-x86_64 floppy.img -monitor stdio

build: build-arch build-kernel

	dd if=/dev/zero of=floppy.img bs=512 count=2880

	dd if=arch/x86/boot/boot.bin of=floppy.img
	dd if=arch/x86/boot/core.bin of=floppy.img bs=512 seek=1 count=1 conv=notrunc
	dd if=kernel/kernel.bin of=floppy.img bs=512 seek=2 count=1 conv=notrunc

	dd if=/dev/zero bs=512 count=2880 >> floppy.img

build-kernel:
	$(MAKE) -C kernel

build-libs:
	$(MAKE) -C libs

build-arch:
	$(MAKE) -C arch/x86

clean:
	$(MAKE) -C kernel clean
	$(MAKE) -C libs clean
	$(MAKE) -C arch clean
