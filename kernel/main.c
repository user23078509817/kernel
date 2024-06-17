#include <stdint.h>

char c = 'X';
//sdf
void kernel_main() {
    char* video_memory = (char*) 0xb8000;
    *video_memory = 'D';

    for(;;){

    }
}