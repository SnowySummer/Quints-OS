BOOTLOADER = build/boot.bin


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

all : $(BOOTLOADER)
	$(call pretty_print_header,Run OS)
	@qemu-system-x86_64 -hda $(BOOTLOADER)
	@$(MAKE) -s clean

build : $(BOOTLOADER)

$(BOOTLOADER) :
	$(call pretty_print_header,Building bootloader)
	@$(MAKE) -s -C boot/

clean :
	$(call pretty_print_header,Clean-up)
	@$(MAKE) -C boot/ -s clean
