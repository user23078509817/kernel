include ../../Makefile.config

SRCS = $(wildcard *.c)
OBJS = $(SRCS:.c=.o)

.PHONY: all clean

all: build_bootloader build_kernelentry build_kernelsig build

build: $(OBJS)

build_bootloader: boot/boot.o
	$(LD) -Ttext 0 --oformat binary -o boot/boot.bin $<

build_kernelentry: boot/kernelcore.o

build_kernelsig: boot/kernelsig.o
	$(LD) --oformat binary -o boot/kernelsig.bin $<

%.o: %.c
	${CC} ${CFLAGS} -I ../include $< -o $@

%.o: %.S
	${CC} ${CFLAGS} -I ../include $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)
