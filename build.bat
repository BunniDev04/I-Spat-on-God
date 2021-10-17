@echo off
axm68k /o op+ /o os+ /o ow+ /o oz+ /o oaq+ /o osq+ /o omq+ /p /o ae- Main.asm, SMW.bin, output.sym, output.lst
convsym output.lst SMW.bin -input asm68k_lst -inopt "/localSign=@ /localJoin=. /ignoreMacroDefs+ /ignoreMacroExp- /addMacrosAsOpcodes+" -a
fixheadr.exe SMW.bin
pause