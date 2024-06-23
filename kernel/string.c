#include "string.h"

int strlen(char * str){
    int len = 0;
    while(*str){
        str++;
        len++;
    }
    return len;
}

int is_int(char c){
    if(c >= '0' && c <= '9'){
        return 1;
    }
    return 0;
}
