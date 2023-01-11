BOOTLOADER = boot.asm

BIN = boot.bin

.PHONY = all clean

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


all : $(BIN)
	@$(MAKE) -s $(BIN)
	@mv $(BIN) ../build

$(BIN) : $(IMAGE)
	$(call pretty_print_body,BOOT,$(YELLOW),$(BOOTLOADER) -> $(BIN))
	@nasm -f bin $(BOOTLOADER) -o $(BIN)

clean :
	$(call pretty_print_body,CLEAN,$(RED),./build/$(BIN))
	@rm -f ./build/$(BIN)
