;============================================================================
; time - Display or set the time
;============================================================================


time

	  	ld (XYPOS), de
		pmsg M_TIME, h'0500, h'8F
		ld e, h'04
		call READ_NVRAM_LOC
		ld a, (nv_buf)
		call BCD_DISP
		ld a, ':'
		call PUTCHAR
		ld e, h'02
		call READ_NVRAM_LOC
		ld a, (nv_buf)
		call BCD_DISP
		ld a, ':'
		call PUTCHAR
		ld e, h'00
		call READ_NVRAM_LOC
		ld a, (nv_buf)
		call BCD_DISP
		ret

;---------------------------------------------------------------------------------