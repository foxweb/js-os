;============================================================================
; time - Display or set the time
;============================================================================


time

		ld de, (cursor_y)
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
