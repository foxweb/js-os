;load first supplied string into hl
;load 2nd supplied string into bc[were gonna use the sub2byte thingy to cp them]
;loop trough looking for a null and save length to  var(one var for each str)
;if the vars are equal. check the strings themsleves, else return 0 to ;supplied true/false var
;cp each char in the first string to teh second, simply waiting for NZ to be
;retruned
;return Z if strings are equal, NZ if they are differnt
; Output A=1 if strings are not equal or A=0 if equal

__cpstr__:
	push	hl	;were gonna need to preserve the pointers
	push	bc
	ld	de,__length_str1__
__find_str1_length__:
	ld	a,(bc)
	or	a
	jr	z,__find_str2_length__
	inc	(de)
	inc	bc
	jr	__find_str1_length__
__find_str2_length__:
	ld	de,__length_str2__
__find_str2_length_loop__:
	ld	a,(hl)
	or	a
	jr	z,__compare_lengths__
	inc	(de)
	inc	hl
	jr	__find_str2_length_loop__
__compare_lengths__:
	ld	a,(__length_str1__)
	cp	(__length_str2__)
	jr	z,__lengths_equal__
	pop	bc
	pop	hl
	ld	a,1	;if the lengths are different the strings are different, return NZ
	ret
__lengths_equal__:		;Now let's actually check the contents of the strings!
	dec	de
	pop	bc	;restore the pointers original values
	pop	hl
__cpstr_loop__:
	call	cp_hlbc
	or	a	;check if acc=0
	jr	nz,__strings_not_equal__
	dec	de
	jr	nz,__cpstr_loop__
	jr	__strings_are_equal__
__cp_hlbc__:
	and	a	;reset carry flag
	push	hl
	sbc	hl,bc
	pop	hl
	jr	nz,__strings_not_equal__
	jr	__strings_are_equal__
__strings_not_equal__:
	ld	a,1
	ret
__strings_are_equal__:
	xor	a
	ret
__length_str1__:
	.db	0
__length_str2__:
	.db	0
end
