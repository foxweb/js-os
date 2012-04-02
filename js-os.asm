; ------- external modules
extern    font8
#include "conf.asm"
#include "macro.asm"
#include "vars.asm"


; ------- main code
        	rseg CODE

        	di
        	jp START

        	org h'80	; Decimal 128
START
        	ld b,h'11
		ld d, h'5
		call set_ram_pager
        	ld sp, stck
	  	ld a,h'0C			; Set charcol variable to default value
        	ld (current_pen),a
	  	LD DE,h'0000		; Set XYPOS D - Y , E - X to the default of 0,0
	  	LD (cursor_y),DE
        	call load_font
	  	xor a
        	out (254), a
		ld b,h'12
		ld d, h'2
		call set_ram_pager
		call LD_64_PAL		; Load default 64 colour palette
		ld hl, h'c003		; Hopefully set 360x288 text ?
		call set_video_mode
		ld b,h'13
		ld d, txpage
   		call set_ram_pager
	  	call cls_text
		ld a, h'0
		ld (border_colour), a
		call set_border
		
 ; Setup system variables

		ld a, 1
		ld (cursorstatus), a
		ld a, 100
		ld (cursorflashtimer), a
		ld a, h'0f
		ld (current_pen), a

		;----------------------------------------------------------------------
		;PS2 initialization:

	    	LD BC,h'EFF7
        	LD A,h'80
        	OUT (C),A
        	LD BC,h'DFF7
        	LD A,h'F0
        	OUT (C),A
        	LD BC,h'BFF7
        	LD A,h'02
        	OUT (C),A

		;----------------------------------------------------------------------
		;Initialise IM2 interrupts:

	    	LD HL, I_N_T
        	LD (h'5BFF), HL	; Address for IM2 mode routine.
        	DI
        	LD A, h'5B
		LD I, A
        	IM 2

		;----------------------------------------------------------------------

;MAIN CYCLE:
    	  
		
		ld a,h'0C			; Set charcol variable to default value
        	ld (current_pen),a
		ld de, h'0000		; Set Y=0 , X=0
	  	ld (cursor_y), de
		ld hl , M_HEAD1
		call print_msg_c
		ld a, h'0f
		ld (current_pen), a
		ld de, h'0100		; Set Y=1 , X=0
	  	ld (cursor_y), de
		ld hl , M_HEAD2
		call print_msg_c
		
		ld de, h'0500			; Y = 5 , X = 0 setup powerup cursor position
		ld (cursor_y), de
		
		;-------------------------------------------------------
		;initialization for inputing string:

MAIN		call get_address
		;LD HL, h'c000		; address on screen (first line)
		LD DE, h'5901		;curMAX + curNOW

		;curMAX - lenght of editing string
		;curNOW - cursor starting position

		LD A, h'ff			; #FF - initialization
		CALL ISTR
		
		;-------------------------------------------------------
		
MAIN1		ei
		halt
		;if ENTER pressed then parse:
		CALL ENKE
		jr nz, enter

;editing string:
		
		XOR A				; 0 - inputing
		CALL ISTR
		JR MAIN1

enter
		ld de, (cursor_y)
		inc d
   		ld (cursor_y), de
		ld a, 01			; Terminate editing string in HL
		call ISTR
		push hl			; copy HL into DE
		pop de
		call parse
		jr MAIN
		

;----------------------------------------------------------------------
; IM2 Interrupt handler:
I_N_T   	PUSH AF
        	PUSH BC
        	PUSH DE
        	PUSH HL
        	PUSH IX
        	EXX
        	EX AF, AF
        	PUSH AF
        	PUSH BC
        	PUSH DE
        	PUSH HL

        	CALL PSDII	; Get value from PS2 keyboard buffer.

        	POP HL
        	POP DE
        	POP BC
        	POP AF
        	EXX
        	EX AF, AF
        	POP IX
        	POP HL
        	POP DE
        	POP BC
        	POP AF
        	EI
        	RET

;----------------------------------------------------------------------

#include "nvram.asm"
#include "gfx-routines.asm"
#include "maths-routines.asm"
#include "parser.asm"
#include "ps2_handler.asm"
#include "commands/test.asm"
#include "commands/time.asm"
#include "commands/date.asm"
#include "commands/cls.asm"
#include "booter.asm"
#include "arrays.asm"
#include "restarts.asm"



        end

