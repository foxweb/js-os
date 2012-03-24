Vmod    EQU h'00AF; video mode
Vpag    EQU h'01AF; video page

PW0     EQU h'10AF; window at #0000
PW1     EQU h'11AF; window at #4000
PW2     EQU h'12AF; window at #8000
PW4     EQU h'13AF; window at #C000

        rseg CODE
		
		ORG 0; #6000
;---------------------------------------
		LD BC, Vmod
		LD A, %00000011; txt mode 80x25
		OUT (C), A
		
		LD BC, Vpag
		LD A, h'F8; set video page: 0
		OUT (C), A

		LD BC, PW4
		LD A, h'F9; place page 1 to #C000
		OUT (C), A

;copying font to page 1:
		LD HL, font8
		LD DE, h'C000
		LD BC, 2048
		LDIR
		
		LD BC, PW4
		LD A, h'F8; place page 0 to #C000
		OUT (C), A
;---------------------------------------
;OPENING PS/2 PORTS:
        LD BC, h'EFF7
		LD A, %10000000
		OUT (C), A

;ACTIVATING ACCESS to PS/2:
        LD BC, h'DFF7
		LD A, h'F0
		OUT (C), A
		
        LD BC, h'BFF7
		LD A, 2
		OUT (C), A
;---------------------------------------
;INITIALIZING INTERRUPTS:
		DI
		LD HL, I_N_T
		LD (h'5BFF), HL
        LD A, h'5B
		LD I, A
        IM 2
;---------------------------------------
;clearing screen:
		LD A, %00000111; paper(black) + ink(white)
		LD HL, h'C000
		LD DE, h'C000+1
		
		LD B, 25; 25 lines to clear
SCREEN	PUSH BC
		LD (HL), ' '
		LD BC, 128
		LDIR; fill line (symbols)
		
		LD (HL), A; A - color
		LD BC, 128
		LDIR; fill line (attributes)
		POP BC
		DJNZ SCREEN
;---------------------------------------
;initialization for inputing string:
		LD HL, h'C000; address on screen (first line)
		LD DE, h'0800;curMAX + curNOW
;curMAX - lenght of editing string
;curNOW - cursor starting position
		LD A, h'FF; #FF - initialization
		CALL ISTR
		
;-------
MAIN	EI
		HALT
		
;if ENTER pressed then exit:
		CALL ENKE
		JR NZ,EXIT

;editing string:
		XOR A; 0 - inputing
		CALL ISTR
		JR MAIN
;-------

EXIT
		RET
;---------------------------------------
;INTERRUPT HANDLER:
I_N_T   PUSH IX
		PUSH AF
        PUSH HL
		PUSH DE
		PUSH BC
		EX AF, AF
		PUSH AF
		
		CALL PSDII
		
		POP AF
		EX AF, AF
		POP BC
		POP DE
		POP HL
		POP AF
		POP IX
		EI
		RET
;---------------------------------------

#include "ps2_handler.asm"
extern    font8
		end