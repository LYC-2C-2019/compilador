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
_2 dd 2.0
_1 dd 1.0
@aux35 dd ?

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
fld _4
fxch
fcomp
fstsw ax
sahf
JNE etiqueta_25

JE etiqueta_30

etiqueta_25:
fld a
fld _2
fxch
fcomp
fstsw ax
sahf
JNE etiqueta_28

JE etiqueta_30

etiqueta_28:
JMP etiqueta_33

etiqueta_30:
fld _4
fstp a
etiqueta_33:
fld s
fld _1
fadd
fstp @aux35
fld @aux35
fstp s
fld c
fld s
fxch
fcomp
fstsw ax
sahf
JNA etiqueta_45

fld t
fld r
fxch
fcomp
fstsw ax
sahf
JAE etiqueta_45

etiqueta_45:
JMP etiqueta_33

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
