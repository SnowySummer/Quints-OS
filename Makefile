BOOTLOADER = boot/boot.asm

IMAGE = build/boot.bin


.PHONY = all clean


all : $(IMAGE)
	qemu-system-x86_64 $(IMAGE)
	$(MAKE) clean

$(IMAGE) : $(BOOTLOADER)
	nasm -f bin $(BOOTLOADER) -o $(IMAGE)

clean :
	rm $(IMAGE)
