echo off

"%IAR%\az80.exe" ps2_handler.asm -l ps2_handler.lst
"%IAR%\xlink.exe" -f ps2_handler.xcl ps2_handler.r01

pause