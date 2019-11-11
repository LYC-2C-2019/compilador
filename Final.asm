include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
	@a dd ?	 ; declaracion de variable numerica
	@b dd ?	 ; declaracion de variable numerica
	@c dd ?	 ; declaracion de variable numerica
	@A db 30 dup (?),"$"	; declaracion de variable String
	@s dd ?	 ; declaracion de variable numerica
	@r dd ?	 ; declaracion de variable numerica
	@t dd ?	 ; declaracion de variable numerica
	@4 dd 4.0	; declaracion de constante Integer
	@2 dd 2.0	; declaracion de constante Integer
	@6 dd 6.0	; declaracion de constante Integer
	@5 dd 5.0	; declaracion de constante Integer

.CODE
.startup
	mov AX,@DATA
	mov DS,AX

	FINIT

	 FLD @t 	; se carga operando 1
	 FLD @4 	; se carga operando 2
	 FSTP @_aux8 	; se almacena resultado en una variable auxiliar
	 FLD @_aux8 	; se carga operando 1
	 FLD @2 	; se carga operando 2
	 FSTP @_aux10 	; se almacena resultado en una variable auxiliar
	 FLD @_aux10 	; se carga operando 1
	 FLD @6 	; se carga operando 2
	 FSTP @_aux12 	; se almacena resultado en una variable auxiliar
	 FLD @a		; se carga operando1 para comparacion
	 FLD @c		; se carga operando 2 para comparacion
	 FCOMP		; se compara ST(0) con ST(1) 
	 FFREE ST(0) 	; se libera ST(0)
	 FSTSW AX 		; se mueve la palabra de estado al registro AX
	 SAHF 			; se mueve el contenido del registro AX al registro FLAGS
	 JGE ETIQ_19 	; si se cumple la condicion se produce un salto a la etiqueta
	 FLD @_aux12 	; se carga operando 1
	 FLD @5 	; se carga operando 2
	 FSTP @_aux18 	; se almacena resultado en una variable auxiliar
ETIQ_19: 
	 FLD @2		; se carga operando1 para comparacion
	 FLD @4		; se carga operando 2 para comparacion
	 FCOMP		; se compara ST(0) con ST(1) 
	 FFREE ST(0) 	; se libera ST(0)
	 FSTSW AX 		; se mueve la palabra de estado al registro AX
	 SAHF 			; se mueve el contenido del registro AX al registro FLAGS
	 JNE ETIQ_24 	; si se cumple la condicion se produce un salto a la etiqueta
	 JE ETIQ_29 	; si se cumple la condicion se produce un salto a la etiqueta
ETIQ_24: 
	 FLD @2		; se carga operando1 para comparacion
	 FLD @_aux18		; se carga operando 2 para comparacion
	 FCOMP		; se compara ST(0) con ST(1) 
	 FFREE ST(0) 	; se libera ST(0)
	 FSTSW AX 		; se mueve la palabra de estado al registro AX
	 SAHF 			; se mueve el contenido del registro AX al registro FLAGS
	 JNE ETIQ_27 	; si se cumple la condicion se produce un salto a la etiqueta
	 JE ETIQ_29 	; si se cumple la condicion se produce un salto a la etiqueta
ETIQ_27: 
	 FLD @s 	; se carga operando 1
	 FLD @r 	; se carga operando 2
	 FSTP @_aux27 	; se almacena resultado en una variable auxiliar
ETIQ_29: 
	 FLD @_aux27 	; se carga operando 1
	 FLD @_JMP 	; se carga operando 2
	 FSTP @_aux29 	; se almacena resultado en una variable auxiliar
	 FLD @_aux29 	; se carga operando 1
	 FLD @4 	; se carga operando 2
	 FSTP @_aux31 	; se almacena resultado en una variable auxiliar
	 mov AX, 4C00h 	 ; Genera la interrupcion 21h
	 int 21h 	 ; Genera la interrupcion 21h
END
