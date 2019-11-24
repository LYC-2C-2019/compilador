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
_4 dd 4.0
_12 dd 12.0
_hola db "hola", '$'
_1 dd 1.0
_8 dd 8.0
@aux10 dd ?
@aux12 dd ?
_3 dd 3.0
@aux14 dd ?
_10 dd 10.0
@aux16 dd ?
_5 dd 5.0
@aux26 dd ?
@aux30 dd ?

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
fld _1
fstp s
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
fld a
fld c
fxch
fcomp
fstsw ax
sahf
JAE etiqueta_24

fld _5
fstp c
etiqueta_24:
fld a
fld _1
fadd
fstp @aux26
fld @aux26
fstp a
etiqueta_28:
fld c
fld _1
fadd
fstp @aux30
fld @aux30
fstp c
fld c
fld t
fxch
fcomp
fstsw ax
sahf
JNAE etiqueta_28

fld c
fld s
fxch
fcomp
fstsw ax
sahf
JNA etiqueta_41

JMP etiqueta_28

etiqueta_41:
fld t
fld a
fxch
fcomp
fstsw ax
sahf
JAE etiqueta_45

etiqueta_45:
JMP etiqueta_28

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
