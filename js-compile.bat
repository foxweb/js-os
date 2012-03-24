echo off


C:\IAR\z80\bin\az80.exe js-os.asm -l js-os.lst
C:\IAR\z80\bin\xlink.exe -Hff -f js-os.xcl js-os.r01
del js-os.r01

C:\IAR\z80\bin\az80.exe starter.asm
C:\IAR\z80\bin\xlink.exe -f starter.xcl starter.r01
del starter.r01

copy /b header.bin + starter.bin "build/js-os.$C"
del starter.bin

echo.
echo Compiling of js-os.$C finished...
echo.
pause