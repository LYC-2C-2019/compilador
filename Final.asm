include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h

MAXTEXTSIZE EQU 32

.DATA
@msg_int db "Type in integer value:", '$'
@msg_float db "Type in float value:", '$'
a dd ?
b dd ?
c dd ?
A dd ?
s dd ?
r dd ?
t dd ?
_2 dd 2.0
_6 dd 6.0
_4 dd 4.0

.CODE

START:

MOV AX,@DATA
MOV DS, AX
FINIT

fld a
fstp c
fld 2
fstp a
fld _6
fstp t
fld a
fld _4
fxch
fcomp
fstsw ax
sahf
JNE etiqueta_11

JE etiqueta_16

etiqueta_11:
fld a
fld _2
fxch
fcomp
fstsw ax
sahf
JNE etiqueta_14

JE etiqueta_16

etiqueta_14:
JMP etiqueta_17

etiqueta_16:
etiqueta_17:
fld _4
fstp a

MOV AH, 1
INT 21h
MOV AX, 4C00h
INT 21h

END START
