; ------- definitions

; -- ports
extp            equ h'AF
pf7             equ h'F7

    
; -- F7 port regs
shadow          equ h'EF
nvaddr          equ h'DF
nvdata          equ h'BF


; F7 parameters
shadow_on       equ h'80
shadow_off      equ h'00


; -- TS-config port regs
xstatus         equ h'00

vconf           equ h'00
vpage           equ h'01
xoffs           equ h'02
xoffsl          equ h'02
xoffsh          equ h'03
yoffs           equ h'04
yoffsl          equ h'04
yoffsh          equ h'05
tsconf          equ h'06
palsel          equ h'07
tmpage          equ h'08
t0gpage         equ h'09
t1gpage         equ h'0A
sgpage          equ h'0B
border          equ h'0F
page0           equ h'10
page1           equ h'11
page2           equ h'12
page3           equ h'13
fmaddr          equ h'15
dmasal          equ h'1A
dmasah          equ h'1B
dmasax          equ h'1C
dmadal          equ h'1D
dmadah          equ h'1E
dmadax          equ h'1F
sysconf         equ h'20
memconf         equ h'21
hsint           equ h'22
vsint           equ h'23    ;alias
vsintl          equ h'23
vsinth          equ h'24
intv            equ h'25
dmalen          equ h'26
dmactr          equ h'27
dmanum          equ h'28
fddvirt         equ h'29

; TS parameters
fm_en           equ 0x10

; video modes
rres_256x192    equ h'00
rres_320x200    equ h'40
rres_320x240    equ h'80
rres_360x288    equ h'C0
mode_zx         equ 0
mode_16c        equ 1
mode_256c       equ 2
mode_text       equ 3
mode_nogfx      equ h'20
    
; -- RAM windows
win0            equ h'0000
win1            equ h'4000
win2            equ h'8000
win3            equ h'C000

; -- addresses
sys_var         equ h'5C00

pal_addr        equ h'6000      ; \ 
fat_bufs        equ h'4000      ; | 
res_buf         equ h'5000      ; |
nv_buf          equ h'5D00      ; | LSB should be 0 !!
vars            equ h'5B00      ; /

stck            equ h'6000
nv_1st          equ h'B0


; -- video config
txpage          equ h'F8
pal_sel         equ h'F


; -- pages config
vrompage        equ h'F4


; -- System variable values

;OS_window_cols		equ 90
;OS_window_rows		equ 36
