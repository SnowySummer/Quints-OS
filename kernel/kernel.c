
#include <stdint.h>

typedef struct __attribute__((packed)){
    uint8_t character;
    uint8_t style;
} VGA_char;


int main(){

    volatile VGA_char *screen = (VGA_char*) 0xb8000;

    VGA_char t;
    t.style = 0x9f;
    t.character = '~';

    for (int i = 0; i < 80 * 25; i++){
            screen[i] = t;
    }


    


    return 0;
}