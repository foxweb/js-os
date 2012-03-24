; Display or set Date

Date
				


		
	  	ld (XYPOS), de
		pmsg M_DATE, h'0500, h'8F
		ld e, h'07
		call READ_NVRAM_LOC
		ld a, (nv_buf)
		call BCD_DISP
		ld a, '-'
		call PUTCHAR
		ld e, h'08
		call READ_NVRAM_LOC
		ld a, (nv_buf)
		call BCD_DISP
		ld a, '-'
		call PUTCHAR
		ld a, '2'
		call PUTCHAR
		ld a, '0'
		call PUTCHAR
		ld e, h'09
		call READ_NVRAM_LOC
		ld a, (nv_buf)
		call BCD_DISP
		ret
