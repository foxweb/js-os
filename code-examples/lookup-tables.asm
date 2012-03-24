
 ld a,(MenuChoice)
 add a,a ; a*2 limits choices to 128
 ld h,0
 ld l,a
 ld de,CodeBranchLUT
 add hl,de
 ld a,(hl)
 inc hl
 ld h,(hl)
 ld l,a
 jp (hl)

CodeBranchLUT:
 .dw Choice0
 .dw Choice1
 .dw Choice2
 .dw Choice3
 .dw Choice4
 .dw Choice5
 .dw Choice6
 .dw Choice7