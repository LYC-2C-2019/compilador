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
	@12 dd 12.0	; declaracion de constante Integer
	@8 dd 8.0	; declaracion de constante Integer
	@3 dd 3.0	; declaracion de constante Integer
	@10 dd 10.0	; declaracion de constante Integer
	@5 dd 5.0	; declaracion de constante Integer
	@11 dd 11.0	; declaracion de constante Integer
	@13 dd 13.0	; declaracion de constante Integer
	@0 dd 0.0	; declaracion de constante Integer
	@7 dd 7.0	; declaracion de constante Integer
	@1 dd 1.0	; declaracion de constante Integer
	@6 dd 6.0	; declaracion de constante Integer
	@2 dd 2.0	; declaracion de constante Integer

.CODE
.startup
	mov AX,@DATA
	mov DS,AX

	FINIT

ETIQ_0: 
	 FLD @4 	; se carga el valor en la pila 
	 FSTP @c 	; se asigna el valor a la variable 
	 FLD @12 	; se carga el valor en la pila 
	 FSTP @t 	; se asigna el valor a la variable 
	 FLD @8 	; se carga operando 1
	 FLD @c 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux13 	; se almacena resultado en una variable auxiliar
	 FLD @_aux13 	; se carga operando 1
	 FLD @t 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux15 	; se almacena resultado en una variable auxiliar
	 FLD @_aux15 	; se carga operando 1
	 FLD @3 	; se carga operando 2
	 FDIV 		; se realiza la operacion
	 FSTP @_aux17 	; se almacena resultado en una variable auxiliar
	 FLD @_aux17 	; se carga operando 1
	 FLD @10 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux19 	; se almacena resultado en una variable auxiliar
	 FLD @_+ 	; se carga el valor en la pila 
	 FSTP @a 	; se asigna el valor a la variable 
	 FLD @3 	; se carga operando 1
	 FLD @4 	; se carga operando 2
	 FMUL 		; se realiza la operacion
	 FSTP @_aux30 	; se almacena resultado en una variable auxiliar
	 FLD @a		; se carga operando1 para comparacion
	 FLD @c		; se carga operando 2 para comparacion
	 FCOMP		; se compara ST(0) con ST(1) 
	 FFREE ST(0) 	; se libera ST(0)
	 FSTSW AX 		; se mueve la palabra de estado al registro AX
	 SAHF 			; se mueve el contenido del registro AX al registro FLAGS
	 JLE ETIQ_49 	; si se cumple la condicion se produce un salto a la etiqueta
	 FLD @11 	; se carga el valor en la pila 
	 FSTP @b 	; se asigna el valor a la variable 
	 FLD @13 	; se carga el valor en la pila 
	 FSTP @b 	; se asigna el valor a la variable 
	 FLD @c		; se carga operando1 para comparacion
	 FLD @t		; se carga operando 2 para comparacion
	 FCOMP		; se compara ST(0) con ST(1) 
	 FFREE ST(0) 	; se libera ST(0)
	 FSTSW AX 		; se mueve la palabra de estado al registro AX
	 SAHF 			; se mueve el contenido del registro AX al registro FLAGS
	 JLE ETIQ_49 	; si se cumple la condicion se produce un salto a la etiqueta
	 FLD @0 	; se carga el valor en la pila 
	 FSTP @a 	; se asigna el valor a la variable 
ETIQ_49: 
	 FLD @a 	; se carga operando 1
	 FLD @7 	; se carga operando 2
	 FMUL 		; se realiza la operacion
	 FSTP @_aux51 	; se almacena resultado en una variable auxiliar
	 FLD @_aux51 	; se carga operando 1
	 FLD @t 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux53 	; se almacena resultado en una variable auxiliar
	 FLD @c 	; se carga operando 1
	 FLD @4 	; se carga operando 2
	 FMUL 		; se realiza la operacion
	 FSTP @_aux57 	; se almacena resultado en una variable auxiliar
	 FLD @t 	; se carga operando 1
	 FLD @_aux57 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux58 	; se almacena resultado en una variable auxiliar
	 FLD @_aux53		; se carga operando1 para comparacion
	 FLD @_aux58		; se carga operando 2 para comparacion
	 FCOMP		; se compara ST(0) con ST(1) 
	 FFREE ST(0) 	; se libera ST(0)
	 FSTSW AX 		; se mueve la palabra de estado al registro AX
	 SAHF 			; se mueve el contenido del registro AX al registro FLAGS
	 JGE ETIQ_65 	; si se cumple la condicion se produce un salto a la etiqueta
	 FLD @a 	; se carga operando 1
	 FLD @1 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux63 	; se almacena resultado en una variable auxiliar
	 FLD @_+ 	; se carga el valor en la pila 
	 FSTP @a 	; se asigna el valor a la variable 
ETIQ_65: 
	 JMP ETIQ_74 	; si se cumple la condicion se produce un salto a la etiqueta
	 FLD @0 	; se carga el valor en la pila 
	 FSTP @a 	; se asigna el valor a la variable 
	 FLD @4 	; se carga el valor en la pila 
	 FSTP @b 	; se asigna el valor a la variable 
	 FLD @5 	; se carga el valor en la pila 
	 FSTP @b 	; se asigna el valor a la variable 
	 FLD @6 	; se carga el valor en la pila 
	 FSTP @b 	; se asigna el valor a la variable 
ETIQ_74: 
ETIQ_75: 
	 FLD @a 	; se carga operando 1
	 FLD @1 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux76 	; se almacena resultado en una variable auxiliar
	 FLD @_+ 	; se carga el valor en la pila 
	 FSTP @a 	; se asigna el valor a la variable 
ETIQ_79: 
	 FLD @b 	; se carga operando 1
	 FLD @1 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux80 	; se almacena resultado en una variable auxiliar
	 FLD @_+ 	; se carga el valor en la pila 
	 FSTP @b 	; se asigna el valor a la variable 
	 FLD @t		; se carga operando1 para comparacion
	 FLD @c		; se carga operando 2 para comparacion
	 FCOMP		; se compara ST(0) con ST(1) 
	 FFREE ST(0) 	; se libera ST(0)
	 FSTSW AX 		; se mueve la palabra de estado al registro AX
	 SAHF 			; se mueve el contenido del registro AX al registro FLAGS
	 JGE ETIQ_79 	; si se cumple la condicion se produce un salto a la etiqueta
	 FLD @c		; se carga operando1 para comparacion
	 FLD @a		; se carga operando 2 para comparacion
	 FCOMP		; se compara ST(0) con ST(1) 
	 FFREE ST(0) 	; se libera ST(0)
	 FSTSW AX 		; se mueve la palabra de estado al registro AX
	 SAHF 			; se mueve el contenido del registro AX al registro FLAGS
	 JG ETIQ_94 	; si se cumple la condicion se produce un salto a la etiqueta
	 FLD @t		; se carga operando1 para comparacion
	 FLD @a		; se carga operando 2 para comparacion
	 FCOMP		; se compara ST(0) con ST(1) 
	 FFREE ST(0) 	; se libera ST(0)
	 FSTSW AX 		; se mueve la palabra de estado al registro AX
	 SAHF 			; se mueve el contenido del registro AX al registro FLAGS
	 JGE ETIQ_75 	; si se cumple la condicion se produce un salto a la etiqueta
ETIQ_94: 
	 DisplayString @A 
	 newLine 
	 GetString @B
	 FLD @2		; se carga operando1 para comparacion
	 FLD @4		; se carga operando 2 para comparacion
	 FCOMP		; se compara ST(0) con ST(1) 
	 FFREE ST(0) 	; se libera ST(0)
	 FSTSW AX 		; se mueve la palabra de estado al registro AX
	 SAHF 			; se mueve el contenido del registro AX al registro FLAGS
	 JNE ETIQ_101 	; si se cumple la condicion se produce un salto a la etiqueta
	 JE ETIQ_106 	; si se cumple la condicion se produce un salto a la etiqueta
ETIQ_101: 
	 FLD @2		; se carga operando1 para comparacion
	 FLD @		; se carga operando 2 para comparacion
	 FCOMP		; se compara ST(0) con ST(1) 
	 FFREE ST(0) 	; se libera ST(0)
	 FSTSW AX 		; se mueve la palabra de estado al registro AX
	 SAHF 			; se mueve el contenido del registro AX al registro FLAGS
	 JNE ETIQ_104 	; si se cumple la condicion se produce un salto a la etiqueta
	 JE ETIQ_106 	; si se cumple la condicion se produce un salto a la etiqueta
ETIQ_104: 
ETIQ_106: 
	 FLD @4 	; se carga el valor en la pila 
	 FSTP @a 	; se asigna el valor a la variable 
	 mov AX, 4C00h 	 ; Genera la interrupcion 21h
	 int 21h 	 ; Genera la interrupcion 21h
END
