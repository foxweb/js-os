; Input DE points to command buffer start
; HL points to command table
; Output DE points to space after last character of command
; HL points to command jump vector

parse
   
   	ld hl, table
   	ld de, test_command   	;command_buffer
   
      
parse_first

   	call eat_space      	; Skip leading space and get first character from string DE
   	push de         		; Store address of the first character on the stack      
   	cp (hl)         		; Compare the first character with the first character in the table
   	jr z, parse_compare    	; Jump to parse_compare if equal
   	ld a, '@'
   	cp (hl)
   	jr z, parse_error      	; Is it the end of the command table ? Unkown command error.
   	jr parse_next

parse_compare
   
   	inc de         		; Increment DE and HL
   	inc hl
   	ld a, (de)         	; Get the next character
   	cp (hl)         		; Compare character
   	jr z, parse_compare   	; Loop if they match
   	ld a, 0
   	cp (hl)
   	jr z, parse_match
   	ld a, '@'
   	cp (hl)
   	jr z, parse_error      	; Is it the end of the command table ? Unkown command error.

parse_next

   	inc hl         		; Increment HL to find the zero terminator
   	ld a, 0         		; Is it the end of command 0 terminator
   	cp (hl)
   	jr nz, parse_next
   	inc hl         		; Increment HL to point to MSB jump vector
   	inc hl         		; Increment HL to point to LSB jump vect
   	inc hl         		; Increment HL to point to first character of the next command
   	pop de         		; Restore DE
   	jr parse_first      	; Jump to parse_first

parse_match

   	inc hl         		; Increment HL to point to LSB of jump vector
   	ld c, (hl)         	; Load LSB with vector
   	inc hl         		; Increment HL to point to MSB of jump vector
   	ld b, (hl)         	; Load MSB with vector
   	push bc         		; Push BC onto the stack
   	pop hl         		; Load HL with BC
	pop de
     	jp (hl)         		; Jump to command code
   	ret
   
eat_space

      ld a, (de)
      cp h'20       		; check for space
      ret nz
      inc de
      jr eat_space

parse_error

   	pop de
   	ld de, h'1800
   	ld (cursor_y), de
   	ld hl, M_SYNTAX
   	call os_print_string
   	ret

; Command table below with all jump vectors.

table

      defb 'cls'      		; Command
      defb 0         		; 1 byte - Zero byte to mark end of command
      defw cls      		; 2 bytes
          
      defb 'textmode'      	; Command
      defb 0         		; 1 byte - Zero byte to mark end of command
      defw set_text_mode   	; 2 bytes
   
      defb 'test-print'      	; Command
      defb 0         		; 1 byte - Zero byte to mark end of command
      defw test         	; 2 bytes

	defb 'time'      		; Command
      defb 0         		; 1 byte - Zero byte to mark end of command
      defw time         	; 2 bytes

	defb 'date'      		; Command
      defb 0         		; 1 byte - Zero byte to mark end of command
      defw dates         	; 2 bytes

   	defb '@'         		; Signifies table end reached

 