;;;
;;; Setting up screen in 16-bit mode
;;;


;;; 
;;; Set screen mode
;;; 
;;; Example :
;;; 	mov al, [mode]
;;; 	call screen_mode
;;; 
;;;     mode : db 0x03
;;; 
screen_mode :
    
    pusha
    
    ; Set up screen background
	mov ah, 0x00
	int 0x10

    popa
    ret

;;; 
;;; Set screen background
;;; 
;;; Example :
;;; 	mov bl, [color]
;;; 	call screen_background
;;; 
;;;     color : db 0x09
;;; 
screen_background :
    
    pusha
    
    ; Set up screen background
	mov ah, 0x0b
	mov bh, 0x00
	int 0x10

    popa
    ret