#include "graphics.h"

static int plot_pixel(int x, int y, char* data, graphics_color_t t){
    for(int i = 0; i < 8; i++){
        for(int j = 0; j < 8; j++){
            uint8_t* v = (video_buffer + (((x + j) + (y + i) * video_xres) * 3));
            if((data[i] >> (7-j) & 1)){
                v[0] = t.blue;
                v[1] = t.green;
                v[2] = t.red;
            }
            else{
                v[0] = t.bg;
                v[1] = t.bg;
                v[2] = t.bg;
            }
        }
    }
}

void graphics_draw_char(int x, int y, char c, graphics_color_t t){
    plot_pixel(x, y, &fontdata[c*8], t);
}

int graphics_draw_pixel(int x, int y, int color){
    // 3 bytes per pixel => 24 bit colors
    char* v = (video_buffer + (3 * x) + y * 3 * video_xres);
    v[2] = color >> 24;
    v[1] = color >> 16;
    v[0] = color >> 8;

    return 1;
}