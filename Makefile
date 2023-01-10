BOOTLOADER = boot/boot.asm

IMAGE = build/boot.bin


.PHONY = all clean build


all : $(IMAGE)
	qemu-system-x86_64 -hda $(IMAGE)
	$(MAKE) clean

build : $(IMAGE)

$(IMAGE) : $(BOOTLOADER)
	nasm -f bin $(BOOTLOADER) -o $(IMAGE)

clean :
	rm $(IMAGE)
