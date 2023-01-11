[bits 64]
[extern main]

pre_kernel :
    cli
    call main

    hlt
    jmp $