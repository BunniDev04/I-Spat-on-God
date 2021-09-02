@echo off
axm68k /o op+ /o os+ /o ow+ /o oz+ /o oaq+ /o osq+ /o omq+ /p /o ae- Main.asm, SMW.bin
rompad.exe SMW.bin 255 0
fixheadr.exe SMW.bin
pause