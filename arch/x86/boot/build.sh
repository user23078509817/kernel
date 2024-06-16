as -32 -o build/boot.o boot.S
as -32 -o build/ext.o ext.S
gcc -m16 -c main.c -o build/main.o -ffreestanding -fno-pie

ld -m elf_i386 -Ttext 0x7C00 --oformat binary -o build/boot.bin build/boot.o
#ld -m elf_i386 -Ttext 0x7e00 --oformat binary build/ext.o -o build/ext.bin
ld -m elf_i386 -e main -Ttext 0x7e00 --oformat binary build/main.o -o build/main.bin

dd if=/dev/zero of=floppy.img bs=512 count=2880

# Write the bootloader to the first sector
dd if=build/boot.bin of=floppy.img
#dd if=build/ext.bin of=floppy.img bs=512 seek=1 count=1 conv=notrunc
dd if=build/main.bin of=floppy.img bs=512 seek=1 count=1 conv=notrunc

dd if=/dev/zero bs=512 count=2880 >> floppy.img