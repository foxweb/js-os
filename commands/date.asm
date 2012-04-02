;============================================================================
; date - Display or set date
;============================================================================


dates
		ld de, (cursor_y)
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
		ld hl, M_NEWLINE
		call os_print_string
		ret

;---------------------------------------------------------------------------------