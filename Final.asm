include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h
.DATA
NEW_LINE DB 0AH,0DH,'$'
CWprevio DW ?
a dd ?
b dd ?
c dd ?
x dd ?
s dd ?
r dd ?
t dd ?
y dd ?
_4 dd 4.0
_12 dd 12.0
_hola db "hola", '$'
_8 dd 8.0
@aux8 dd ?
@aux10 dd ?
_3 dd 3.0
@aux12 dd ?
_10 dd 10.0
@aux14 dd ?
_1 dd 1.0
@aux18 dd ?

.CODE

START:

MOV AX,@DATA
MOV DS, AX
FINIT


.CODE
.startup
	mov AX,@DATA
	mov DS,AX

	FINIT

fld _4
fstp c
fld _12
fstp t
fld _hola
fstp x
fld _8
fld c
fadd
fstp @aux8
fld @aux8
fld t
fadd
fstp @aux10
fld @aux10
fld _3
fdiv
fstp @aux12
fld @aux12
fld _10
fadd
fstp @aux14
fld @aux14
fstp a
etiqueta_16:
fld a
fld _1
fadd
fstp @aux18
fld @aux18
fstp a
fld a
fld t
fxch
fcomp
fstsw ax
sahf
JNA etiqueta_16


MOV AH, 1
INT 21h
MOV AX, 4C00h
INT 21h

END START
