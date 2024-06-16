#include <stdint.h>

char c = 'D';

void main() {
    char* video_memory = (char*) 0xb8000;
    *video_memory = c;

    for(;;){

    }
}