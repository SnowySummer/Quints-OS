;;;
;;; Setting up printing in 16-bit mode
;;;

print :
	; Setting teletype output
	pusha
	mov ah, 0x0e
	mov bh, 0x00

	.print_loop :
		; Get character and verify not 0
		mov al, [si]
		or al, al
		jz .print_finish

		; Print and prepare next character
		int 0x10
		inc si
		jmp .print_loop

	; Finish print
	.print_finish:
		popa
		ret


hex_print :
	
	pusha
	mov si, hex_mess
	add si, 5


	.hex_print_loop :
		mov bx, dx
		shr dx, 4
		and bx, 0xf
		mov ax, [hex_val + bx]
		mov [si], al
		dec si
		cmp si, hex_mess + 1
		jnz .hex_print_loop
	

	.hex_print_finish :
		mov si, hex_mess
		call print
		popa
		ret
	
	

hex_mess : db "0x0000", 0
hex_val : db "0123456789ABCDEF"
