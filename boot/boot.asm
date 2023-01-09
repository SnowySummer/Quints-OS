;;;
;;; Bootloader
;;;

; Tell nasm where bios starts
org 0x7c00

; Bootsector
bootsector :

bootsector_init :
	jmp 0x0000:bootsector_code

bootsector_include :
	%include "boot/print.asm"

bootsector_code :

	; Prepare stack
	mov sp, bootsector

	; Print message
	mov si, mess
	call print

	mov dx, 0x1234
	call hex_print

	; Hold
	jmp $


bootsector_data :
	mess : db "Quints OS", 0x0a, 0xd, 0


bootsector_magic :
	times 510 - ($ - $$) db 0
	dw 0xaa55
