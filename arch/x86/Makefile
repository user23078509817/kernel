CC = gcc
CFLAGS = -Wall -m32 -ffreestanding -nostdlib -Wextra -O2
TARGET = x86.bin
SRCS = $(wildcard *.c)
OBJS = $(SRCS:.c=.o)

.PHONY: all clean

all: build_bootloader $(TARGET)

build_bootloader:
	$(CC) -m32 -Ttext 0x7C00 -nostdlib -nodefaultlibs -nostartfiles -fno-builtin -Wl,--oformat,binary -o boot/boot.bin boot/boot.S
	$(CC) -m32 -Ttext 0x7E00 -nostdlib -nodefaultlibs -nostartfiles -fno-builtin -Wl,--oformat,binary -o boot/core.bin boot/kernelcore.S


$(TARGET): $(OBJS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)
