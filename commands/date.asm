; Display or set Date

Date

	  	ld de, h'1800		; Set Y=24 , X=0 Change these two lines when finished to just read cursor_y
		ld (cursor_y),de
		ld hl, M_DATE
		call os_print_string
		ld e, h'07
		call READ_NVRAM_LOC
		ld a, (nv_buf)
		call BCD_DISP
		ld a, '-'
		call os_plotchar
		ld e, h'08
		call READ_NVRAM_LOC
		ld a, (nv_buf)
		call BCD_DISP
		ld a, '-'
		call os_plotchar
		ld a, '2'
		call os_plotchar
		ld a, '0'
		call os_plotchar
		ld e, h'09
		call READ_NVRAM_LOC
		ld a, (nv_buf)
		call BCD_DISP
		ret

;---------------------------------------------------------------------------------