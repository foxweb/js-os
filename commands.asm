;============================================================================
; Internal command routines
;============================================================================


test

     		ld de, h'1800		; Set Y=24 , X=0
		ld (cursor_y), de
		ld hl, M_test
		call os_print_string
		ret

;---------------------------------------------------------------------------------

time
		ld de, h'1800		; Set Y=24 , X=0 Change these two lines when finished to just read cursor_y
		ld (cursor_y),de
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
		ret

;---------------------------------------------------------------------------------