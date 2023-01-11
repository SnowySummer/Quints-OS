;;;
;;; Bootloader
;;;

; Tell nasm where bios starts
; and set up 16 bit real mode
org 0x7c00
[bits 16]

; Bootloader meta-information
STAGE2_SIZE equ 2
STAGE2_START equ 2

KERNEL_SIZE equ 2


; Bootsector
bootsector :

	bootsector_init :
		jmp 0x0000:bootsector_code

	bootsector_include :
		%include "boot/print.asm"
		%include "boot/screen.asm"
		%include "boot/disk.asm"

	bootsector_data :
		DRIVE : db 0
		mess : db "Quints OS : Bootsector", 0x0a, 0xd, 0
		
	bootsector_code :

		; Initialise
		mov [DRIVE], dl
		mov sp, bootsector


		; Set video mode
		mov al, 0x03
		call screen_mode

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

		mov al, STAGE2_SIZE
		mov cl, STAGE2_START
		mov dl, [DRIVE]
		call read_disk

		jmp bootloader_stage2_code

		; Hold
		hlt
		jmp $




	bootsector_magic :
		times 510 - ($ - $$) db 0
		dw 0xaa55

; Bootloader stage 2
bootloader_stage2 :
	bootloader_stage2_include :
		%include "boot/a20.asm"
		%include "boot/long_mode.asm"
		%include "boot/paging.asm"
		%include "boot/gdt.asm"
	bootloader_stage2_data :
		MESS1 : db "Hi there! Onto stage 2!", 0x0a, 0x0d, 0
	bootloader_stage2_code :

		; Print message
		mov si, MESS1
		call print


		; Load kernel
		xor ax, ax
		mov es, ax
		mov bx, kernel

		mov al, KERNEL_SIZE
		mov cl, STAGE2_START + STAGE2_SIZE
		mov dl, [DRIVE]
		call read_disk


		; Enable A20 line
		call enable_A20


		; Check, setup and enable long mode
		call check_long_mode
		call setup_paging
		call enable_long_mode


		; Load gdt to be in Long mode proper and jump to kernel
		lgdt [GDT_descriptor]
		jmp GDT.code_seg:kernel

		hlt
		jmp $


	bootloader_stage2_finish :
		times 512 * STAGE2_SIZE - ($ - bootloader_stage2) db 0


[bits 64]
kernel :

	cli
    mov edi, 0xB8000              ; Set the destination index to 0xB8000.
    mov rax, 0x1F201F201F201F20   ; Set the A-register to 0x1F201F201F201F20.
	mov [edi], rax

    hlt
	jmp $



times 512 * KERNEL_SIZE - ($ - kernel) db 0