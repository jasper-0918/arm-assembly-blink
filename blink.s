@
@ Bare-Metal LED Blinker for STM32F446RE (Nucleo Board)
@ LED connected to PA5 (Port A, Pin 5)
@
@ This program directly manipulates registers without any libraries
@

@ Memory-mapped register addresses (from Reference Manual)
.equ RCC_BASE,      0x40023800      @ RCC peripheral base address
.equ RCC_AHB1ENR,   0x30            @ Offset for AHB1 peripheral clock enable register
.equ GPIOA_BASE,    0x40020000      @ GPIOA peripheral base address
.equ GPIOA_MODER,   0x00            @ Offset for GPIO port mode register
.equ GPIOA_OTYPER,  0x04            @ Offset for GPIO output type register
.equ GPIOA_OSPEEDR, 0x08            @ Offset for GPIO output speed register
.equ GPIOA_PUPDR,   0x0C            @ Offset for GPIO pull-up/pull-down register
.equ GPIOA_ODR,     0x14            @ Offset for GPIO output data register

@ Bit position for PA5 (Pin 5)
.equ PIN5,          5

@ Constants for delays
.equ DELAY_COUNT,   0x100000        @ Adjust this value to change blink speed

.section .text                      @ Code section
.global _start                      @ Entry point for the linker

_start:
    @ Enable clock for GPIOA
    @ RCC_AHB1ENR register bit 0 controls GPIOA clock
    ldr     r0, =RCC_BASE
    ldr     r1, [r0, #RCC_AHB1ENR]  @ Read current value
    orr     r1, r1, #1              @ Set bit 0 to 1 (enable GPIOA clock)
    str     r1, [r0, #RCC_AHB1ENR]  @ Write back

    @ Configure PA5 as output
    @ MODER register: each pin uses 2 bits, PA5 uses bits 10-11
    ldr     r0, =GPIOA_BASE
    
    @ Clear bits 10-11 in MODER
    ldr     r1, [r0, #GPIOA_MODER]
    bic     r1, r1, #(3 << (2 * PIN5))  @ Clear both bits (3 = binary 11)
    
    @ Set bits 10-11 to 01 (output mode)
    orr     r1, r1, #(1 << (2 * PIN5))  @ Set lower bit, keep upper bit cleared
    str     r1, [r0, #GPIOA_MODER]

    @ Set output type to push-pull (OTYPER bit 5 = 0)
    ldr     r1, [r0, #GPIOA_OTYPER]
    bic     r1, r1, #(1 << PIN5)        @ Clear bit 5 (push-pull)
    str     r1, [r0, #GPIOA_OTYPER]

    @ Set output speed to low (OSPEEDR bits 10-11 = 00)
    ldr     r1, [r0, #GPIOA_OSPEEDR]
    bic     r1, r1, #(3 << (2 * PIN5))  @ Clear both bits (low speed)
    str     r1, [r0, #GPIOA_OSPEEDR]

    @ Disable pull-up/pull-down (PUPDR bits 10-11 = 00)
    ldr     r1, [r0, #GPIOA_PUPDR]
    bic     r1, r1, #(3 << (2 * PIN5))  @ Clear both bits (no pull)
    str     r1, [r0, #GPIOA_PUPDR]

    @ Main loop: blink the LED forever
loop:
    @ Turn LED ON (set PA5 high)
    ldr     r1, [r0, #GPIOA_ODR]
    orr     r1, r1, #(1 << PIN5)        @ Set bit 5
    str     r1, [r0, #GPIOA_ODR]
    
    @ Delay
    ldr     r2, =DELAY_COUNT
delay1:
    subs    r2, r2, #1                   @ Decrement and set flags
    bne     delay1                        @ Loop until zero
    
    @ Turn LED OFF (clear PA5 low)
    ldr     r1, [r0, #GPIOA_ODR]
    bic     r1, r1, #(1 << PIN5)         @ Clear bit 5
    str     r1, [r0, #GPIOA_ODR]
    
    @ Delay
    ldr     r2, =DELAY_COUNT
delay2:
    subs    r2, r2, #1
    bne     delay2
    
    @ Repeat forever
    b       loop

@ Optional: Define the vector table for completeness
.section .isr_vector,"a"
.word    _estack              @ Top of stack (defined in linker script)
.word    _start               @ Reset handler
.word    _start               @ NMI handler (just reset for simplicity)
.word    _start               @ HardFault handler
@ ... other handlers could be added, but we'll keep it minimal