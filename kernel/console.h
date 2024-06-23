#pragma once
#include <stdint.h>
#include "kmalloc.h"
#include "graphics.h"
#include "string.h"
#include "globals.h"

typedef struct console{
    int width, height;
    int x, y;
    char* buffer; // Command buffer
} console_t;

extern console_t* k_console;

console_t* console_init();
void console_setref(console_t* c);

void console_write(char* data, int len);

void console_putchar(char c);
void console_putint(int i);
void console_putstr(char* c);