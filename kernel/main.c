#include <stdint.h>
#include "memlayout.h"
#include "kmalloc.h"
#include "printf.h"
#include "string.h"
#include "console.h"
#include "graphics.h"
#include "globals.h"

void kernel_main() {

    kmalloc_init((char*) KMALLOC_START, KMALLOC_LENGTH);

    console_t* console = console_init();
    console_setref(console);

    int i = 42;
    unsigned int u = 123;
    float f = 3.14159f;
    char c = 'A';
    char *s = "Hello, world!";
    int zero = 0;

    // Test %d (integer)
    printf("Integer (%%d): %d\n", i);

    // Test %u (unsigned integer)
    printf("Unsigned Integer (%%u): %u\n", u);

    // Test %f (float)
    printf("Float (%%f): %f\n", f);

    // Test %x (hexadecimal)
    printf("Hexadecimal (%%x): %x\n", i);

    // Test %s (string)
    printf("String (%%s): %s\n", s);

    // Test %c (character)
    printf("Character (%%c): %c\n", c);

    // Test %0 (print zero)
    printf("Zero (%%d): %d\n", zero);
    for(;;){
        for(int i = 0; i < video_yres; i++){
            graphics_draw_pixel(i,i, 0xffffff00);
        }
    }
}