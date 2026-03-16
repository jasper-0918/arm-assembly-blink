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
