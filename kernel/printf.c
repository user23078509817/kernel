#include "printf.h"

const char hex_codes[] = {
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F'
};

static void printf_putchar(char c){
    console_putchar(c);
}

static void printf_putstr(char* str){
    console_putstr(str);
}

static void printf_puthexstr(int i){
    console_putchar(hex_codes[i >> 4 & 15]);
    console_putchar(hex_codes[i & 15]);
}

static void printf_putuint(unsigned int i){
    int f = 1;

    while((i / f) >= 10){
        f *= 10;
    }

    int r;
    while(f > 0){
        r = i / f;
        printf_putchar('0' + r);
        i = i - (r * f);
        f /= 10;
    }
}

static void printf_putint(int i){
    int f = 1;

    if(i < 0){
        printf_putchar('-');
        i *= -1;
    }

    while((i / f) >= 10){
        f *= 10;
    }

    int r;
    while(f > 0){
        r = i / f;
        printf_putchar('0' + r);
        i = i - (r * f);
        f /= 10;
    }
}

static void printf_putfloat(float n, int len, int precision){
    int f = 1;

    if(n < 0){
        printf_putchar('-');
        n *= -1;
    }

    while((n / f) >= 10){
        f *= 10;
    }

    int r;
    while(f > 0){
        r = n / f;
        printf_putchar('0' + r);
        n = n - (r * f);
        f /= 10;
    }

    float frac_part = n - (float)(int)n;
    if(frac_part > 0){
        printf_putchar('.');
        for (int j = 0; j < 2; ++j) {
            frac_part *= 10;
            int digit = (int)frac_part;
            printf_putchar('0' + digit);
            frac_part -= digit;
        }
    }
}

void printf(const char* str, ...){

    va_list args;

    uint32_t u;
	int32_t i;
    float f;
	char *string;

	va_start(args, str);

    while(*str){

        if(*str != '%'){
            printf_putchar(*str);
        }
        else{
            str++;
            switch(*str){
                case 'd':
                    i = va_arg(args, int);
                    printf_putint(i);
                    break;
                case 'u':
                    u = va_arg(args, unsigned int);
                    printf_putuint(u);
                    break;
                case 'f':
                    f = va_arg(args, double);

                    int len = -1;
                    int precision = -1;
                    if(is_int(str + 1)){
                        
                        if(str + 2 == '.' && is_int(str + 3)){
                        
                        }
                    }
                    else{
                        if(str + 1 == '.' && is_int(str + 2)){

                        }
                    }

                    printf_putfloat(f, -1, -1);
                    break;
                case 'x':
                    i = va_arg(args, int);
                    printf_puthexstr(i);
                    break;
                case 's':
                    string = va_arg(args, char*);
                    printf_putstr(string);
                    break;
                case 'c':
                    u = va_arg(args, unsigned int);
                    printf_putchar(u);
                    break;
                case '0':
                    break;
                default:
                    printf_putchar(*str);
                    break;
            }
        }

        str++;
    }

}