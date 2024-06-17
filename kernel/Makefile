include ../Makefile.config

# Define variables
TARGET = kernel.elf
SRC = main.c
OBJ = main.o

.PHONY: all clean

# Default target
all: $(TARGET)

# Rule to create the target binary
$(TARGET): $(OBJ)
	$(LD) $(LDFLAGS) -e _start -Ttext 0x10000 -o $(TARGET) ../arch/x86/boot/kernelcore.o $(OBJ)
	objcopy -O binary kernel.elf kernel.bin

# Rule to compile the source file into an object file
$(OBJ): $(SRC)
	$(CC) $(CFLAGS) -c -o $(OBJ) $(SRC)

# Clean up generated files
clean:
	rm -f $(OBJ) $(TARGET)
