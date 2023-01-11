;;;
;;; Set up paging for long mode
;;;


setup_paging :

    ; 0 out page table
    mov edi, 0x1000
    mov cr3, edi
    xor eax, eax
    mov ecx, 4096
    rep stosd

    ; Link the different page tables
    mov edi, cr3
    mov dword [edi], 0x2003
    add edi, 0x1000
    mov dword [edi], 0x3003
    add edi, 0x1000
    mov dword [edi], 0x4003
    add edi, 0x1000

    ; Identity the last page table
    mov ebx, 0x3
    mov ecx, 512

    .page_setup :
        mov [edi], ebx
        add edi, 8
        add ebx, 0x1000
        loop .page_setup
    

    ; Enable PAE paging
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax


    ret