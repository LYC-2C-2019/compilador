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
	@8 dd 8.0	; declaracion de constante Integer
	@3 dd 3.0	; declaracion de constante Integer
	@10 dd 10.0	; declaracion de constante Integer
	@10.4 dd 10.4	; declaracion de constante Float
	@4 dd 4.0	; declaracion de constante Integer
	@11 dd 11.0	; declaracion de constante Integer
	@13 dd 13.0	; declaracion de constante Integer
	@0 dd 0.0	; declaracion de constante Integer
	@7 dd 7.0	; declaracion de constante Integer
	@1 dd 1.0	; declaracion de constante Integer
	@5 dd 5.0	; declaracion de constante Integer
	@6 dd 6.0	; declaracion de constante Integer
	@3.21 dd 3.21	; declaracion de constante Float
	@2 dd 2.0	; declaracion de constante Integer
	@12 dd 12.0	; declaracion de constante Integer
	@34 dd 34.0	; declaracion de constante Integer
	@48 dd 48.0	; declaracion de constante Integer
	@2.3 dd 2.3	; declaracion de constante Float
	@1.22 dd 1.22	; declaracion de constante Float

.CODE
.startup
	mov AX,@DATA
	mov DS,AX

	FINIT

	 FLD @8 	; se carga operando 1
	 FLD @c 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux9 	; se almacena resultado en una variable auxiliar
	 FLD @_aux9 	; se carga operando 1
	 FLD @d 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux11 	; se almacena resultado en una variable auxiliar
	 FLD @_aux11 	; se carga operando 1
	 FLD @3 	; se carga operando 2
	 FDIV 		; se realiza la operacion
	 FSTP @_aux13 	; se almacena resultado en una variable auxiliar
	 FLD @_aux13 	; se carga operando 1
	 FLD @10 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux15 	; se almacena resultado en una variable auxiliar
	 FLD @t 	; se carga operando 1
	 FLD @_aux15 	; se carga operando 2
	 FSTP @_aux16 	; se almacena resultado en una variable auxiliar
	 FLD @3 	; se carga operando 1
	 FLD @4 	; se carga operando 2
	 FMUL 		; se realiza la operacion
	 FSTP @_aux26 	; se almacena resultado en una variable auxiliar
	 FLD @hola 	; se carga operando 1
	 FLD @_aux26 	; se carga operando 2
	 FSTP @_aux27 	; se almacena resultado en una variable auxiliar
	 FLD @cont 	; se carga operando 1
	 FLD @_aux27 	; se carga operando 2
	 FSTP @_aux28 	; se almacena resultado en una variable auxiliar
	 FLD @10.4 	; se carga operando 1
	 FLD @_aux28 	; se carga operando 2
	 FSTP @_aux29 	; se almacena resultado en una variable auxiliar
	 FLD @d 	; se carga operando 1
	 FLD @_aux29 	; se carga operando 2
	 FSTP @_aux30 	; se almacena resultado en una variable auxiliar
	 FLD @c 	; se carga operando 1
	 FLD @_aux30 	; se carga operando 2
	 FSTP @_aux31 	; se almacena resultado en una variable auxiliar
	 FLD @b 	; se carga operando 1
	 FLD @_aux31 	; se carga operando 2
	 FSTP @_aux32 	; se almacena resultado en una variable auxiliar
	 FLD @a 	; se carga operando 1
	 FLD @_aux32 	; se carga operando 2
	 FSTP @_aux33 	; se almacena resultado en una variable auxiliar
	 FLD @_aux16 	; se carga operando 1
	 FLD @_aux33 	; se carga operando 2
	 FSTP @_aux34 	; se almacena resultado en una variable auxiliar
	 FLD @r 	; se carga operando 1
	 FLD @_aux34 	; se carga operando 2
	 FSTP @_aux35 	; se almacena resultado en una variable auxiliar
	 FLD @s 	; se carga operando 1
	 FLD @_aux35 	; se carga operando 2
	 FSTP @_aux36 	; se almacena resultado en una variable auxiliar
	 FLD @A 	; se carga operando 1
	 FLD @_aux36 	; se carga operando 2
	 FSTP @_aux37 	; se almacena resultado en una variable auxiliar
	 FLD @a		; se carga operando1 para comparacion
	 FLD @b		; se carga operando 2 para comparacion
	 FCOMP		; se compara ST(0) con ST(1) 
	 FFREE ST(0) 	; se libera ST(0)
	 FSTSW AX 		; se mueve la palabra de estado al registro AX
	 SAHF 			; se mueve el contenido del registro AX al registro FLAGS
	 JLE ETIQ_52 	; si se cumple la condicion se produce un salto a la etiqueta
	 FLD @_aux37 	; se carga operando 1
	 FLD @11 	; se carga operando 2
	 FSTP @_aux43 	; se almacena resultado en una variable auxiliar
	 FLD @_aux43 	; se carga operando 1
	 FLD @13 	; se carga operando 2
	 FSTP @_aux45 	; se almacena resultado en una variable auxiliar
	 FLD @c		; se carga operando1 para comparacion
	 FLD @d		; se carga operando 2 para comparacion
	 FCOMP		; se compara ST(0) con ST(1) 
	 FFREE ST(0) 	; se libera ST(0)
	 FSTSW AX 		; se mueve la palabra de estado al registro AX
	 SAHF 			; se mueve el contenido del registro AX al registro FLAGS
	 JLE ETIQ_52 	; si se cumple la condicion se produce un salto a la etiqueta
	 FLD @_aux45 	; se carga operando 1
	 FLD @0 	; se carga operando 2
	 FSTP @_aux51 	; se almacena resultado en una variable auxiliar
ETIQ_52: 
	 FLD @a 	; se carga operando 1
	 FLD @7 	; se carga operando 2
	 FMUL 		; se realiza la operacion
	 FSTP @_aux54 	; se almacena resultado en una variable auxiliar
	 FLD @_aux54 	; se carga operando 1
	 FLD @b 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux56 	; se almacena resultado en una variable auxiliar
	 FLD @c 	; se carga operando 1
	 FLD @4 	; se carga operando 2
	 FMUL 		; se realiza la operacion
	 FSTP @_aux60 	; se almacena resultado en una variable auxiliar
	 FLD @b 	; se carga operando 1
	 FLD @_aux60 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux61 	; se almacena resultado en una variable auxiliar
	 FLD @_aux56		; se carga operando1 para comparacion
	 FLD @_aux61		; se carga operando 2 para comparacion
	 FCOMP		; se compara ST(0) con ST(1) 
	 FFREE ST(0) 	; se libera ST(0)
	 FSTSW AX 		; se mueve la palabra de estado al registro AX
	 SAHF 			; se mueve el contenido del registro AX al registro FLAGS
	 JGE ETIQ_68 	; si se cumple la condicion se produce un salto a la etiqueta
	 FLD @a 	; se carga operando 1
	 FLD @1 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux66 	; se almacena resultado en una variable auxiliar
	 FLD @_aux51 	; se carga operando 1
	 FLD @_aux66 	; se carga operando 2
	 FSTP @_aux67 	; se almacena resultado en una variable auxiliar
ETIQ_68: 
	 JMP ETIQ_77 	; si se cumple la condicion se produce un salto a la etiqueta
	 FLD @_aux67 	; se carga operando 1
	 FLD @0 	; se carga operando 2
	 FSTP @_aux70 	; se almacena resultado en una variable auxiliar
	 FLD @_aux70 	; se carga operando 1
	 FLD @4 	; se carga operando 2
	 FSTP @_aux72 	; se almacena resultado en una variable auxiliar
	 FLD @_aux72 	; se carga operando 1
	 FLD @5 	; se carga operando 2
	 FSTP @_aux74 	; se almacena resultado en una variable auxiliar
	 FLD @_aux74 	; se carga operando 1
	 FLD @6 	; se carga operando 2
	 FSTP @_aux76 	; se almacena resultado en una variable auxiliar
ETIQ_77: 
ETIQ_78: 
	 FLD @a 	; se carga operando 1
	 FLD @1 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux79 	; se almacena resultado en una variable auxiliar
	 FLD @_aux76 	; se carga operando 1
	 FLD @_aux79 	; se carga operando 2
	 FSTP @_aux80 	; se almacena resultado en una variable auxiliar
ETIQ_82: 
	 FLD @b 	; se carga operando 1
	 FLD @1 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux83 	; se almacena resultado en una variable auxiliar
	 FLD @_aux80 	; se carga operando 1
	 FLD @_aux83 	; se carga operando 2
	 FSTP @_aux84 	; se almacena resultado en una variable auxiliar
	 mov si,OFFSET @z 	; se carga operando1
	 mov di,OFFSET @w 	; se carga operando2 
	 STRCMP	; se ejecuta macro para comparar 
	 JGE ETIQ_82 	; si se cumple la condicion se produce un salto a la etiqueta
	 FLD @c		; se carga operando1 para comparacion
	 FLD @d		; se carga operando 2 para comparacion
	 FCOMP		; se compara ST(0) con ST(1) 
	 FFREE ST(0) 	; se libera ST(0)
	 FSTSW AX 		; se mueve la palabra de estado al registro AX
	 SAHF 			; se mueve el contenido del registro AX al registro FLAGS
	 JG ETIQ_97 	; si se cumple la condicion se produce un salto a la etiqueta
	 mov si,OFFSET @f 	; se carga operando1
	 mov di,OFFSET @g 	; se carga operando2 
	 STRCMP	; se ejecuta macro para comparar 
	 JGE ETIQ_78 	; si se cumple la condicion se produce un salto a la etiqueta
ETIQ_97: 
	 DisplayString @A 
	 newLine 
	 GetString @B
	 FLD @7 	; se carga operando 1
	 FLD @6 	; se carga operando 2
	 FMUL 		; se realiza la operacion
	 FSTP @_aux102 	; se almacena resultado en una variable auxiliar
	 FLD @8 	; se carga operando 1
	 FLD @c 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux105 	; se almacena resultado en una variable auxiliar
	 FLD @_aux105 	; se carga operando 1
	 FLD @d 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux107 	; se almacena resultado en una variable auxiliar
	 FLD @_aux107 	; se carga operando 1
	 FLD @3.21 	; se carga operando 2
	 FDIV 		; se realiza la operacion
	 FSTP @_aux109 	; se almacena resultado en una variable auxiliar
	 FLD @2 	; se carga operando 1
	 FLD @b 	; se carga operando 2
	 FMUL 		; se realiza la operacion
	 FSTP @_aux112 	; se almacena resultado en una variable auxiliar
	 FLD @_aux112 	; se carga operando 1
	 FLD @7 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux114 	; se almacena resultado en una variable auxiliar
	 FLD @34 	; se carga operando 1
	 FLD @d 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux120 	; se almacena resultado en una variable auxiliar
	 FLD @b 	; se carga operando 1
	 FLD @_aux120 	; se carga operando 2
	 FMUL 		; se realiza la operacion
	 FSTP @_aux121 	; se almacena resultado en una variable auxiliar
	 FLD @a 	; se carga operando 1
	 FLD @_aux121 	; se carga operando 2
	 FADD 		; se realiza la operacion
	 FSTP @_aux122 	; se almacena resultado en una variable auxiliar
	 mov AX, 4C00h 	 ; Genera la interrupcion 21h
	 int 21h 	 ; Genera la interrupcion 21h
END MAIN
