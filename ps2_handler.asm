RPT     EQU 25;AUTO REPEAT
;-------
BCA     EQU TAB+1
BCS     EQU TAB+2
BSS     EQU TAB+3
BFS     EQU TAB+4

BUP     EQU TAB+5
BLF     EQU TAB+6
BDN     EQU TAB+7
BRG     EQU TAB+8

BHM     EQU TAB+9
BPU     EQU TAB+10
BED     EQU TAB+11
BPD     EQU TAB+12
BAL     EQU TAB+13
;---------------------------------------
        rseg CODE
;---------------------------------------
;PS/2 HANDLER (STAND-ALONE)
;(C) BUDDER/MGN/2012
;---------------------------------------
TAB4E   LD HL,(TAB+h'00)
        LD A,H
        OR L
        LD HL,(TAB+h'02)
        OR H
        OR L
        LD HL,(TAB+h'04)
        OR H
        OR L
        LD HL,(TAB+h'06)
        OR H
        OR L
        LD HL,(TAB+h'08)
        OR H
        OR L
        LD HL,(TAB+h'0A)
        OR H
        OR L
        LD HL,(TAB+h'0C)
        OR H
        OR L
        LD HL,(TAB+h'0E)
        OR H
        OR L
        LD HL,(TAB+h'10)
        OR H
        OR L
        LD HL,(TAB+h'12)
        OR H
        OR L
        RET
;-------
ISTR    ;i:A=#FF Init:
;             i: HL - Address of string
;                 D - CURMAX
;                 E - CURNOW
;          A=#01 Terminate:
;             o: HL - Address of string
;
;          A=#XX Input(CALL every frame)

        INC A
        JR Z,IINIT
        CP 2
        JR Z,IEXIT

        CALL BSPC; Backspace
        CALL NZ,IBS

        CALL RGGG; Right Arrow
        CALL NZ,IRG

        CALL LFFF; Left Arrow
        CALL NZ,ILF

        CALL CLAVA
        RET Z
        CALL ICPO
        LD (HL), A
        CALL IRG
        RET
;-------
IRG     LD BC, (ICUP)
        LD A, C
        INC A
        CP B
        RET NC
        CALL IRCU
        LD (ICUP), A
        JR ICUR
ILF     LD BC, (ICUP)
        LD A, C
        DEC A
        CP B
        RET NC
        CALL IRCU
        LD (ICUP), A
        JR ICUR
;-------
IBS     CALL ILF
        CALL ICPO
        LD (HL), 32
        RET
;-------
IINIT   LD (ISAD), HL
        LD (ICUP), DE

        CALL ICUR
        RET
IEXIT   CALL IRCU
        LD HL, (ISAD)
        RET
;-------
ICUR
IRCU    PUSH AF
        CALL ICPO
        SET 7,L
        LD A, (HL)
        RRD
        POP AF
        RET

ICPO    LD HL, (ISAD)
        LD BC, (ICUP)
        LD B, 0
        ADD HL, BC
        RET
;---------------------------------------
CLAVA   ;i:none
;        o: Z - no chars
;           A - char [a-z/A-Z;0-9]
;               also see TAI1,TAI2 tabls

        LD HL, TAB+13
        LD A, (HL)
        INC HL
        OR A
        JR Z, $-3
        CP h'FF
        RET Z

        CALL ARL
        RET Z
        LD A, (HL)

        LD HL, TAI0
        LD B, 48
AVA     CP (HL)
        JR Z, CLA
        INC HL
        DJNZ AVA
        XOR A
        RET
CLA     LD BC, 48
        ADD HL, BC
        PUSH HL
        CALL SHIFT
        POP HL
        LD BC, 48
        JR Z, $+3
        ADD HL, BC
        LD A, (HL)
        OR A
        RET
;---------------------------------------
NUSP    EI
        HALT
        CALL ANYK
        RET NZ;exit, if any key pressed!
        JR NUSP
USPO    EI
        HALT
        CALL ANYK
        RET Z
        JR USPO
;---------------------------------------
UPPP    LD HL, BUP
        JP ARC;UP
DWWW    LD HL, BDN
        JP ARC;DOWN
LFFF    LD HL, BLF
        JP ARC;LEFT
RGGG    LD HL, BRG
        JP ARC;RIGHT
PGU     LD HL, BPU
        JP ARC;pgUP
PGD     LD HL, BPD
        JP ARC;pgDN

ENKE    LD A, h'5A
        JP ARL; ENTER
SPKE    LD A, h'29
        JP ARL; SPACE
BSPC    LD A, h'66
        JP ARL; BACKSPACE
HOME    LD A, h'6C
        JP ARL
ENDK    LD A, h'69
        JP ARL
DELE    LD A, h'71
        JP ARL
INS     LD A, h'70
        JP ARL; INSERT

ESC     LD A, h'76
        JP AR2
F1      LD A, h'05
        JP AR2
F2      LD A, h'06
        JP AR2
F3      LD A, h'04
        JP AR2
F4      LD A, h'0C
        JP AR2
F5      LD A, h'03
        JP AR2
F6      LD A, h'0B
        JP AR2
F7      LD A, h'83
        JP AR2
F8      LD A, h'0A
        JP AR2
F9      LD A, h'01
        JP AR2
F10     LD A, h'09
        JP AR2

ALT     LD HL, BHM
        JP ARG
SHIFT   LD HL, BCS
        JP ARG
TABK    LD HL, TAB
        JP ARC

ESC2    LD A, h'76
        LD HL, TAB+4
        CP (HL)
        JR NZ, ARL2
        JR AC
;-------
AR2     LD HL, TAB+4
        CP (HL)
        JR Z, ARC
ARL2    XOR A
        RET

ARL     LD HL, TAB+13
        LD BC,7
        CPIR
        JR NZ, ARL2
        DEC HL
;-------
ARC     LD A, (HL)
        OR A
        RET Z
        LD A, (ARK)
        CP (HL)
        JR NZ, A2C

        LD A,(ARR)
        OR A
        JR Z, AC
        CP h'FF
        JR NZ, A2C

        LD A, RPT
        LD (ARR), A
AC      LD A, 1
        OR A
        RET
A2C     XOR A
        RET
;-------
ARG     LD A, (HL)
        OR A
        RET Z
        JR AC
;-------
ANYK    LD HL, TAB
        LD B, 20
        XOR A
        CP (HL)
        JR NZ, NYK
        INC HL
        DJNZ $-4
        RET
NYK     LD A, RPT
        LD (ARR), A
        RET
;---------------------------------------
ALM     LD HL, TAB+13
        LD BC, 7
        CPIR
        RET Z

        LD E, A
        XOR A
        LD HL, TAB+13
        LD BC, 7
        CPIR
        RET NZ
        DEC HL

        LD (HL), E
        LD (IX+24), E
        LD (IX+23), h'FF
        RET
;---------------------------------------
OVER    LD BC, h'DFF7
        LD A, h'0C
        OUT (C), A
        LD BC, h'BFF7
        LD A, h'01
        OUT (C), A
        LD BC, h'DFF7
        LD A, h'F0
        OUT (C), A

AGU     XOR A
GUI     LD (IX+22), A
        XOR A
        LD HL, TAB
        LD B, 20
        LD (HL), A
        INC HL
        DJNZ $-2
        LD A, 1
        OR A
        RET
K9      LD (BHM), A
        RET
;---------------------------------------
;GET SCAN CODE:
PSDII   LD IX, TAB

        LD A, (IX+23)
        OR A
        JR Z, PSD
        CP h'FF
        JR Z, PSD
        DEC (IX+23)

PSD     LD BC, h'DFF7
        LD A, h'F0
        OUT (C), A

        LD BC, h'BFF7
PSD2    IN A, (C)
        OR A
        RET Z
        CP h'E0
        JR Z, PSD2
        CP h'F0
        JP Z, KOF
        CP h'FF
        JR Z, OVER

BAT     JP Z, K2F

        CP h'1F
        JR Z, GUI
        CP h'27
        JR Z, GUI
;-------
        EX AF, AF
        LD A, (IX+22)
        OR A
        RET NZ
        EX AF, AF
;-------
        CP h'11
        JR Z, K9;ALT
        CP h'0D
        JR Z, K0;TAB
        CP h'58
        JR Z, K1;CAPS
        CP h'12
        JR Z, K2;SHIFT
        CP h'59
        JR Z, K2
        CP h'14
        JR Z, K3;CTRL

        CP h'0D
        JR C, K4
        CP h'76
        JR Z, K4;ESC
        CP h'78
        JR Z, K4;F11
        CP h'83
        JR Z, K4;F7

        CP h'75
        JR Z, K5;UP
        CP h'6B
        JR Z, K6;LEFT
        CP h'72
        JR Z, K7;DN
        CP h'74
        JR Z, K8;RIGHT

        CP h'7D
        JR Z, KA;PGup
        CP h'7A
        JR Z, KC;PGdn

        CP h'77
        JR Z, KB;NUML
        JP ALM
;-------
K0      LD HL, TAB+0
        JR KFF
K1      LD HL, TAB+1
        JR KFF
K2      LD HL, TAB+2
        JR KFF
K3      LD HL, TAB+3
        JR KFF
K4      LD HL, TAB+4
        JR KFF
K5      LD HL, TAB+5
        JR KFF
K6      LD HL, TAB+6
        JR KFF
K7      LD HL, TAB+7
        JR KFF
K8      LD HL, TAB+8
        JR KFF
KA      LD HL, TAB+10
        JR KFF
KB      LD HL, TAB+11
        JR KFF
KC      LD HL, TAB+12
;-------
KFF     CP (HL)
        RET Z
        LD (HL), A
        LD (ARK), A
        LD (IX+23), h'FF
        RET
;-------
KOF     IN A, (C);                   BC=#BFF7
        OR A
        JR Z, EBU
K2F     LD C, A
        LD A, h'CA
        LD (BAT), A
        LD A, C

        CP h'1F
        JP Z, AGU
        CP h'27
        JP Z, AGU

        LD HL, TAB
        LD BC, 20
        CPIR
        RET NZ
        DEC HL
        LD (HL), 0
        RET

EBU     LD A, h'C3
        LD (BAT), A
        RET
;-------
TAB     DEFS 1;  +0  TAB
        DEFS 1;  +2  CASP LOCK
        DEFS 1;  +4  SHIFT
        DEFS 1;  +6  CTRL
        DEFS 1;  +8  F1-F12
        DEFS 4;  +5  CURSOR KEYZ
        DEFS 4;  +9  ALT,pgUP,NUML,pgDN
        DEFS 7;  +13 oth KEYZ
        DEFB h'FF
        NOP ;+21 NXF
        NOP ;+22 WIN
ARR     NOP ;+23 AR
ARK     NOP ;+24 LST KEY
;-------
TAI0    DEFB h'0E, h'16, h'1E, h'26, h'25, h'2E, h'36, h'3D, h'3E, h'46, h'45, h'4E, h'55
        DEFB h'15, h'1D, h'24, h'2D, h'2C, h'35, h'3C, h'43, h'44, h'4D, h'54, h'5B, h'5D
        DEFB h'1C, h'1B, h'23, h'2B, h'34, h'33, h'3B, h'42, h'4B, h'4C, h'52
        DEFB h'1A, h'22, h'21, h'2A, h'32, h'31, h'3A, h'41, h'49, h'4A, h'29
;-------
TAI1    DEFB h'7E, '1234567890-='
        DEFB 'qwertyuiop[]', h'5C
        DEFB 'asdfghjkl;', h'27
        DEFB 'zxcvbnm,./ '
TAI2    DEFB h'7E, '!@#$%^&*()_+'
        DEFB 'QWERTYUIOP{}|'
        DEFB 'ASDFGHJKL:', h'22
        DEFB 'ZXCVBNM<>? '
;-------
CLST    NOP ;0-LOW, 1-HI
LANG    NOP ;0-ENG, 1-RUS

ISAD    DEFS 2
ICUP    NOP ;\
        NOP ;/
;---------------------------------------