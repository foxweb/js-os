; Input DE points to command buffer start
; HL points to command table
; Output DE points to space after last character of command
; HL points to command jump vector

parse
      ld hl, table


eat_space
      ld a, (de)
      cp h'20         ; check for space
      jp nz, parse_start
      inc de
      jp eat_space

parse_start   
      cp h'20         ; space means end of command
      jp z, end_of_command
      cp h'0d         ; Enter means end of command
      jp z, end_of_command
      cp (hl)         ; Compare a with first character in command table
      jp nz, next_command   ; Move HL to point to the first character of the next command in the table
      inc de
      inc hl
      jp parse_start

next_command
      push af
      ld a, 0
      cp (hl)         	    ; Is it the end off command * ?
      jp z, forward         ; Yes inc HL 3 times to set to begining of next command in the table
      ld a, '@'		    ; Table end reached ?
      cp (hl)
      jp no_match
      pop af
      inc hl
      jp next_command

forward
      inc hl
      inc hl
      inc hl
      jp parse_start

end_of_command
      inc hl         ; increase to *
      inc hl         ; Increase to point to jump vector for command
      jp (hl)

no_match
	; Routine to print "Unkown command error"
	ret


; Command table below with all jump vectors.

table
      defb 'cls'		; Command
      defb 0			; 1 byte - Zero byte to mark end of command
      defw jumpvector1		; 2 bytes
          
      defb 'videomode'		; Command
      defb 0			; 1 byte - Zero byte to mark end of command
      defw jumpvector2		; 2 bytes

	defb '@'			; Signifies table end reached

