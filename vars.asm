
                org vars

; -- System variables

char_colour		defs 1		; Character colour to be printed
current_pen		defs 1		; Current pen
border_colour	defs 1		; Border colour
cursor_y		defs 1		; Cursor postition Y
cursor_x		defs 1		; Cursor position X
OS_window_cols	defs 1		; Maximum cols , in gfx mode cols are pixels
OS_window_rows	defs 1		; Maximum rows , in gfx mode cols are pixels
cursorflashtimer	defs 1		; Cursor flash timer
cursorstatus	defs 1		; Cursor status
rnd_seed		defs 1		; Random number seed
rnd_num		defs 1		; Random number
command_buffer	defs 64		; Command line buffer

; -------- FAT driver

nsdc            defs 1      ; sec num in clus
eoc             defs 1      ; chain end flag
abt             defs 1
nr0             defs 2      ; number of sectors to be loaded
lstse           defs 4
rezde           defs 2
clhl            defs 2
clde            defs 2
llhl            defs 4
lthl            defs 2      ;last
ltde            defs 2

entry           defs 11     ; \ name
e_flag          defs 1      ; | flag
e_ntres         defs 1      ; | reserved for use by winNT
e_mills         defs 1      ; | Millisecond stap
e_cr_tm         defs 2      ; | CreateTime
e_cr_da         defs 2      ; | CreateDate
e_lt_ad         defs 2      ; | LstAccDate
clsde           defs 2      ; | FirstClusHI
e_wr_tm         defs 2      ; | WriteTime
e_wr_da         defs 2      ; | WriteDate
clshl           defs 2      ; | FirstClusLO
sizik           defs 4      ; / size

brezs           defs 2      ; fat parameters
bfats           defs 1
bftsz           defs 4
bsecpc          defs 2      ; use 1
brootc          defs 4
addtop          defs 4
sfat            defs 2
sdfat           defs 4
cuhl            defs 2
cude            defs 2
ldhl            defs 2      ; addr to read/write
count           defs 1
duhl            defs 2
dude            defs 2
lstcat          defs 4      ; active dir
blknum          defs 4
dahl            defs 2      ; see hdd proc.
dade            defs 2
drvre           defs 1
device          defs 1; 0 - SD, 1 - HDD Master, 2 - HDD Slave
zes             defs 1


; -- NVRAM cells
                org nv_buf + nv_1st

fddv            defs 1      ; FDDVirt (#29AF copy)  // non-removable #B0
cfrq            defs 1      ; CPU freq              // non-removable #B1
bdev            defs 1      ; boot device           // non-removable #B2

ayfr            defs 1      ; AY freq
b1to            defs 1      ; Boot option
b1tb            defs 1      ; Boot bank
b2to            defs 1      ; CS Boot option
b2tb            defs 1      ; CS Boot bank
l128            defs 1      ; Lock 128
zpal            defs 1      ; ZX palette
cpal            defs 32     ; Custom palette
nvcs            defs 2      ; checksum - must be last in the declaration

nv_size         equ $ - nv_buf - nv_1st
 .if nv_size > 64
#error 'NVRAM is exceeding 64 bytes!'
 .endif


; FAT driver buffers
                org fat_bufs

secbu           defs 512
secbe
lobu            defs 512
lobe            defs 32

