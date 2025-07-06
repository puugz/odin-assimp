@echo off
call cl /nologo generate_odin_asserts.c /Isource\include /link assimp-vc143-mt.lib
call generate_odin_asserts.exe
