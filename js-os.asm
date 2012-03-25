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
		
 

		
 CALL INIT	; Initialise PS2 keyboard interface.

;Initialise IM2 interrupts:
INTA    	LD HL, I_N_T
        	LD (h'5BFF), HL	; Address for IM2 mode routine.
        	DI
        	LD A, h'5B
		LD I, A
        	IM 2

		jp MAIN

;-------------------------------
;PS2 initialization:
INIT    	LD BC,h'EFF7
        	LD A,h'80
        	OUT (C),A
        	LD BC,h'DFF7
        	LD A,h'F0
        	OUT (C),A
        	LD BC,h'BFF7
        	LD A,h'02
        	OUT (C),A
        	RET
;-------------------------------
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
		
;MAIN CYCLE:
MAIN    	EI   
		ld de, h'1400		; Set Y=20 , X=45
	  	ld (cursor_y), de
		ld a, '1'
		Call os_plotchar
		ld a, '2'
		Call os_plotchar
		ld de, h'141f		; Set Y=20 , X=31
	  	ld (cursor_y), de
		ld a, '3'
		Call os_plotchar
		ld a, (OS_window_cols)
		sub 1
		ld d, h'14
		ld e, a
		;ld de, h'141f		; Set Y=20 , X=31
	  	ld (cursor_y), de
		ld a, '4'			
		Call os_plotchar

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

		call parse



MAIN1		ld de, h'0A00		; Set Y=10 , X=0
	  	ld (cursor_y), de
		CALL CLAVA	;poll for key press
        	JR Z, nvramloop	;Z - not pressed, NZ - pressed
		Call os_plotchar
nvramloop	

				
		
		ld de, h'0500		; Set Y=5 , X=0
	  	ld (cursor_y), de
		ld hl , M_TIME
		call os_print_string
		ld e, h'04
		call READ_NVRAM_LOC
		ld a, (nv_buf)
		call BCD_DISP
		ld a, ':'
		call os_plotchar
		ld e, h'02
		call READ_NVRAM_LOC
		ld a, (nv_buf)
		call BCD_DISP
		ld a, ':'
		call os_plotchar
		ld e, h'00
		call READ_NVRAM_LOC
		ld a, (nv_buf)
		call BCD_DISP
		jp MAIN1
		

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

