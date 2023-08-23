
PHDRS {
    headers PT_PHDR PHDRS ;
    base PT_LOAD FILEHDR PHDRS FLAGS(4) ;
    rodata PT_LOAD FLAGS(4) ;
    text PT_LOAD FLAGS(5) ;
    data PT_LOAD FLAGS(6) ;
    dynamic PT_DYNAMIC ;

    relro PT_GNU_RELRO FLAGS(4) ;
    stack PT_GNU_STACK FLAGS(6) ;
}

SECTIONS {
    . = 0x1000;
    .dynsym : {
        KEEP(*(.dynsym))
    } : base
    .gnu.hash : {
        *(.gnu.hash)
    }
    .hash : {
        *(.hash)
    }
    .dynstr : {
        *(.dynstr)
    }
    .rela : {
        *(.rela)
        *(.rela.*)
    }

    .rodata : ALIGN(0x1000) {
        *(.rodata)
        *(.rodata.*)
    } : rodata

    .text : ALIGN(0x1000) {
        *(.text)
        *(.text.*)
    } : text

    .data.rel.ro : ALIGN(0x1000) {
        *(.data.rel.ro)
        *(.data.rel.ro.*)
    } : relro
    .dynamic : ALIGN(0x1000) {
        KEEP(*(.dynamic))
        LONG(0)
    } : data : dynamic

    .data : {
        *(.data)
        *(.data.*)
    } : data
    
    .bss : {
        *(.bss)
        *(.bss.*)
    }

    .stack : {
        *(.stack)
    } : stack

}
