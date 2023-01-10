;;;
;;; Setting up screen in 16-bit mode
;;;


;;; 
;;; Set screen background
;;; 
;;; Example :
;;; 	mov bl, color
;;; 	call screen background
;;; 
screen_background :
    
    pusha
    
    ; Set up screen background
	mov ah, 0x0b
	mov bh, 0x00
	int 0x10

    popa
    ret