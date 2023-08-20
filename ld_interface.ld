SECTIONS {
    .data : ALIGN(0x1000) {
        *(.data)
        *(.data.*)
    }
    .text : ALIGN(0x1000) {
        *(.text)
        *(.text.*)
    }
    .dynsym : ALIGN(0x1000) {
        KEEP(*(.dynsym))
    }
    .rela : ALIGN(0x1000) {
        *(.rela)
        *(.rela.*)
    }
    .rodata : ALIGN(0x1000) {
        *(.rodata)
        *(.rodata.*)
    }
}
