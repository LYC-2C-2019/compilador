include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h

MAXTEXTSIZE EQU 32

.DATA
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
_5 dd 5.0
_1 dd 1.0
@aux24 dd ?

.CODE

START:

MOV AX,@DATA
MOV DS, AX
FINIT

fld _4
fstp c
fld _12
fstp t
LEA EAX, _hola
 MOV x , EAX
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
fld a
fld c
fxch
fcomp
fstsw ax
sahf
JAE etiqueta_22

fld _5
fstp c
etiqueta_22:
fld a
fld _1
fadd
fstp @aux24
fld @aux24
fstp a
fld a
fld t
fxch
fcomp
fstsw ax
sahf
JNA etiqueta_22


MOV AH, 1
INT 21h
MOV AX, 4C00h
INT 21h

END START
