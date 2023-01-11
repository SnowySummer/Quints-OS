;;;
;;; Check if long mode is available
;;;

check_long_mode :

check_cpuid :

    ; Get flag and store in ecx
    pushfd
    pop eax
    mov ecx, eax

    ; Swap 21st bit and put in flags
    xor eax, 1 << 21
    push eax
    popfd
    pushfd
    pop eax

    ; Compare (should be different)
    mov si, CHECK_CPUID_ERROR_MESS
    cmp eax, ecx
    je check_error


    ; Check extended function
    mov eax, 0x80000000
    cpuid
    mov si, CHECK_CPUID_ERROR_MESS
    cmp eax, 0x80000001
    jb check_error
    

    ; Check long mode
    mov eax, 0x80000001
    cpuid
    shr edx, 29
    mov si, CHECK_LONG_MODE_ERROR_MESS
    and edx, 1
    jz check_error

    ret



    ; CPUID unavailable
    check_error :
        call print
        hlt
        jmp $

    CHECK_CPUID_ERROR_MESS : db "CPUID unavailable", 0x0a, 0x0d, 0
    CHECK_EXTEND_FUNCTION_ERROR_MESS : db "CPUID extended function unavailable", 0x0a, 0x0d, 0
    CHECK_LONG_MODE_ERROR_MESS : db "Long mode unavailable", 0x0a, 0x0d, 0

    
    ret



enable_long_mode :

    ; Enable long mode
    mov ecx, 0xc0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ; Enable paging and protected mode
    mov eax, cr0
    or eax, 1 << 31
    or eax, 1 << 0
    mov cr0, eax

    ret

