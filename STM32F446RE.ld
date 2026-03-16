/* STM32F446RE Memory Map
   Flash: 512KB starting at 0x08000000
   RAM:   128KB starting at 0x20000000
*/

MEMORY
{
    FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 512K
    RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 128K
}

/* Stack top (RAM end) */
_estack = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS
{
    /* Interrupt vector table - must be at start of flash */
    .isr_vector :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector))
        . = ALIGN(4);
    } > FLASH

    /* Program code */
    .text :
    {
        . = ALIGN(4);
        *(.text)
        *(.text*)
        . = ALIGN(4);
    } > FLASH

    /* Read-only data */
    .rodata :
    {
        . = ALIGN(4);
        *(.rodata)
        *(.rodata*)
        . = ALIGN(4);
    } > FLASH

    /* Initialized data (copied from flash to RAM at startup) */
    _sidata = LOADADDR(.data);
    .data :
    {
        . = ALIGN(4);
        _sdata = .;        /* Start of data in RAM */
        *(.data)
        *(.data*)
        . = ALIGN(4);
        _edata = .;        /* End of data in RAM */
    } > RAM AT > FLASH

    /* Uninitialized data (zero-initialized at startup) */
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;         /* Start of BSS in RAM */
        *(.bss)
        *(.bss*)
        . = ALIGN(4);
        _ebss = .;         /* End of BSS in RAM */
    } > RAM
}