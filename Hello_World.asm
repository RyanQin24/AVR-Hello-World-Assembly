.include "m328pdef.inc"

;________________________________________________________________________________
; Assembly code to print "Hello World!" on a 16 x 2 LCD with blinking cursor

; Timer toggles led indicating arduino never crashes while acting like delay
; to ensure LCD has time to enecute instrucions and data

;________________________________________________________________________________

;Start of Program (PC = 0)
.org 0x00 
    ;Relative Jump to label Reset(PC is at Reset)
    rjmp RESET 

;Timer 1 Compare A register match interrupt vector address
.org OC1Aaddr                 
    ;Realtive Jump to interrupt service routine(isr) label (PC at TIMER0_COMPA_vect)
    rjmp TIMER0_COMPA_vect    

RESET:
    ; Set PB5(LED Port) and PB4(LCD falling edge triggered Clock) as output
    sbi DDRB, 5
	sbi DDRB, 4
	sbi PORTB, 4
	; Set DDRD HIGH for PORTD register setting Port Registers D as outputs
	ldi r16, 0xFF
	out DDRD, r16

    ; Load XOR mask into a register
    ldi r21, (1<<5) ; 0b00100000, mask for PB5

    ; Set OCR0A = 781 (for ~50ms delay at 16MHz clock, 1024 prescaler) (High and Low Bit register since number in binary is > 8 bit)
    ldi r16, 0b00000011
    sts OCR1AH, r16
	ldi r16, 0b00001101
	sts OCR1AL, r16

    ; Set Timer1 TCCR1A register to all 0 (nothing to set '1' in this register)
    ldi r16, 0x0
    sts TCCR1A, r16

    ; Set prescaler to 1024 and timer to CTC mode in register TCCR1B
    ldi r16, 0b00001101
    sts TCCR1B, r16

    ; Enable Timer0 Compare Match A interrupt in TIMSK1
    ldi r16, 0x2
    sts TIMSK1, r16

	;r16 bit 0 will be used for the timer flag & bit 7 for stack empty flag
	ldi r16, 0x0

	;Initializing Start of Stack Pointer to be at Highest Address in SRAM
	ldi r17, low(RAMEND)
	out SPL, r17
	ldi r17, high(RAMEND)
	out SPL, r17

    ;pushing binary data to stack (Regster Select is at bit 4 and bits 0-3 are for 4 bit data/instruction to LCD module)

	;Termination data (MSB = 1)
	ldi r17, 0xFF
	push r17

	;letter !
	ldi r17, 0b10001
	push r17

	ldi r17, 0b10010
	push r17

	;letter d
	ldi r17, 0b10100
	push r17

	ldi r17, 0b10110
	push r17

	;letter l
	ldi r17, 0b11100
	push r17

	ldi r17, 0b10110
	push r17

	;letter r
	ldi r17, 0b10010
	push r17

	ldi r17, 0b10111
	push r17

	;letter o
	ldi r17, 0b11111
	push r17

	ldi r17, 0b10110
	push r17

	;letter W
	ldi r17, 0b10111
	push r17

	ldi r17, 0b10101
	push r17

	;space (cursor shift right)
	ldi r17, 0x4
	push r17

	ldi r17, 0x1
	push r17

	;letter o
	ldi r17, 0b11111
	push r17

	ldi r17, 0b10110
	push r17

	;letter l
	ldi r17, 0b11100
	push r17

	ldi r17, 0b10110
	push r17

	;letter l
	ldi r17, 0b11100
	push r17

	ldi r17, 0b10110
	push r17

	;Letter e
	ldi r17, 0b10101
	push r17

	ldi r17, 0b10110
	push r17

	;Letter H
	ldi r17, 0b11000
	push r17
	
	ldi r17, 0b10100
	push r17

	;cursor/display Enable
	ldi r17, 0xF
	push r17

	ldi r17, 0x0
	push r17

	;Returns cursor to home position
	ldi r17, 0x2
	push r17

	ldi r17, 0x0
	push r17

	;Clear LCD
	ldi r17, 0x1
	push r17

	ldi r17, 0x0
	push r17

	;4 Bit mode
	ldi r17, 0x2
	push r17

	;CLear register r17
	ldi r17, 0x0

    ; Enable global interrupts
    sei

Main_Loop:
	;Skips the Write_LCD rjmp instruction if bit 0 in r16 is 0 (Timer Flag not set to '1')
	sbrc r16, 0
	rjmp Write_LCD
    rjmp Main_Loop

;Instructions to pop data from stack and write it to lcd with a clock tick
Write_LCD:
	;reset Timer flag to 0 
	ldi r16, 0x0

	;checks if all data is written from stack to lcd (if data is all written with r17 MSB being '1', simply relaive jump to label Main_Loop)
	sbrc r17,7
	rjmp Main_Loop
	pop r17 
	;Checks if the current poppped data is Termination (if MSB == 1, simple relative jump to label Main_Loop). 
	sbrc r17, 7
	rjmp Main_Loop
	;Bit shifts before outputting to PORTD since lcd is connected (with D4-D7 from PD2 - PD5 respectively with PD6 at Register Select)
	LSL r17
	LSL r17
	out PORTD, r17
	;toggle clock PB4 to send data to LCD before relatively jumping to label Main_Loop(nop ensure stability with small 1 clock tick delay)
	nop
	cbi PORTB, 4
	nop
	sbi PORTB, 4
	rjmp Main_Loop

TIMER0_COMPA_vect:

	;toggling PORTB pin PB5 using XOR Logic
    in r20, PORTB
    eor r20, r21           
    out PORTB, r20    
	 
	;set timer flag to 1
	ldi r16, 0b1  
    
	;return from interrupt to previous Program Counter address (before ISR event)
	reti                      
