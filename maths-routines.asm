;---------------------------------------------------------------------------------

divide16

;Divide 16-bit values (with 16-bit result)
;In: Divide BC by divider DE
;Out: BC = result, HL = rest
;

		ld hl, 0
		ld a, b
		ld b, 8
Div16_Loop1
		rla
		adc hl, hl
		sbc hl, de
		jr nc, Div16_NoAdd1
		add hl, de
Div16_NoAdd1
		djnz Div16_Loop1
		ld b, a
		ld a, c
		ld c, b
		ld b, 8
Div16_Loop2
		rla
		adc hl, hl
		sbc hl, de
		jr nc, Div16_NoAdd2
		add hl, de
Div16_NoAdd2
		djnz Div16_Loop2
		rla
		cpl
		ld b, a
		ld a, c
		ld c, b
		rla
		cpl
		ld b, a
		ret

;---------------------------------------------------------------------------------

divide8

;Divide 8-bit values
;In: Divide E by divider C
;Out: A = result, B = rest

		xor a
		ld b,8
Div8_Loop:
		rl e
		rla
		sub c
		jr nc,Div8_NoAdd
		add a,c
Div8_NoAdd:
		djnz Div8_Loop
		ld b,a
		ld a,e
		rla
		cpl
		ret

;---------------------------------------------------------------------------------

add8

; ADD ROUTINE 8+8BIT=16BIT
; HL = HL + DE
; CHANGES FLAGS
		
		ld l, 0			; Set the MSB to 0
		ld e, 0			; Set the MSB to 0
		call add16
    
; RESULT IS IN HL
        	ret				; RETURN FROM SUBROUTINE

;---------------------------------------------------------------------------------

add16

; ADD ROUTINE 16+16BIT=16BIT
; HL = HL + DE
; CHANGES FLAGS

        	add hl, de		; 16-BIT ADD OF HL AND DE
    
; RESULT IS IN HL
        	ret				; RETURN FROM SUBROUTINE

;---------------------------------------------------------------------------------

multiply8

; Multiplication 8-bit * 8-bit Unsigned
; Input: H = Multiplier, E = Multiplicand
; Output: HL = Product

		ld d, 0
		ld l, 0
		sla	h		; optimised 1st iteration
		jr	nc,$+3
		ld	l,e

		add	hl,hl		; unroll 7 times
		jr	nc,$+3		; ...
		add	hl,de		; ...
		ret

;---------------------------------------------------------------------------------

multiply16				

; The following routine multiplies bc by de and places the result in de.

		PUSH	AF
		ld	hl,0
		sla	e		; Optimised 1st iteration
		rl	d
		jr	nc,$+4
		ld	h,b
		ld	l,c
		ld	a,15
loop
		add	hl,hl
		rl	e
		rl	d
		jr	nc,$+6
		add	hl,bc
		jr	nc,$+3
		inc	de
   		dec	a
		jr	nz,loop	
		EX	DE,HL			; DE is used to accumulate the result
		POP	AF
		RET

;---------------------------------------------------------------------------------

DispA

;8 bit number in a to decimal ASCII
;adapted from 16 bit found in z80 Bits to 8 bit by Galandros
;Example: display a=56 as "056"
;input: a = number
;Output: a=0,value of a in the screen
;destroys af,bc (don't know about hl and de)

		ld	c,-100
		call	Na1
		ld	c,-10
		call	Na1
		ld	c,-1
Na1		ld	b,'0'-1
Na2		inc	b
		add	a,c
		jr	c,Na2
		sub	c		;works as add 100/10/1
		push af		;safer than ld c,a
		ld	a,b		;char is in b
		CALL	os_plotchar	;plot a char.
		pop af		;safer than ld a,c
		ret

;---------------------------------------------------------------------------------

DispHL

;16 bit number in hl to decimal ASCII
;Thanks to z80 Bits
;inputs:	hl = number to ASCII
;example: hl=300 outputs '00300'
;destroys: af, bc, hl, de used

		ld	bc,-10000
		call	Num1
		ld	bc,-1000
		call	Num1
		ld	bc,-100
		call	Num1
		ld	c,-10
		call	Num1
		ld	c,-1
Num1		ld	a,'0'-1
Num2		inc	a
		add	hl,bc
		jr	c,Num2
		sbc	hl,bc
		call os_plotchar
		ret

;---------------------------------------------------------------------------------

;Display a 16- or 8-bit number in hex.

DispHLhex

; Input: HL

   	ld  c,h
   	call  DispChex
   	ld  c,l

DispChex

; Input: C

   	ld  a,c
   	rra
   	rra
   	rra
   	rra
   	call  Conv
   	ld  a,c
Conv
   	and  h'0F
   	add  a,h'90
   	daa
   	adc  a,h'40
   	daa
   	call os_plotchar  ;replace by bcall(_PutC) or similar
   	ret

;---------------------------------------------------------------------------------

BCD_DISP

; Display BCD value in decimal from register A
; return with same value in A

	PUSH	AF			
	PUSH	AF
	RRA
	RRA
	RRA
	RRA
	AND	h'0F
	ADD	A,h'30			;Write High byte 
	CALL	os_plotchar
;	
	POP	AF
	AND	h'0F
	ADD	A,h'30
	CALL	os_plotchar
	POP	AF
	RET

;---------------------------------------------------------------------------------
;Input: L = binary number < 100
;Output A = BCD number

BinaryToBCD

	ld h, l
	ld de, H'F606

BinaryToBCDLoop

	add hl, de
	jr c, BinaryToBCDLoop
	ld a, l
	sub e
	ret

;---------------------------------------------------------------------------------

rnd8

; Fast RND
;
; An 8-bit pseudo-random number generator,
; using a similar method to the Spectrum ROM,
; - without the overhead of the Spectrum ROM.
;
; R = random number seed
; an integer in the range [1, 256]
;
; R -> (33*R) mod 257
;
; S = R - 1
; an 8-bit unsigned integer

 ld a, (rnd_seed)
 ld b, a 

 rrca				; multiply by 32
 rrca
 rrca
 xor 0x1f

 add a, b
 sbc a, 255			; carry

 ld (rnd_num), a
 ret

;---------------------------------------------------------------------------------
