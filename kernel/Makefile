OBJECTS = pre_kernel.o kernel.o

KERNEL = kernel.bin

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


all :
	@$(MAKE) -s $(OBJECTS)
	@$(call pretty_print_body,KERN,$(GREEN),Linking to $(KERNEL))
	ld -m elf_x86_64 -o $(KERNEL) -Tlinker.ld $(OBJECTS) -nostdlib --nmagic --oformat binary

	@mv $(KERNEL) ../build
	@mv $(OBJECTS) obj


%.o : %.c
	@$(call pretty_print_body,KERN,$(YELLOW),$^ -> $@)
	gcc -std=gnu99 -fno-pie -ffreestanding -fno-stack-protector -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -nostdlib -c $^ -o $@

%.o : %.asm
	@$(call pretty_print_body,KERN,$(YELLOW),$^ -> $@)
	nasm $^ -f elf64 -o $@

clean :
	$(call pretty_print_body,CLEAN,$(RED),build/$(KERNEL))
	@rm -f ../build/$(KERNEL)

	$(call pretty_print_body,CLEAN,$(RED),kernel/obj/*)
	@rm -rf obj/*
