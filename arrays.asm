test_command
		defb 'time'

; ------- messages

M_HEAD1
        defb 'JS Operating System ',$FC
	  defb  '20'
        dec8 date 6      ; year (0-99)
	  defb 0

M_HEAD2
        defb 'Build Date: '
        dec8 date 4      ; day (1-31)
        defb  '.'
        dec8 date 5      ; month (1-12)
        defb  '.20'
        dec8 date 6      ; year (0-99)
        defb  ' '
        dec8 date 3      ; hour (0-23)
        defb  ':'
        dec8 date 2      ; minute (0-59)
        defb  ':'
        dec8 date 1      ; second (0-59)
        defb 0

M_NEWLINE   defb h'0d, 0

M_TIME  defb 'Time : ', 0

M_DATE  defb 'Date : ', 0

M_SYNTAX	defb 'Syntax error - Invalid command', h'0d, 0

M_test	defb 'This command works......', h'0d, 0


; -- palette

pal_64c
        defw h'0000
        defw h'0008
        defw h'0010
        defw h'0018
        defw h'2000
        defw h'2008
        defw h'2010
        defw h'2018
        defw h'4000
        defw h'4008
        defw h'4010
        defw h'4018
        defw h'6000
        defw h'6008
        defw h'6010
        defw h'6018
        defw h'0100
        defw h'0108
        defw h'0110
        defw h'0118
        defw h'2100
        defw h'2108
        defw h'2110
        defw h'2118
        defw h'4100
        defw h'4108
        defw h'4110
        defw h'4118
        defw h'6100
        defw h'6108
        defw h'6110
        defw h'6118
        defw h'0200
        defw h'0208
        defw h'0210
        defw h'0218
        defw h'2200
        defw h'2208
        defw h'2210
        defw h'2218
        defw h'4200
        defw h'4208
        defw h'4210
        defw h'4218
        defw h'6200
        defw h'6208
        defw h'6210
        defw h'6218
        defw h'0300
        defw h'0308
        defw h'0310
        defw h'0318
        defw h'2300
        defw h'2308
        defw h'2310
        defw h'2318
        defw h'4300
        defw h'4308
        defw h'4310
        defw h'4318
        defw h'6300
        defw h'6308
        defw h'6310
        defw h'6318
        

sysvar_start
        defb h'FF,h'00,h'23,h'0D,h'44,h'05,h'0B,h'44,h'00,h'10,h'01,h'00,h'00,h'00,h'16,h'07
        defb h'01,h'00,h'06,h'00,h'0B,h'00,h'01,h'00,h'01,h'00,h'06,h'00,h'10,h'00,h'00,h'00
        defb h'00,h'00,h'00,h'00,h'00,h'00,h'01,h'FD,h'7F,h'3E,h'14,h'ED,h'79,h'C3,h'00,h'C0
        defb h'18,h'F4,h'00,h'00,h'00,h'00,h'00,h'3C,h'40,h'00,h'FF,h'CD,h'01,h'FC,h'5F,h'00
        defb h'00,h'00,h'01,h'00,h'FF,h'74,h'2E,h'01,h'07,h'00,h'00,h'4A,h'5D,h'00,h'00,h'26
        defb h'5D,h'26,h'5D,h'3B,h'5D,h'4F,h'5D,h'3A,h'5D,h'4B,h'5D,h'36,h'5E,h'48,h'5D,h'00
        defb h'00,h'4D,h'5D,h'4D,h'5D,h'4D,h'5D,h'2D,h'92,h'5C,h'08,h'02,h'00,h'00,h'00,h'00
        defb h'00,h'00,h'00,h'00,h'B6,h'1A,h'00,h'00,h'AA,h'18,h'00,h'58,h'FF,h'00,h'00,h'00
        defb h'00,h'00,h'21,h'17,h'00,h'40,h'E0,h'50,h'21,h'18,h'21,h'17,h'01,h'07,h'00,h'38
        defb h'00,h'00,h'AF,h'D3,h'F7,h'DB,h'F7,h'FE,h'1E,h'28,h'03,h'FE,h'1F,h'C0,h'CF,h'31
        defb h'3E,h'01,h'32,h'EF,h'5C,h'C9,h'00,h'00,h'00,h'00,h'00,h'00,h'00,h'00,h'00,h'00
        defb h'00,h'00,h'FF,h'5F,h'FF,h'FF,h'F4,h'09,h'A8,h'10,h'4B,h'F4,h'09,h'C4,h'15,h'53
        defb h'81,h'0F,h'C9,h'C9,h'52,h'34,h'5B,h'2F,h'FF,h'FF,h'FF,h'FF,h'00,h'00,h'00,h'22
        defb h'31,h'35,h'36,h'31,h'36,h'22,h'03,h'DB,h'01,h'3D,h'5D,h'FF,h'00,h'53,h'74,h'6F
        defb h'72,h'6D,h'20,h'20,h'20,h'42,h'FA,h'00,h'2E,h'00,h'6D,h'00,h'01,h'00,h'00,h'00
        defb h'00,h'00,h'00,h'00,h'01,h'01,h'00,h'00,h'00,h'00,h'08,h'08,h'08,h'08,h'80,h'00
        defb h'25,h'5D,h'25,h'5D,h'3B,h'5F,h'09,h'00,h'00,h'00,h'00,h'00,h'FF,h'00,h'00,h'07
        defb h'00,h'3C,h'5D,h'FC,h'5F,h'FF,h'2C,h'AA,h'00,h'00,h'01,h'02,h'E6,h'5F,h'00,h'00
        defb h'F7,h'22,h'62,h'00,h'00,h'FF,h'F4,h'09,h'A8,h'10,h'4B,h'F4,h'09,h'C4,h'15,h'53
        defb h'81,h'0F,h'C4,h'15,h'52,h'34,h'5B,h'2F,h'5B,h'50,h'80,h'00,h'05,h'0B,h'00,h'F9
        defb h'C0,h'B0,h'22,h'32,h'33,h'36,h'30,h'30,h'22,h'0D,h'80,h'0D,h'80,h'31,h'00,h'60
        defb h'2A,h'3B,h'5D,h'22,h'FE,h'5B,h'ED,h'5B,h'F4,h'5C,h'21,h'19,h'6F,h'E5,h'06,h'42
        defb h'CD,h'96,h'5D,h'CD,h'8E,h'5D,h'21,h'00,h'DB,h'06,h'25,h'CD,h'96,h'5D,h'3A,h'AE
        defb h'E5,h'E6,h'F7,h'F6,h'10,h'CD,h'90,h'5D,h'21,h'00,h'FB,h'06,h'05,h'CD,h'96,h'5D
        defb h'CD,h'8E,h'5D,h'3E,h'20,h'DD,h'DD,h'DD,h'DD,h'DD,h'DD,h'DD,h'18,h'79,h'3E,h'17
        defb h'01,h'FD,h'7F,h'ED,h'79,h'C9,h'CD,h'05,h'5E,h'0E,h'FF,h'F3,h'0C,h'28,h'0C,h'79
        defb h'E6,h'07,h'20,h'0D,h'D9,h'3E,h'08,h'CD,h'2D,h'5E,h'D9,h'7A,h'D9,h'CD,h'12,h'5E
        defb h'D9,h'7B,h'E5,h'D9,h'E1,h'16,h'00,h'CD,h'C8,h'5D,h'20,h'DF,h'24,h'1C,h'CB,h'63
        defb h'28,h'03,h'CB,h'A3,h'14,h'10,h'D2,h'C9,h'3C,h'0E,h'5F,h'CD,h'09,h'5E,h'3E,h'80
        defb h'CD,h'07,h'5E,h'DD,h'21,h'D7,h'3F,h'01,h'7F,h'01,h'CD,h'0D,h'5E,h'28,h'0E,h'3A
        defb h'D6,h'5C,h'08,h'CD,h'FA,h'5D,h'08,h'32,h'D6,h'5C,h'05,h'D9,h'C9,h'CD,h'05,h'5E
        defb h'3E,h'D4,h'CD,h'2D,h'5E,h'D9,h'0E,h'07,h'B1,h'C9,h'21,h'AA,h'20,h'E5,h'3E,h'01
sysvar_end
