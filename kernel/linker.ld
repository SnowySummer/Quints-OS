ENTRY(main)

SECTIONS
{
    . = 0x8000;
    .text : { *(.text) }
    .data : { *(.data) }
    .bss  : { *(.bss) *(COMMON) }
}