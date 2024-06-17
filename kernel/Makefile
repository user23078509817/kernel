include ../Makefile.config

# Define variables
TARGET = kernel.bin
SRC = main.c
OBJ = main.o

.PHONY: all clean

# Default target
all: $(TARGET)

# Rule to create the target binary
$(TARGET): $(OBJ)
	$(LD) -Ttext 0x10000 --oformat binary -o $(TARGET) ../arch/x86/boot/kernelcore.o $(OBJ)

# Rule to compile the source file into an object file
$(OBJ): $(SRC)
	$(CC) $(CFLAGS) -c -o $(OBJ) $(SRC)

# Clean up generated files
clean:
	rm -f $(OBJ) $(TARGET)
