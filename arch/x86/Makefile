include ../../Makefile.config

CC = gcc -m32
LD = ld -melf_i386
SRCS = $(wildcard *.c)
OBJS = $(SRCS:.c=.o)

.PHONY: all clean

all: build_bootloader build_kernelentry

build_bootloader: boot/boot.o
	$(LD) -Ttext 0 --oformat binary -o boot/boot.bin $<

build_kernelentry: boot/kernelcore.o

%.o: %.c
	${CC} ${CFLAGS} -I ../include $< -o $@

%.o: %.S
	${CC} ${CFLAGS} $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)
