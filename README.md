# AVR-Hello-World-Assembly

This is my first code written in assembly for an Atmega328p(AVR architecture). It prints "Hello World!" on a 16 x 2 LCD. This repository marks my first experience in assembly programming. For future experiences I'm currently switching to STM32 microcontroller while studying FPGA as a 1B student at University of Waterloo as of May 2025.

**Attached in this repository is the [Source Code](./Hello_World.asm) and [Logic Analyzer File](./Asm.sr).**

Here is a screenshot of the logic analyzer's output:

![Screenshot 2025-05-11 171935](https://github.com/user-attachments/assets/61c106e3-ac88-44bc-91a5-a6ca4f1883a1)

For the circuit, this is the schematic:

![Screenshot 2025-05-11 103403](https://github.com/user-attachments/assets/7a56162d-0ba0-4b13-bae2-6a952c9926b5)

The demo image of my LCD:

![Demo Image (2)](https://github.com/user-attachments/assets/2f676a08-1a84-42ea-85d0-a4fda34dc970)

Message to future engineers:

**Low level programming is a must for deeply understanding computer architecture, especially for chip design and control system design.**

**It may be intimidating at first but trust me, it will come handy in your Engineering career.**

**To start this journey, I suggest practicing with Port Registers First and slowly easing into assembly where you can practice writing code for  
Interrupt Service Routine(ISR), manipulating Stack, and performing simple I/O operations using Registers.**

