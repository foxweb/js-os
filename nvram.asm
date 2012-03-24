;---------------------------------------------------------------------------------

CALC_CRC
        	ld hl, nv_buf
        	ld de, 0
        	ld b, nv_size - 2
CC0
        	ld a, d
        	add a, (hl)
        	ld d, a
        	ld a, e
        	xor (hl)
        	ld e, a
        	inc hl
        	djnz CC0

        	ld a, e
        	cp (hl)
        	ret nz
        	inc hl
        	ld a, d
        	cp (hl)
        	ret

;---------------------------------------------------------------------------------

READ_NVRAM
        	outf7 shadow, shadow_on

        	ld hl, nv_buf + nv_1st
        	ld a, nv_size
        	ld c, pf7
RNV1
        	ld b, nvaddr
        	out (c), l
        	ld b, nvdata
        	in d, (c)
        	ld (hl), d
        	inc l
        	dec a
        	jr nz, RNV1

        	outf7 shadow, shadow_off
        	ret

;---------------------------------------------------------------------------------

READ_NVRAM_LOC
; Input E = Nvram location
        	outf7 shadow, shadow_on

        	ld hl, nv_buf
        	ld c, pf7
        	ld b, nvaddr
        	out (c), e
        	ld b, nvdata
        	in d, (c)
        	ld (hl), d
		outf7 shadow, shadow_off
        	ret

;---------------------------------------------------------------------------------

LOAD_DEFAULTS
        	ld hl, nv_buf + nv_1st
        	ld d, h
        	ld e, l
        	inc de
        	ld bc, nv_size - 1
        	ld (hl), b
        	ldir

;---------------------------------------------------------------------------------

WRITE_NVRAM
        	call CALC_CRC
        	ld (nvcs), de

        	outf7 shadow, shadow_on

        	ld hl, nv_buf + nv_1st
        	ld a, nv_size
        	ld c, pf7
WNV1
        	ld b, nvaddr
        	out (c), l
        	ld b, nvdata
        	ld d, (hl)
        	out (c), d
        	inc l
        	dec a
        	jr nz, WNV1

        	outf7 shadow, shadow_off
        	ret
