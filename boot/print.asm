;;;
;;; Setting up printing in 16-bit mode
;;;

print :
	; Setting teletype output
	push ax
	push bx
	mov ah, 0x0e
	mov bh, 0x00

	.print_loop :
		; Get character and verify not 0
		mov al, [si]
		or al, al
		jz print_finish

		; Print and prepare next character
		int 0x10
		inc si
		jmp .print_loop

	; Finish print
	print_finish:
		pop bx
		pop ax
		ret
