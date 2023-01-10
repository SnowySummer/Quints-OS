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
		%include "boot/screen.asm"
		%include "boot/disk.asm"

	bootsector_data :
		NUM_SECTORS equ 1
		START_SECTOR equ 2

		DRIVE : db 0
		mess : db "Quints OS", 0x0a, 0xd, 0
		
	bootsector_code :

		; Initialise
		mov [DRIVE], dl
		mov sp, bootsector

		; Set background color
		mov bl, 0x09
		call screen_background

		; Print message
		mov si, mess
		call print

		; Load bootloader stage 2
		xor ax, ax
		mov es, ax
		mov bx, bootloader_stage2

		mov al, NUM_SECTORS
		mov cl, START_SECTOR
		mov dl, [DRIVE]
		call read_disk

		jmp bootloader_stage2_code

		; Hold
		hlt




	bootsector_magic :
		times 510 - ($ - $$) db 0
		dw 0xaa55

bootloader_stage2 :
	bootloader_stage2_data :
		MESS1 : db "Hi there! Onto stage 2!", 0x0a, 0x0d, 0
	bootloader_stage2_code :
		mov si, MESS1
		call print

		hlt

	bootloader_stage2_finish :
		times 512 - ($ - bootloader_stage2) db 0