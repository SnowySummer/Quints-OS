;;;
;;; Test and enable A20 line
;;;

enable_A20 :
    in al, 0x92
    or al, 2
    out 0x92, al

test_A20 :
    ; Checking overflowed value 1st time
    mov ax, [0x7dfe]
    mov bx, 0xffff
    mov es, bx
    mov bx, 0x7e0e
    mov dx, [es:bx]
    cmp ax, dx
    jne test_A20_passed
 
    ; Checking overflowed value 2nd time
    mov ax, [0x7dff]
    mov bx, 0xffff
    mov es, bx
    mov bx, 0x7e0f
    mov dx, [es:bx]
    cmp ax, dx
    jne test_A20_passed
 
    test_A20_failed:
        mov si, TEST_A20_FAILED_MESS
        call print
        
        hlt
        jmp $

    test_A20_passed :
        mov si, TEST_A20_PASSED_MESS
        call print
        ret

TEST_A20_FAILED_MESS : db 'A20 line disabled', 0x0a, 0x0d, 0
TEST_A20_PASSED_MESS : db 'A20 line enabled', 0x0a, 0x0d, 0