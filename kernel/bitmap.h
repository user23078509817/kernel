#include "kmalloc.c"

typedef struct bitmap{
    int width, height;
    int format;
    char* data;
} bitmap_t;