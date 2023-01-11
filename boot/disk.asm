;;;
;;; Setting up disk operations in 16-bit mode
;;;

;;; 
;;; Read from disk
;;; 
;;; Example :
;;;     ; Prepare location
;;;     mov ax, DATA_SEGMENT
;;; 	mov es, ax
;;;     mov bx, DATA_LOCATION
;;;     
;;;     ; Prepare reading info
;;;     mov al, NUM_SECTORS
;;;     mov cl, START_SECTOR
;;;     mov dl, [DRIVE]
;;; 	call read_disk
;;; 
;;; 	DRIVE : db 0x80
;;; 

read_disk :

    pusha
    ; Prepare read disk
    mov ah, 0x02
    mov ch, 0
	mov dh, 0


    push ax
    int 0x13

    ; Check error
    jc read_disk_error

    ; Check if number of sectors transfered is correct
    mov bl, al

    pop ax
    cmp al, bl


    jne read_disk_error

    popa 
    ret


    read_disk_error :
        mov si, DISK_ERROR_MESS
        call print
        hlt

    DISK_ERROR_MESS : db "Error reading disk", 0x0a, 0x0d, 0

