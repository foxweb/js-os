
; -- RST 08-30
        org h'08
        ret

        org h'10
        ret

        org h'18
        ret

        org h'20
        ret

        org h'28
        ret

        org h'30
        ret

; -- IM1 INT
        org h'38
IM1     
        push bc
        push de
        push hl
        push af
IM11
        pop af
        pop hl
        pop de
        pop bc
        ei
        ret
    
    
; -- NMI        
        org h'66
NMI
        retn
