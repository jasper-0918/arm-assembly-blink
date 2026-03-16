# ARM Assembly: Bare-Metal LED Blinker

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: STM32F446RE](https://img.shields.io/badge/Platform-STM32F446RE-blue)](https://www.st.com/en/microcontrollers-microprocessors/stm32f446re.html)

## 📋 Overview

This project demonstrates **bare-metal programming** on an ARM Cortex-M4 microcontroller (STM32F446RE) using **pure assembly language**. It blinks the onboard LED (PA5) by directly manipulating CPU registers—no hardware abstraction layers, no vendor libraries, just the raw hardware.

![LED Blinking Demo](docs/demo.gif)

## 🎯 Learning Objectives

This project was created to:
- Understand ARM Cortex-M architecture at the register level
- Master memory-mapped I/O and bit manipulation in assembly
- Learn the complete build process (assembler → linker → flasher)
- Develop bare-metal firmware without any frameworks

## 🛠️ Hardware Required

- STM32 Nucleo-F446RE development board (or any STM32F4 with LED on PA5)
- USB Mini-B cable (included with Nucleo boards)
- Optional: Logic analyzer for debugging

## 🔧 Software Toolchain

| Tool | Purpose |
|------|---------|
| `arm-none-eabi-gcc` | Assembler and linker |
| GNU Make | Build automation |
| ST-Link tools | Flashing the board |
| Git | Version control |

## 📁 Project Structure
arm-assembly-blink/

├── blink.s # Main assembly source (fully commented)

├── STM32F446RE.ld # Linker script defining memory layout

├── Makefile # Build automation

└── docs/ # Additional documentation


## 🔍 How It Works

### Memory-Mapped Registers

The STM32F446RE's peripherals are controlled via memory-mapped registers. Key registers used:

| Register | Address | Purpose | Configuration |
|----------|---------|---------|---------------|
| `RCC_AHB1ENR` | 0x40023830 | Enable GPIOA clock | Bit 0 = 1 |
| `GPIOA_MODER` | 0x40020000 | Set PA5 as output | Bits 10-11 = 01 |
| `GPIOA_ODR` | 0x40020014 | Control output state | Bit 5 toggles LED |

### Assembly Highlights

```assembly
@ Enable GPIOA clock
ldr     r0, =RCC_BASE
ldr     r1, [r0, #RCC_AHB1ENR]
orr     r1, r1, #1
str     r1, [r0, #RCC_AHB1ENR]

@ Set PA5 as output (MODER bits 10-11 = 01)
ldr     r0, =GPIOA_BASE
ldr     r1, [r0, #GPIOA_MODER]
bic     r1, r1, #(3 << 10)   @ Clear bits 10-11
orr     r1, r1, #(1 << 10)    @ Set to output mode
str     r1, [r0, #GPIOA_MODER]

🚀 Getting Started
1. Clone the Repository
bash
git clone https://github.com/yourusername/arm-assembly-blink
cd arm-assembly-blink
2. Install Prerequisites
Ubuntu/Debian:

bash
sudo apt update
sudo apt install gcc-arm-none-eabi make stlink-tools
macOS:

bash
brew install gcc-arm-embedded make stlink
Windows:
Download and install:

GNU ARM Embedded Toolchain

GNU Make for Windows

ST-Link USB driver

3. Build and Flash
Connect your Nucleo board via USB, then run:

bash
make clean
make
make flash
If everything is set up correctly, the green LED (LD2) on your Nucleo board will start blinking!

Troubleshooting
Problem	Solution
make: command not found	Install GNU Make (see above)
st-flash: command not found	Install ST-Link tools
Flashing fails	Check USB connection; run st-info --probe
LED doesn't blink	Verify your board uses PA5 for the LED (check user manual)
Wrong LED pin	Some boards use different pins; modify blink.s accordingly
📊 Challenges and Learnings
Challenge 1: Understanding the Memory Map
Initially, I was confused about how peripherals were addressed. After studying the Reference Manual, I realized that all peripherals are mapped to specific memory ranges, and manipulating these addresses directly controls the hardware.

Challenge 2: Bit Manipulation in Assembly
ARM assembly doesn't have high-level bit operations. I had to learn to use AND, ORR, and BIC instructions carefully to modify specific bits without affecting others.

Challenge 3: Linker Scripts
Creating the linker script taught me about memory sections, VMA vs LMA, and how the startup code initializes data. This was crucial for understanding the complete boot process.

🔬 Future Improvements
Add UART output to print "LED On/Off" messages

Implement timer-based delays (SysTick) instead of busy loops

Add external button interrupt to control blinking speed

Port to other STM32 families (F103, L4)

📚 References
STM32F446RE Reference Manual

ARM Cortex-M4 Generic User Guide

Bare Metal Programming Guide

📝 License
This project is open source under the MIT License - see the LICENSE file for details.

👨‍💻 Author
Your Name

GitHub: @yourusername

LinkedIn: Your LinkedIn Profile

Email: your.email@example.com

If you found this project helpful, please give it a ⭐!
