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
e dd ?
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
_10_87 dd 10.87
_20_9 dd 20.9
_se_cumple db "se_cumple", '$'
_parte_verdadera db "parte_verdadera", '$'
_parte_falsa db "parte_falsa", '$'
_100 dd 100.0
_200 dd 200.0
_2 dd 2.0

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
fld b
fld _10_87
fxch
fcomp
fstsw ax
sahf
JNA etiqueta_23

JMP etiqueta_27

etiqueta_23:
fld e
fld _20_9
fxch
fcomp
fstsw ax
sahf
JAE etiqueta_28

etiqueta_27:
DisplayString _se_cumple,1
newLine

etiqueta_28:
fld c
fld _10
fxch
fcomp
fstsw ax
sahf
JA etiqueta_34

DisplayString _parte_verdadera,1
newLine

JMP etiqueta_35

etiqueta_34:
DisplayString _parte_falsa,1
newLine

etiqueta_35:
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
JNE etiqueta_42

JE etiqueta_47

etiqueta_42:
fld a
fld _2
fxch
fcomp
fstsw ax
sahf
JNE etiqueta_45

<<<<<<< HEAD
etiqueta_54:
=======
JE etiqueta_47

etiqueta_45:
JMP etiqueta_50

etiqueta_47:
fld _4
fstp a
etiqueta_50:
>>>>>>> correccion-if
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
