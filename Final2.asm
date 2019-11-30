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
x dd ?
s dd ?
r dd ?
t dd ?
y dd ?
_2_5 dd 2.5
_4 dd 4.0
_12 dd 12.0
_hola db "hola", '$'
_8 dd 8.0
@aux10 dd ?
@aux12 dd ?
_3 dd 3.0
@aux14 dd ?
_10 dd 10.0
@aux16 dd ?
_100 dd 100.0
_200 dd 200.0
_1 dd 1.0
@aux22 dd ?
@aux26 dd ?

.CODE

START:

MOV AX,@DATA
MOV DS, AX
FINIT

fld _2_5
fstp b
fld _4
fstp c
fld _12
fstp t
LEA EAX, _hola
 MOV x , EAX
fld _8
fld c
fadd
fstp @aux10
fld @aux10
fld t
fadd
fstp @aux12
fld @aux12
fld _3
fdiv
fstp @aux14
fld @aux14
fld _10
fadd
fstp @aux16
fld @aux16
fstp a
fld _100
fstp r
fld _200
fstp s
fld a
fld _1
fadd
fstp @aux22
fld @aux22
fstp a
etiqueta_24:
fld c
fld _1
fadd
fstp @aux26
fld @aux26
fstp c
fld c
fld t
fxch
fcomp
fstsw ax
sahf
JNAE etiqueta_24

fld c
fld s
fxch
fcomp
fstsw ax
sahf
JNA etiqueta_37

JMP etiqueta_24

etiqueta_37:
fld t
fld a
fxch
fcomp
fstsw ax
sahf
JAE etiqueta_41

etiqueta_41:
JMP etiqueta_24

DisplayFloat a,1
newLine

DisplayString @msg_float 
int 21h 
newLine 1
GetFloat b 

MOV AH, 1
INT 21h
MOV AX, 4C00h
INT 21h

END START
