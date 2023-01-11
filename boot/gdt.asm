;;;
;;; Set up gdt
;;;

align 4

GDT :
    .null_seg : equ $ - GDT
        dq 0
    
    .code_seg : equ $ - GDT
        dw 0xffff       ; Limit (0-15  bit)
        dw 0            ; Base  (0-15  bit)
        db 0            ; Base  (16-23 bit)
        db 10011010b    ; Access byte
        db 10101111b    ; Limit (16-19 bit) + Flags
        db 0            ; Base  (24-31 bit)


    .data_seg : equ $ - GDT
        dw 0xffff       ; Limit (0-15  bit)
        dw 0            ; Base  (0-15  bit)
        db 0            ; Base  (16-23 bit)
        db 10010010b    ; Access byte
        db 11001111b    ; Limit (16-19 bit) + Flags
        db 0            ; Base  (24-31 bit)

GDT_descriptor :
    dw $ - GDT - 1
    dq GDT