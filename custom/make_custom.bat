@ECHO OFF

..\..\tools\asw\bin\asw -cpu z80undoc -U -L main.a80
..\..\tools\asw\bin\p2bin main.p justine.rom -r $-$ -k

rem ..\..\..\tools\mhmt\mhmt -mlz main.rom main_pack.rom

pause