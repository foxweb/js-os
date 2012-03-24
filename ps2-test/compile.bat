echo off

C:\IAR\z80\bin\az80.exe example.asm -l example.lst
C:\IAR\z80\bin\xlink.exe -f example.xcl example.r01

copy /b header.bin + example.bin "ps2-test.$C"
del example.bin

echo.
echo Compiling of ps2-test.$C finished...
echo.
pause