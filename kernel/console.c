#include "console.h"

console_t* k_console = {0};

console_t* console_init(){
    console_t* console = (console_t*) kmalloc(sizeof(struct console));

    console->height = video_yres / 8;
    console->width = video_xres / 8;

    console->x = 0;
    console->y = 0;

}

void console_setref(console_t* c){
    k_console = c;
}

void console_write(char* data, int len){

    for(int i = 0; i < len; i++){

        if(k_console->x > k_console->width){
            k_console->y++;
            k_console->x = 0;
        }

        switch(data[i]){
            case 0x0:
                return;
                break;
            case 0x0A:
                k_console->y++;
                k_console->x = 0;
                break;
            default:
                graphics_draw_char(k_console->x * 8, k_console->y * 8, data[i], (graphics_color_t){.red = 255,
                 .green = 255,
                 .blue = 255,
                });
                k_console->x++;
        }
    }

}

void console_putchar(char c){
    console_write(&c, 1);
}

void console_putint(int i){
}

void console_putstr(char* str){
    console_write(str, strlen(str));
}
