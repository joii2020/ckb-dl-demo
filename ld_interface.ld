SECTIONS {
    .text : ALIGN(0x1000) {
        *(.text)
        *(.text.*)
    }
    .dynsym : ALIGN(0x1000) {
        KEEP(*(.dynsym))
    }
    .data : {
        *(.data)
        *(.data.*)
    }
    .rela : {
        *(.rela)
        *(.rela.*)
    }
    .rodata : {
        *(.rodata)
        *(.rodata.*)
    }
}
