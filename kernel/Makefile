# Define variables
CC = gcc
CFLAGS = -m32 -ffreestanding -fno-pie -O0
LDFLAGS = -m32 -nostdlib -lgcc -Wl,--oformat,binary -Wl,-e,main
TARGET = kernel.bin
SRC = main.c
OBJ = main.o

.PHONY: all clean

# Default target
all: $(TARGET)

# Rule to create the target binary
$(TARGET): $(OBJ)
	$(CC) $(LDFLAGS) -o $(TARGET) $(OBJ) -T linker.ld

# Rule to compile the source file into an object file
$(OBJ): $(SRC)
	$(CC) $(CFLAGS) -c -o $(OBJ) $(SRC)

# Clean up generated files
clean:
	rm -f $(OBJ) $(TARGET)
