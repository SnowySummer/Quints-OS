BOOTLOADER = build/boot.bin
KERNEL = build/kernel.bin
PADDING = build/padding.bin
OS = build/os_image


.PHONY = all clean build


GREY   = \e[1;30m
RED    = \e[1;31m
GREEN  = \e[1;32m
YELLOW = \e[1;33m
BLUE   = \e[1;34m
CYAN   = \e[1;36m
WHITE  = \e[0;37m

# Pretty print
define pretty_print_header
    @printf "$(BLUE)$1"
    @printf "$(WHITE)\n"
endef
define pretty_print_body
    @printf "$(WHITE)[$(GREY)$1$(WHITE)]\t"
    @printf "$2"
    @printf "$3"
    @printf "$(WHITE)\n"
endef

all : $(OS)
	$(call pretty_print_header,Run OS)
	@qemu-system-x86_64 -hda $(OS)
	@$(MAKE) -s clean

build :
	@$(MAKE)

$(OS) : $(BOOTLOADER) $(KERNEL) $(PADDING)
	$(call pretty_print_header,Linking)
	@$(call pretty_print_body,OS,$(GREEN),Linking to $(OS))
	@cat $(BOOTLOADER) $(KERNEL) $(PADDING) > $(OS)

$(BOOTLOADER) :
	$(call pretty_print_header,Building bootloader)
	@$(MAKE) -s -C boot/

$(KERNEL) :
	$(call pretty_print_header,Building kernel)
	@$(MAKE) -s -C kernel/

$(PADDING) :
	$(call pretty_print_header,Building padding)
	$(call pretty_print_body,PADD,$(YELLOW),/dev/zero -> $(PADDING))
	@dd if=/dev/zero of=$@ bs=512 count=20 status=none

clean :
	$(call pretty_print_header,Clean-up)

	$(call pretty_print_body,CLEAN,$(RED),$(OS))
	@rm -f $(OS)
	
	@$(MAKE) -C boot/ -s clean
	
	@$(MAKE) -C kernel/ -s clean
	
	$(call pretty_print_body,CLEAN,$(RED),$(PADDING))
	@rm -f $(PADDING)
