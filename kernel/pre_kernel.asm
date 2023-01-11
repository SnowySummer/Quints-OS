[bits 64]
[extern main]

pre-kernel :
    call main

    hlt
    jmp $