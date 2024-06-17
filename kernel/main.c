#include <stdint.h>

int i;
char c = 'F';

void kernel_main() {
    char* video_memory = (char*) 0xb8000;
    *video_memory = c;

    for(;;){
    }
}