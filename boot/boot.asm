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
		%include "bootsector/print.asm"
		%include "bootsector/screen.asm"
		%include "bootsector/disk.asm"

	bootsector_data :
		DRIVE : db 0
		bootsector_welcome_message :
			db "Welcome to Quints OS", 0x0a, 0xd
			db "    Entered bootsector", 0x0a, 0x0d, 0
		
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
		mov si, bootsector_welcome_message
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
		%include "stage2/a20.asm"
		%include "stage2/long_mode.asm"
		%include "stage2/paging.asm"
		%include "stage2/gdt.asm"
	bootloader_stage2_data :
		stage2_welcome_mess :
			db "    Entered stage 2 bootloader", 0x0a, 0x0d, 0
		stage2_load_kernel_mess :
			db "        Kernel loaded", 0x0a, 0x0d, 0
		stage2_a20_mess :
			db "        A20 line enabled", 0x0a, 0x0d, 0
		stage2_check_long_mode_mess :
			db "        Long mode is available", 0x0a, 0x0d, 0
		stage2_paging_setup_mess :
			db "        Paging setup", 0x0a, 0x0d,
			db "        Going to enable Long Mode", 0x0a, 0x0d, 0
	bootloader_stage2_code :

		; Print message
		mov si, stage2_welcome_mess
		call print


		; Load kernel
		xor ax, ax
		mov es, ax
		mov bx, kernel

		mov al, KERNEL_SIZE
		mov cl, STAGE2_START + STAGE2_SIZE
		mov dl, [DRIVE]
		call read_disk
        mov si, stage2_load_kernel_mess
        call print

		; Enable A20 line
		call enable_A20
        mov si, stage2_a20_mess
        call print


		; Check long mode
		call check_long_mode
        mov si, stage2_check_long_mode_mess
        call print

		; Setup paging
		call setup_paging
        mov si, stage2_paging_setup_mess
        call print

		; Enable long mode
		call enable_long_mode


		; Load gdt to be in Long mode proper and jump to kernel
		lgdt [GDT_descriptor]
		jmp GDT.code_seg:kernel

		hlt
		jmp $




	bootloader_stage2_finish :
		times 512 * STAGE2_SIZE - ($ - bootloader_stage2) db 0


kernel :