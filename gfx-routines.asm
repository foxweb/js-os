 
;============================================================================
; CORE VIDEO ROUTINES
;============================================================================


os_print_string

; prints ascii at current cursor position
; set hl to start of 0-termimated ascii string
	
		push bc
		ld bc,(cursor_y)		; c = x, b = y
prtstrlp	ld a,(hl)			
		inc hl	
		or a			
		jr nz,noteos
		ld (cursor_y),bc		; updates cursor position on exit
		pop bc
		ret
	
noteos	cp 13				; is character a CR? (13)
		jr nz,nocr
		ld c,0
		inc b
		jr prtstrlp
nocr		cp 10				; is character a LF? (10)
		jr z,linefeed
		cp 11				; is character a LF+CR? (11)
		jr nz,nolf
		ld b,0
		jr linefeed
	
nolf		call os_plotchar
		inc c				; move right a character - Was inc b
		ld a,c			; Was ld a,b
		ld ix, OS_window_cols
		ld d, (ix+0)
		cp d				; right edge of screen?
		jr nz,prtstrlp
		ld c,0
linefeed	inc b
		ld a,b
		ld iy, OS_window_rows
		ld d, (iy+0)
		cp d				; last line?
		jr nz,prtstrlp
		push hl
		push bc
		call scroll_up
		pop bc
		pop hl
		ld a, (ix+0)		;ld c,OS_window_rows-1
		sub c	
		ld c, a	
		jr prtstrlp
		
		
;---------------------------------------------------------------------------------

os_plotchar		

; Print character in A with colour from var char_colour. cursor_y , cursor_x you DO NOT need more, as 0<=Y<=63 0<=X<=127

		
		push af	
		ld a,(current_pen)
		ld (char_colour),a
		pop af
		
		push hl
		ld hl, (cursor_y)		; l = x, h = y
		set 6, h
		set 7, h			; here you have txpage + Y*256 + X
		ld (hl), a
		ld b, h			; Preserve h register
		set 7, l
		ld a,(char_colour)
        	ld (hl), a			; Set color
		ld a, l
		inc a
		and 127

		; If X > OS_window_cols - 1 then set x=0 and y=y+1

		push bc
		ld bc, (OS_window_cols)
		cp c				; Does X = OS_window_cols if so set X = 0 and increase Y+1
		pop bc
		jp	c,xytest
		ld	l,$0
		ld	h, b			; Restore h register
		inc	h
		ld (cursor_y), hl		; Save cursor values
		pop hl
		ret

xytest	ld h, b
		ld l, a
		ld (cursor_y), hl		; Save cursor values
		pop hl
		ret

;---------------------------------------------------------------------------------

scroll_up

; Scroll text screen up by 1 and blank bottom line

		LD DE,$C000			; Copy lines 1 to 89 to 0 to 88
		LD HL,$C100
		LD BC,$3EFF
		; Then clear bottom line 89
		ld hl,$E400			; HL = start address of block
		ld e,l			; DE = HL + 1
		ld d,h
		inc de
		ld (hl),$00			; initialise first byte of block with data byte (&00)
		ld bc,$7F			; BC = length of block in bytes HL+BC-1 = end address of block
		ldir				; fill memory
		ret

;---------------------------------------------------------------------------------

print_msg_c

; Print message terminated by 0, centered on the screen
; in:
;   HL - addr
;   D - Y coord

        	call msg_len
        	rrca
        	and 127
        	neg
		push af
		push de
		ld a,	(OS_window_cols)		;Divide OS_window_cols by 2
		ld e, a
		ld c, 2
		call divide8
		ld b, a
		pop de
		pop af
        	add a, b				; B should be OS_window_cols / 2 		
        	ld e, a
	  	ld (cursor_y), de
		call os_print_string
		ret

;---------------------------------------------------------------------------------

message_length

; Calculate length of zero terminated message
; in:
;   HL - addr
; out:
;   A - length

msg_len
        	push hl
        	ld e, -1	
MLN1
        	ld a, (hl)
        	inc hl
        	inc e
        	or a
        	jr nz, MLN1
        	pop hl
        	ld a,e
        	ret

;---------------------------------------------------------------------------------

load_font

; Loads 2048 byte font into $C000 ram ( txpage ^ 1 ) page 9 ??

 		ld      b,page3
        	ld      d, txpage ^ 1 ; h'09 ???
        	call	set_ram_pager
        	ld      hl,font8
        	ld      de,$C000
        	ld      bc,$800
        	ldir
		ret

;---------------------------------------------------------------------------------

cls_text

; Clear text screen at $C000 ram page 8

       	ld      b,page3		
        	ld      d,txpage	;was $08
        	call	set_ram_pager
        	ld      hl,$C000
        	ld      de,$C001
        	ld      bc,16383
        	ld      (hl),0
        	ldir
		ret

;---------------------------------------------------------------------------------

set_ram_pager

; Entry B=Port base 10-$0000 11-$4000 12-$8000 13-$C000, D=Page

		LD C,extp		
		out (c),D	; This could be $00-$ff
		ret

;---------------------------------------------------------------------------------
        
os_set_pen

		ld (current_pen),a
		ret

;---------------------------------------------------------------------------------

os_get_pen

		ld a,(current_pen)
		ret
	
;---------------------------------------------------------------------------------

get_colour

; Get colour of character at the current location supllied by cursor_y
; Output A holds the colour

		push hl
		ld hl, (cursor_y)		; h = x, l = y
		set 6, h
		set 7, h			; here you have txpage + Y*256 + X
		set 7, l
        	ld a, (hl)			; Get color
		pop hl
		ret

;---------------------------------------------------------------------------------

os_patch_font

; Copy 8 bytes from HL to the specific character font in ram at txpage ^ 1 
; set A to char number
; HL to source char address


	push af			; Page in font ram at C000
	LD      B,page3
      LD      D, txpage ^ 1
      CALL	set_ram_pager
	pop af

	push hl
	ld e, h'ff			; Set Multiplicand to 255
	ld h, a
	call multiply8
	ld de, h'c000		; set DE to the start of the font ram
	call add16
	ld d, h			; copy HL into DE
	ld e, l
	ld bc, 8			; load 8 into BC
	pop hl
	ldir				; Copy the new font ( 8 bytes ) to its location in the font ram
	
	push af			; Restore txpage ram at C000
	LD      B,page3
      LD      D, txpage 	
      CALL	set_ram_pager
	pop af
	ret

;---------------------------------------------------------------------------------

set_text_mode

; Set text mode

		ld      hl,CONFIG+5	
        	ld      bc,$06af
        	otdr
		ret



CONFIG  DEFB    $C3,txpage,$00,$00,$00,$00	; Setup Text mode 90 x 36     - was $08

;---------------------------------------------------------------------------------

set_video_mode

; Set video mode
; Input H = RRES , L = VM
; Output A = 1 if invalid value is entered
		
		ld a, h
		cp rres_256x192
		jr nz, rres1
		ld d , rres_256x192
		jr vm
rres1		cp rres_320x200
		jr nz, rres2
		ld d , rres_320x200
		jr vm
rres2		cp rres_320x240
		jr nz, rres3
		ld d , rres_320x240
		jr vm
rres3		cp rres_360x288
		jr nz, invalid
		ld d , rres_360x288
		jr vm


invalid	
		ld a, 1
		ret

vm		ld bc, h'00af
		ld a, l
		cp mode_zx
		jr nz, vm1
		ld a, d
		out (c), a
		jr exit
vm1		cp mode_16c
		jr nz, vm2
		ld a, d
		set 0, a
		out (c), a
		jr exit
vm2		cp mode_256c
		jr nz, vm3
		ld a, d
		set 1, a
		out (c), a
		jr exit
vm3		cp mode_text
		jr nz,invalid
		ld a, d
		set 0, a
		set 1, a
		out (c), a
		ld a, h
		cp rres_256x192
		jr nz, text1
		ld a, 64
		ld (OS_window_cols), a
		ld a, 24
		ld (OS_window_rows), a
		jr exit
text1		cp rres_320x200
		jr nz, text2
		ld a, 80
		ld (OS_window_cols), a
		ld a, 25
		ld (OS_window_rows), a
		jr exit
text2		cp rres_320x240
		jr nz, text3
		ld a, 80
		ld (OS_window_cols), a
		ld a, 30
		ld (OS_window_rows), a
		jr exit
text3		ld a, 90
		ld (OS_window_cols), a
		ld a, 36
		ld (OS_window_rows), a

		
exit		inc b
		ld a, txpage
		out (c), a
		inc b
		ld a, 0
		out (c), a
		inc b
		ld a, 0
		out (c), a
		inc b
		ld a, 0
		out (c), a
		inc b
		ld a, 0
		out (c), a
		ret
		
;---------------------------------------------------------------------------------

set_border

; Input var border_colour

		ld a, (border_colour)
		ld bc, h'0faf		; Border port
		out (c), a
		ret

;---------------------------------------------------------------------------------

; Load the 64 colour default palette

LD_64_PAL

        ld hl, pal_64c
        xtr
        xt palsel, pal_sel
        xt fmaddr,  fm_en | (pal_addr >> 12)
        ld de, pal_addr
        ld bc, 128
        ldir
        xtr
        xt fmaddr, 0
        ret

;---------------------------------------------------------------------------------

; Flash the cursor at the current cursor position if cursorstatus = 1

cursor_flash
		ld a, (cursorstatus)
		or a
		ret z
		ld de, (cursor_y)
		call get_character
		ld b, a			; Store character in B
		ld a, '_'
		Call os_plotchar
		call flashtimer
		ld a , b			
		Call os_plotchar
		ret

;---------------------------------------------------------------------------------

get_character

; Get character at the current location supllied by cursor_y
; Output A holds the character

		push hl
		ld hl, (cursor_y)		; h = x, l = y
		set 6, h
		set 7, h			; here you have txpage + Y*256 + X
        	ld a, (hl)			; Get character
		pop hl
		ret

;---------------------------------------------------------------------------------

; Timer for cursor flash - Input from cursorflashtimer values 0 - 255 valid

flashtimer
		
		ld a, (cursorflashtimer)
		ld d, a
del1		ld bc, h'ffff
del2		dec bc
    		ld a, c
    		or b
    		jr nz, del2
		dec d
		ld a, d
		or a
		jr nz, del1
		ret

;---------------------------------------------------------------------------------

