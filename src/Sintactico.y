%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
#include <string.h>
#include <ctype.h>
#include "lib/const.h"
#include "lib/tabla.h"
#include "lib/pila.h"
#include "lib/tercetos.h"
#include "lib/assembler.h"
#include "lib/utils.h"

	int yystopparser=0;
int yylineno;
	FILE  *yyin;
	char *yyltext;
	char *yytext;
	FILE *archivoCodigoIntermedio;
	char mensajeDeError[200];
	char conversionItoA[20];
	char bufferaux1[20];
	char bufferaux2[20];
	char constanteAux[20];
	FILE *archivoAssembler;

	/* --------------- CONSTANTES --------------- */

#define TAM_NOMBRE 32						/* Limite tamaño nombre (sumar 1 para _ ) */
#define CteString "ConstString"
#define CteInt "ConstInteger"
#define CteReal "ConstFloat"

#define variableEntera 1
#define	variableFloat 2
#define variableString 3
#define constanteEntera 4
#define constanteFloat 5
#define constanteString 6

	/* --------------- PROTOTIPO DE FUNCIONES --------------- */

	void guardarTabla(void);
	void agregarConstante(char*,char*, int);
	int buscarCte(char* , char*);
	void validarVariableDeclarada(char* nombre);
	void mostrarError(char *mensaje);
	void guardarTipo(char * tipoVariable);
	void guardarEnVectorTablaSimbolos(int opc, char * cad);
	void acomodarPunterosTS();
	void quitarDuplicados();
	void copiarCharEn(char **, char*);
	char* validaTipo(char* );
	void completarTipoNumerico();
	void agregarAuxAssembler();
	void replace_char(char* str, char find, char replace);
	void invertir_salto(terceto* vector, int indice);

	int cantidadTokens = 0;
	int i=0; 
	int j=0;
	int cant_elementos=0;
	int min=0;
	int pos_td=0;
	int pos_cv=0;
	int cant_variables=0;
	int cant_tipo_dato=0; 
	int diferencia=0;
	int cant_ctes=0;
	int finBloqueDeclaraciones=0;
	int ladoDerecho=0;
	int ladoIzquierdo=0;
	int aux1=0;
	int aux2=0;
	char tipoVariableActual[20];
	char tipoVariable[10];
	// int aux_tiponumerico=0;
	int aux_ladoIzquierdo_comparacion =0;
	int aux_ladoDerecho_comparacion =0;
	int cantidad_constantes_float=1;

	char idAux[20];
	char aux_assembler[10]="@aux";
	
	int yylex();
	int yyerror();
	
	#define DEBUG		0

	/* --------------- VECTOR OPERACION -------------- */

	typedef struct{
		char id[35];
		char tipo[10];
		int tipoNumerico;
	} operacion;

	operacion vector_operacion[1000];
	int cantOperaciones=0;

	/* --------------- TERCETOS -------------- */

	int F_ind=0;
	int	T_ind=0;
	int E_ind=0;
	int ASIG_ind=0;
	int aux=0;
	int auxRepeat=0;

	Pila pilaExpresion;
	Pila pilaTermino;
	Pila pilaFactor;
	Pila pilaTercetoActual;					// para la parte de IF / REPEAT (?)
	Pila pilaIf;
	Pila pilaRepeat;
	Pila pilaOperacion;
	Pila pilaFilter;

	/* --------------- ASIGNACION MULTIPLE -------------- */

	typedef struct asign_multiple {

		char valor[10];
		char nombre[35];
		char tipo[35];

	}	asign_multiple;

	asign_multiple  vector_asig_multiple[200]; 		// vector de tercetos
	int indice_asign_multiple=0;
	int indice_expresiones_asign_multiple = 0;

	%}

%union {
	int int_val;
	double float_val;
	char *str_val;
}

%token	INTEGER
%token	FLOAT
%token	STRING
%token	REPEAT
%token	UNTIL
%token	IF
%token	THEN
%token	ELSE
%token	ENDIF
%token	AND
%token	OR
%token	NOT
%token	PRINT
%token	READ
%token	VAR
%token	ENDVAR
%token	INLIST

%token	COLON
%token	SCOLON
%token	COMMA
%token	COMP
%token	ASSIG
%token	SLASH
%token	STAR
%token	PLUS
%token	DASH
%token	BRA_O
%token	BRA_C
%token	SBRA_O
%token	SBRA_C
%token	CBRA_O
%token	CBRA_C
%token	ID
%token	CTE_S
%token	CTE_I
%token	CTE_F

%token GT
%token LT
%token GE
%token LE
%token EQ
%token NE

%left	PLUS DASH
%left	STAR SLASH
%right	MENOS_UNARIO

%start start_programa

%%

start_programa : programa 
{ 
	printf("Compilation successful!\n\n"); 
}

programa : declaraciones bloque
{ printf("Regla 0\n"); }

declaraciones: VAR lista_declaraciones ENDVAR 
{ 
	finBloqueDeclaraciones=1;
	quitarDuplicados(); 
	printf("Regla 1\n");
	completarTipoNumerico();
	cant_ctes=cantidadTokens;	
}

lista_declaraciones: lista_declaraciones COMMA declaracion {	printf("Regla 2\n");} 
| declaracion {	printf("Regla 3\n");}

declaracion: SBRA_O lista_tipos SBRA_C COLON SBRA_O lista_ids SBRA_C  
{ 	acomodarPunterosTS(); 
	printf("definicion OK\n\n");
}

lista_tipos: lista_tipos COMMA tipo { printf("Regla 5\n");} 
| tipo {printf("Regla 6\n");}

tipo: 
INTEGER  
{ 
	guardarTipo("Integer");
	guardarEnVectorTablaSimbolos(1,tipoVariableActual);
	printf("Regla 9\n");
}
| FLOAT  
{
	guardarTipo("Float");
	guardarEnVectorTablaSimbolos(1,tipoVariableActual);
	printf("Regla 10\n");
}
| STRING 
{
	guardarTipo("String");
	guardarEnVectorTablaSimbolos(1,tipoVariableActual);
	printf("Regla 11\n");
}

lista_ids: 
lista_ids COMMA  ID 
{
	printf("%s\n", yylval.str_val);
	guardarEnVectorTablaSimbolos(2,yylval.str_val);
	printf("Regla 8\n");
}
| ID 
{
	printf("%s\n", yylval.str_val);
	guardarEnVectorTablaSimbolos(2,yylval.str_val);
	printf("Regla 7\n");
}

bloque: bloque sentencia {printf("Regla 13\n");}
| sentencia {printf("Regla 12\n");}

sentencia : asignacion 	{printf("Regla 15\n");}
| seleccion 	{printf("Regla 16\n");}
| asignacion_multiple 	{printf("sentencia -> asignacion_multiple OK \n\n");}
| iteracion  		{printf("Regla 17\n");}
| lectura 			{printf("Regla 19\n");}
| impresion 			{printf("Regla 18\n");}

lectura: READ ID 	
{ 
	strcpy(idAux,yylval.str_val);	 
	if(strcmp(validaTipo(idAux),idAux)!=0)				// verifico contra la TS si la variable existe
	{
		crear_terceto("READ",idAux,"_");
		printf("Regla 52\n");
	}
	else{
		sprintf(mensajeDeError, "La Variable: %s No esta definida", idAux);
		mostrarError(mensajeDeError);
	}
}

impresion: PRINT CTE_S  
{ 
	strcpy(idAux,yylval.str_val);
	agregarConstante(yylval.str_val,CteString,constanteString);
	
	printf("Regla 52\n");
	strcpy(bufferaux1,"_");
	strcat(bufferaux1,idAux);

	crear_terceto("PRINT",bufferaux1,"_");
	
}
| PRINT ID  
{
	strcpy(idAux,yylval.str_val);
	if(strcmp(validaTipo(idAux),"Integer")==0||strcmp(validaTipo(idAux),"Float")==0)
	{ 
		printf("Regla 51\n");
		crear_terceto("PRINT",idAux,"_");}
	else 
	{
		sprintf(mensajeDeError, "La Variable: %s No es de tipo numerico.\n", idAux);
		mostrarError(mensajeDeError);
	}
}

iteracion: REPEAT 
{
	int indice_terceto = obtenerIndiceTercetos();
	apilar(&pilaRepeat,indice_terceto);
	auxRepeat=indice_terceto;
	
}	bloque UNTIL condicion SCOLON
{
	printf("Regla 50\n");
}

asignacion: ID {strcpy(idAux,yylval.str_val);} ASSIG expresion SCOLON				// operador_asignacion -> :=
{
	printf("asignacion OK\n\n");
	aux=desapilar(&pilaOperacion);
	if(strcmp(vector_operacion[aux].tipo,validaTipo(idAux))==0)
	{	E_ind = desapilar(&pilaExpresion);
		itoa(E_ind,conversionItoA,10);
		ASIG_ind = crear_terceto("=",idAux,conversionItoA);
	}
	else
	{
		sprintf(mensajeDeError, "La Variable: %s No es de tipo %s.\n", idAux, vector_operacion[aux].tipo);
		mostrarError(mensajeDeError);
	}
}

expresion:  expresion PLUS termino	
{
	printf("Regla 23\n");

	aux=desapilar(&pilaOperacion);
	aux1=desapilar(&pilaOperacion);
	if(strcmp(vector_operacion[aux].tipo,vector_operacion[aux1].tipo)==0)
	{		
		itoa(desapilar(&pilaExpresion),bufferaux1,10);
		itoa(desapilar(&pilaTermino),bufferaux2,10);
		E_ind = crear_terceto("+",bufferaux1,bufferaux2 );
		apilar(&pilaExpresion,E_ind);
		apilar(&pilaOperacion,aux);
		
		strcpy(bufferaux1,aux_assembler);							// copio @aux
		itoa(E_ind,bufferaux2,10);									// transformo el nro de terceto
		strcat(bufferaux1,bufferaux2);								// creo la variable aux de assembler
		strcpy(vector_tercetos[E_ind].resultado_aux,bufferaux1);	// guardo junto al terceto
		agregarAuxAssembler(bufferaux1);							// agrego a TS
		
	}
	else
	{	sprintf(mensajeDeError, "Incompatibilidad de tipos de variables en la suma\n");
		mostrarError(mensajeDeError);
	}

} 
| expresion DASH termino 	
{
	printf("Regla 22\n");
	aux=desapilar(&pilaOperacion);
	aux1=desapilar(&pilaOperacion);	
	if(strcmp(vector_operacion[aux].tipo,vector_operacion[aux1].tipo)==0)
	{
		itoa(desapilar(&pilaExpresion),bufferaux1,10);
		itoa(desapilar(&pilaTermino),bufferaux2,10);
		E_ind = crear_terceto("-",bufferaux1,bufferaux2 );
		apilar(&pilaExpresion,E_ind);
		apilar(&pilaOperacion,aux);
		
		strcpy(bufferaux1,aux_assembler);							// copio @aux
		itoa(E_ind,bufferaux2,10);									// transformo el nro de terceto
		strcat(bufferaux1,bufferaux2);								// creo la variable aux de assembler
		strcpy(vector_tercetos[E_ind].resultado_aux,bufferaux1);	// guardo junto al terceto
		agregarAuxAssembler(bufferaux1);							// agrego a TS
	}
	else
	{
		sprintf(mensajeDeError, "Incompatibilidad de tipos de variables en la resta\n");
		mostrarError(mensajeDeError);
	}
}

| termino							
{
	printf("Regla 21\n");
	E_ind = desapilar(&pilaTermino);
	apilar(&pilaExpresion,E_ind);
}

termino: termino STAR factor 
{
	printf("Regla 26\n");
	aux=desapilar(&pilaOperacion);
	aux1=desapilar(&pilaOperacion);
	if(strcmp(vector_operacion[aux].tipo,vector_operacion[aux1].tipo)==0)
	{
		itoa(desapilar(&pilaTermino),bufferaux1,10);
		itoa(desapilar(&pilaFactor),bufferaux2,10);
		T_ind=crear_terceto("*",bufferaux1,bufferaux2);
		apilar(&pilaTermino,T_ind);
		apilar(&pilaOperacion,aux);
		
		strcpy(bufferaux1,aux_assembler);							// copio @aux
		itoa(T_ind,bufferaux2,10);									// transformo el nro de terceto
		strcat(bufferaux1,bufferaux2);								// creo la variable aux de assembler
		strcpy(vector_tercetos[T_ind].resultado_aux,bufferaux1);	// guardo junto al terceto
		agregarAuxAssembler(bufferaux1);							// agrego a TS
	} 
	else
	{
		sprintf(mensajeDeError, "Incompatibilidad de tipos de variables en la multiplicacion\n");
		mostrarError(mensajeDeError);
	}
}
| 			termino SLASH factor 	
{
	printf("Regla 27\n");
	aux=desapilar(&pilaOperacion);
	aux1=desapilar(&pilaOperacion);
	if(strcmp(vector_operacion[aux].tipo,vector_operacion[aux1].tipo)==0)
	{
		itoa(desapilar(&pilaTermino),bufferaux1,10);
		itoa(desapilar(&pilaFactor),bufferaux2,10);
		T_ind=crear_terceto("/",bufferaux1,bufferaux2);
		apilar(&pilaTermino,T_ind);
		apilar(&pilaOperacion,aux);
		
		strcpy(bufferaux1,aux_assembler);							// copio @aux
		itoa(T_ind,bufferaux2,10);									// transformo el nro de terceto
		strcat(bufferaux1,bufferaux2);								// creo la variable aux de assembler
		strcpy(vector_tercetos[T_ind].resultado_aux,bufferaux1);	// guardo junto al terceto
		agregarAuxAssembler(bufferaux1);							// agrego a TS
	}
	else
	{
		sprintf(mensajeDeError, "Incompatibilidad de tipos de variables en la division\n");
		mostrarError(mensajeDeError);
	}
}

| factor			
{
	printf("Regla 25\n");
	T_ind = desapilar(&pilaFactor);
	apilar(&pilaTermino,T_ind);
}

factor: ID  {
	int aux_tiponumerico = obteneraux_tiponumerico();
	printf("Regla 28\n");
	strcpy(vector_operacion[cantOperaciones].id,yylval.str_val);
	strcpy(vector_operacion[cantOperaciones].tipo,validaTipo(yylval.str_val));
	vector_operacion[cantOperaciones].tipoNumerico = aux_tiponumerico;
	//printf("ID %s\n",vector_operacion[cantOperaciones].id);
	//printf("TIPO %s\n",vector_operacion[cantOperaciones].tipo);
	//printf("TIPO_NUMERICO %d\n",vector_operacion[cantOperaciones].tipoNumerico);
	apilar(&pilaOperacion,cantOperaciones);
	cantOperaciones++;
	F_ind = crear_terceto(yylval.str_val,"_","_");
	apilar(&pilaFactor,F_ind);
}

| CTE_I 	
{
	printf("Regla 29\n");
	agregarConstante(yylval.str_val,CteInt,constanteEntera);
	strcpy(constanteAux,"_");
	strcat(constanteAux,yylval.str_val);
	strcpy(constanteAux + strlen(constanteAux), "\0");
	strcpy(vector_operacion[cantOperaciones].id,constanteAux);
	strcpy(vector_operacion[cantOperaciones].tipo,"Integer");
	vector_operacion[cantOperaciones].tipoNumerico = 4;
	//printf("ID %s\n",vector_operacion[cantOperaciones].id);
	//printf("TIPO %s\n",vector_operacion[cantOperaciones].tipo);
	apilar(&pilaOperacion,cantOperaciones);
	cantOperaciones++;
	F_ind = crear_terceto(constanteAux,"_","_");
	apilar(&pilaFactor,F_ind);
}
| CTE_F		
{
	printf("factor -> Cte_Real OK\n\n");
	agregarConstante(yylval.str_val,CteReal,constanteFloat);
	strcpy(constanteAux,"_");
	strcat(constanteAux,yylval.str_val);
	strcpy(constanteAux + strlen(constanteAux), "\0");
	strcpy(vector_operacion[cantOperaciones].id,constanteAux);
	strcpy(vector_operacion[cantOperaciones].tipo,"Float");
	vector_operacion[cantOperaciones].tipoNumerico = 5;
	//printf("ID %s\n",vector_operacion[cantOperaciones].id);
	//printf("TIPO %s\n",vector_operacion[cantOperaciones].tipo);
	apilar(&pilaOperacion,cantOperaciones);
	cantOperaciones++;
	
	replace_char(constanteAux,'.', '_');
	F_ind = crear_terceto(constanteAux,"_","_");
	apilar(&pilaFactor,F_ind);
}
| CTE_S 
{

	agregarConstante(yylval.str_val,CteString,constanteString);
	strcpy(constanteAux,"_");
	strcat(constanteAux,yylval.str_val);
	strcpy(constanteAux + strlen(constanteAux), "\0");
	strcpy(vector_operacion[cantOperaciones].id,constanteAux);
	strcpy(vector_operacion[cantOperaciones].tipo,"String");
	vector_operacion[cantOperaciones].tipoNumerico = 6;
	apilar(&pilaOperacion,cantOperaciones);
	cantOperaciones++;
	F_ind = crear_terceto(constanteAux,"_","_");
	apilar(&pilaFactor,F_ind);
}

| BRA_O expresion BRA_C
{
	printf("Regla 31\n");
	F_ind = desapilar(&pilaExpresion);
	apilar(&pilaFactor,F_ind);
}

seleccion: ifelse {printf("Regla 39\n");}

ifelse: IF BRA_O comparacion {apilar(&pilaIf,aux);} BRA_C bloque ENDIF 	
{
	int indice_terceto = obtenerIndiceTercetos();
	aux=desapilar(&pilaIf);
	itoa(indice_terceto,bufferaux1,10);					
	strcpy(vector_tercetos[aux].te1,bufferaux1);		// desapilo y voy al final
}

| IF BRA_O comparacion {apilar(&pilaIf,aux);} AND comparacion {apilar(&pilaIf,aux);} BRA_C bloque ENDIF
{
	int indice_terceto = obtenerIndiceTercetos();
	aux=desapilar(&pilaIf);
	itoa(indice_terceto,bufferaux1,10);					// desapilo y pongo donde voy en la segunda cond - voy al final
	strcpy(vector_tercetos[aux].te1,bufferaux1);
	aux=desapilar(&pilaIf);
	itoa(indice_terceto,bufferaux1,10);					// desapilo y pongo donde voy en la primer cond - voy al final
	strcpy(vector_tercetos[aux].te1,bufferaux1);
}

|	IF BRA_O comparacion {apilar(&pilaIf,aux); apilar(&pilaIf,crear_terceto("JMP","_","_"));} OR comparacion {apilar(&pilaIf,aux);} BRA_C {int indice_terceto = obtenerIndiceTercetos(); aux1=indice_terceto;} bloque ENDIF
{
	int indice_terceto = obtenerIndiceTercetos();
	aux=desapilar(&pilaIf);
	itoa(indice_terceto,bufferaux1,10);					//	desapilo y pongo donde salto con la segunda cond - voy al final
	strcpy(vector_tercetos[aux].te1,bufferaux1);
	aux=desapilar(&pilaIf);
	itoa(aux1,bufferaux1,10);						// desapilo y pongo donde voy con el JMP
	strcpy(vector_tercetos[aux].te1,bufferaux1);
	aux=desapilar(&pilaIf);
	itoa(aux+2,bufferaux1,10);							// desapilo y pongo donde voy si la primer condicion es falsa
	strcpy(vector_tercetos[aux].te1,bufferaux1);
}

| IF IF BRA_O comparacion {apilar(&pilaIf,aux);} BRA_C THEN bloque {
	int indice_terceto = obtenerIndiceTercetos();
	crear_terceto("JMP","_","_");			
	aux=desapilar(&pilaIf);
	itoa(indice_terceto,bufferaux1,10);					// paso a char[] el valor indice
	strcpy(vector_tercetos[aux].te1,bufferaux1);		// asigno el lugar donde salto
	apilar(&pilaIf,indice_terceto-1);
}	ELSE bloque ENDIF 
{
	int indice_terceto = obtenerIndiceTercetos();
	printf("Regla 40\n");
	aux=desapilar(&pilaIf);
	itoa(indice_terceto,bufferaux1,10);					// paso a char[] el valor indice
	strcpy(vector_tercetos[aux].te1,bufferaux1);		// asigno el lugar donde salto
}

|	IF IF BRA_O comparacion {apilar(&pilaIf,aux);} AND comparacion {apilar(&pilaIf,aux);} BRA_C THEN bloque
{
	int indice_terceto = obtenerIndiceTercetos();
	aux=crear_terceto("JMP","_","_");			// guardo el numero de terceto donde voy a poner el salto desde el fin del THEN al FINAL
	aux1=desapilar(&pilaIf);
	itoa(indice_terceto,bufferaux1,10);					// paso a char[] el valor indice
	strcpy(vector_tercetos[aux1].te1,bufferaux1);		// SALTO AL PRINCIPIO DEL ELSE
	aux1=desapilar(&pilaIf);
	itoa(indice_terceto,bufferaux1,10);					// paso a char[] el valor indice
	strcpy(vector_tercetos[aux1].te1,bufferaux1);		// SALTO AL PRINCIPIO DEL ELSE
	apilar(&pilaIf,aux);											// apilo el terceto que salta al final del THEN
}
ELSE bloque ENDIF 	
{
	int indice_terceto = obtenerIndiceTercetos();
	printf("Regla 41\n");
	aux=desapilar(&pilaIf);
	itoa(indice_terceto,bufferaux1,10);					// paso a char[] el valor indice
	strcpy(vector_tercetos[aux].te1,bufferaux1);		// SALTO AL FINAL DEL ELSE
	
}			

|	IF IF BRA_O comparacion {apilar(&pilaIf,aux); apilar(&pilaIf,crear_terceto("JMP","_","_"));} OR comparacion {apilar(&pilaIf,aux);} BRA_C {int indice_terceto = obtenerIndiceTercetos(); aux1=indice_terceto;} 
THEN bloque {apilar(&pilaIf,crear_terceto("JMP","_","_"));} ELSE bloque ENDIF
{
	int indice_terceto = obtenerIndiceTercetos();
	aux=desapilar(&pilaIf);								// cargo el salto al final cuando termina el THEN
	itoa(indice_terceto,bufferaux1,10);
	strcpy(vector_tercetos[aux].te1,bufferaux1);
	aux2 = aux+1;										// cargo la posicion donde empieza el ELSE
	aux=desapilar(&pilaIf);
	itoa(aux2,bufferaux1,10);					//	desapilo y pongo donde salto con la segunda cond - voy al ELSE
	strcpy(vector_tercetos[aux].te1,bufferaux1);
	aux=desapilar(&pilaIf);
	itoa(aux1,bufferaux1,10);						// desapilo y pongo donde voy con el JMP - en el aux1 tengo la posicion donde empieza el THEN
	strcpy(vector_tercetos[aux].te1,bufferaux1);
	aux=desapilar(&pilaIf);
	itoa(aux+2,bufferaux1,10);							// desapilo y pongo donde voy si la primer condicion es falsa
	strcpy(vector_tercetos[aux].te1,bufferaux1);
}


condicion:   BRA_O comparacion BRA_C 
{
	int indice_terceto = obtenerIndiceTercetos();
	aux=desapilar(&pilaRepeat);
	itoa(aux,bufferaux1,10);							// desapilo y pongo donde voy si la condicion es verdadera
	strcpy(vector_tercetos[indice_terceto-1].te1,bufferaux1);
	vector_tercetos[auxRepeat].esEtiqueta=99;

}
|	BRA_O comparacion {apilar(&pilaRepeat,aux);} AND comparacion {apilar(&pilaRepeat,aux);} BRA_C 
{
	int indice_terceto = obtenerIndiceTercetos();
	aux=crear_terceto("JMP","_","_");
	aux2=desapilar(&pilaRepeat);
	itoa(indice_terceto,bufferaux1,10);		
	strcpy(vector_tercetos[aux2].te1,bufferaux1);
	aux2=desapilar(&pilaRepeat);
	itoa(indice_terceto,bufferaux1,10);		
	strcpy(vector_tercetos[aux2].te1,bufferaux1);
	aux2=desapilar(&pilaRepeat);
	itoa(aux2,bufferaux1,10);		
	strcpy(vector_tercetos[aux].te1,bufferaux1);
	vector_tercetos[auxRepeat].esEtiqueta=99;

}

| BRA_O comparacion {
	apilar(&pilaRepeat,aux);
	char posInicial[10];
	itoa(auxRepeat, posInicial,10);
	aux=crear_terceto("JMP",posInicial,"_");
}	OR comparacion {apilar(&pilaRepeat,aux);} BRA_C {

	int indice_terceto = obtenerIndiceTercetos();

	char posInicial[10];
	itoa(auxRepeat, posInicial,10);
	aux=crear_terceto("JMP",posInicial,"_");

	aux2=desapilar(&pilaRepeat);
	printf("aux2: %d\n",aux);
	itoa(indice_terceto,bufferaux1,10);		
	strcpy(vector_tercetos[aux2].te1,bufferaux1);
	aux2=desapilar(&pilaRepeat);
	itoa(aux2+2,bufferaux1,10);		
	strcpy(vector_tercetos[aux2].te1,bufferaux1);
	vector_tercetos[auxRepeat].esEtiqueta=99;
}
| BRA_O NOT BRA_O comparacion BRA_C BRA_C 
{
	int indice_terceto = obtenerIndiceTercetos();
	invertir_salto(vector_tercetos, aux);
	aux=desapilar(&pilaRepeat);
	itoa(aux,bufferaux1,10);							// desapilo y pongo donde voy si la primer condicion es falsa
	strcpy(vector_tercetos[indice_terceto-1].te1,bufferaux1);
	vector_tercetos[auxRepeat].esEtiqueta=99;
}


comparacion : expresion {aux_ladoIzquierdo_comparacion = desapilar(&pilaOperacion);} GT expresion {aux_ladoDerecho_comparacion = desapilar(&pilaOperacion);}
{

	if(strcmp(vector_operacion[aux_ladoIzquierdo_comparacion].tipo,vector_operacion[aux_ladoDerecho_comparacion].tipo)==0)
	{
		ladoDerecho = desapilar(&pilaExpresion);
		ladoIzquierdo = desapilar(&pilaExpresion);
		itoa(ladoIzquierdo,bufferaux1,10);
		itoa(ladoDerecho,bufferaux2,10);
		crear_terceto("CMP",bufferaux1,bufferaux2);
		aux = crear_terceto("JNA","_","_");							// pongo en aux el numero de terceto donde usaria el salto
	}
	else
	{
		sprintf(mensajeDeError, "Incompatibilidad de tipos de variables en operador comparacion MAYOR\n");
		mostrarError(mensajeDeError);
	}
}
| expresion {aux_ladoIzquierdo_comparacion = desapilar(&pilaOperacion);} LT expresion {aux_ladoDerecho_comparacion = desapilar(&pilaOperacion);}
{
	if(strcmp(vector_operacion[aux_ladoIzquierdo_comparacion].tipo,vector_operacion[aux_ladoDerecho_comparacion].tipo)==0)
	{
		ladoDerecho = desapilar(&pilaExpresion);
		ladoIzquierdo = desapilar(&pilaExpresion);
		itoa(ladoIzquierdo,bufferaux1,10);
		itoa(ladoDerecho,bufferaux2,10);
		crear_terceto("CMP",bufferaux1,bufferaux2);
		aux = crear_terceto("JAE","_","_");		
	}
	else
	{
		sprintf(mensajeDeError, "Incompatibilidad de tipos de variables en operador comparacion MENOR\n");
		mostrarError(mensajeDeError);
	}
}

| expresion {aux_ladoIzquierdo_comparacion = desapilar(&pilaOperacion);} GE expresion {aux_ladoDerecho_comparacion = desapilar(&pilaOperacion);}
{
	if(strcmp(vector_operacion[aux_ladoIzquierdo_comparacion].tipo,vector_operacion[aux_ladoDerecho_comparacion].tipo)==0)
	{
		ladoDerecho = desapilar(&pilaExpresion);
		ladoIzquierdo = desapilar(&pilaExpresion);
		itoa(ladoIzquierdo,bufferaux1,10);
		itoa(ladoDerecho,bufferaux2,10);
		crear_terceto("CMP",bufferaux1,bufferaux2);
		aux = crear_terceto("JNAE","_","_");		
	}
	else
	{
		sprintf(mensajeDeError, "Incompatibilidad de tipos de variables en operador comparacion MAYOR O IGUAL\n");
		mostrarError(mensajeDeError);
	}
}

| expresion {aux_ladoIzquierdo_comparacion = desapilar(&pilaOperacion);} LE expresion {aux_ladoDerecho_comparacion = desapilar(&pilaOperacion);}
{
	if(strcmp(vector_operacion[aux_ladoIzquierdo_comparacion].tipo,vector_operacion[aux_ladoDerecho_comparacion].tipo)==0)
	{
		ladoDerecho = desapilar(&pilaExpresion);
		ladoIzquierdo = desapilar(&pilaExpresion);
		itoa(ladoIzquierdo,bufferaux1,10);
		itoa(ladoDerecho,bufferaux2,10);
		crear_terceto("CMP",bufferaux1,bufferaux2);
		aux = crear_terceto("JA","_","_");		
	}
	else
	{
		sprintf(mensajeDeError, "Incompatibilidad de tipos de variables en operador comparacion MENOR O IGUAL\n");
		mostrarError(mensajeDeError);
	}
}

| expresion {aux_ladoIzquierdo_comparacion = desapilar(&pilaOperacion);} EQ expresion {aux_ladoDerecho_comparacion = desapilar(&pilaOperacion);}
{
	if(strcmp(vector_operacion[aux_ladoIzquierdo_comparacion].tipo,vector_operacion[aux_ladoDerecho_comparacion].tipo)==0){
		ladoDerecho = desapilar(&pilaExpresion);
		ladoIzquierdo = desapilar(&pilaExpresion);
		itoa(ladoIzquierdo,bufferaux1,10);
		itoa(ladoDerecho,bufferaux2,10);
		crear_terceto("CMP",bufferaux1,bufferaux2);
		aux = crear_terceto("JNE","_","_");		
	}
	else
	{
		sprintf(mensajeDeError, "Incompatibilidad de tipos de variables en operador comparacion IGUAL\n");
		mostrarError(mensajeDeError);
	}
}
| expresion {aux_ladoIzquierdo_comparacion = desapilar(&pilaOperacion);} NE expresion {aux_ladoDerecho_comparacion = desapilar(&pilaOperacion);}
{
	if(strcmp(vector_operacion[aux_ladoIzquierdo_comparacion].tipo,vector_operacion[aux_ladoDerecho_comparacion].tipo)==0){
		ladoDerecho = desapilar(&pilaExpresion);
		ladoIzquierdo = desapilar(&pilaExpresion);
		itoa(ladoIzquierdo,bufferaux1,10);
		itoa(ladoDerecho,bufferaux2,10);
		crear_terceto("CMP",bufferaux1,bufferaux2);
		aux = crear_terceto("JE","_","_");		
	}
	else
	{
		sprintf(mensajeDeError, "Incompatibilidad de tipos de variables en operador comparacion DISTINTO\n");
		mostrarError(mensajeDeError);
	}
}
|
		funcion	{
			printf("Regla 46\n");
		}

////////********	Asignacion Multiple 	*********////////////

asignacion_multiple: SBRA_O lista_ids_asignMultiple SBRA_C ASSIG SBRA_O lista_expresiones_asignMultiple SBRA_C 
{printf("Regla 36\n");}

lista_ids_asignMultiple: 
lista_ids_asignMultiple COMMA ID {

	//printf("%s\n", yylval.str_val);
	printf("Regla 37\n");
	if(strcmp(yylval.str_val,validaTipo(yylval.str_val))==0){
		//No existe en tabla de simbolo
		printf("No existe en tabla de simbolos \n\n");
	}
	else
	{

		strcpy(vector_asig_multiple[indice_asign_multiple].nombre,yylval.str_val);
		strcpy(vector_asig_multiple[indice_asign_multiple].tipo,validaTipo(yylval.str_val));
		indice_asign_multiple++;

	}
}

| ID {
	//printf("%s\n", yylval.str_val);
	printf("Regla 38\n");

	if(strcmp(yylval.str_val,validaTipo(yylval.str_val))==0){
		//No existe en tabla de simbolos
		printf("No existe en tabla de simbolo \n\n");
	}
	else
	{

		strcpy(vector_asig_multiple[indice_asign_multiple].nombre,yylval.str_val);
		strcpy(vector_asig_multiple[indice_asign_multiple].tipo,validaTipo(yylval.str_val));
		indice_asign_multiple++;

	}	
}

lista_expresiones_asignMultiple : lista_expresiones_asignMultiple COMMA expresion_asignMultiple
| expresion_asignMultiple

expresion_asignMultiple: termino_asignMultiple	{
	printf("expresion_asignMultiple -> termino_asignMultiple OK \n\n");
}

termino_asignMultiple: factor_asignMultiple{
	printf("termino_asignMultiple -> factor_asignMultiple OK \n\n");
}

factor_asignMultiple: ID 
| CTE_I 
{	
	printf("factor_asignMultiple -> Cte_entera OK\n\n");

	if(indice_expresiones_asign_multiple < indice_asign_multiple)
	{
		if(strcmp(vector_asig_multiple[indice_expresiones_asign_multiple].tipo,"Integer") == 0)
		{	
			agregarConstante(yylval.str_val,CteInt,constanteEntera);
			strcpy(constanteAux,"_");
			strcat(constanteAux,yylval.str_val);
			strcpy(constanteAux + strlen(constanteAux), "\0");
			crear_terceto("=",vector_asig_multiple[indice_expresiones_asign_multiple].nombre,constanteAux);
			indice_expresiones_asign_multiple++;
		}
		else
		{
			sprintf(mensajeDeError, "La Variable: %s No es de tipo entero.\n", vector_asig_multiple[indice_expresiones_asign_multiple].nombre);
			mostrarError(mensajeDeError);

		}

	}

}
| CTE_F 
{
	printf("factor_asignMultiple -> Cte_Real OK\n\n");
	if(indice_expresiones_asign_multiple < indice_asign_multiple)
	{
		if(strcmp(vector_asig_multiple[indice_expresiones_asign_multiple].tipo,"Float") == 0)
		{	
			agregarConstante(yylval.str_val,CteReal,constanteFloat);
			strcpy(constanteAux,"_");
			strcat(constanteAux,yylval.str_val);
			strcpy(constanteAux + strlen(constanteAux), "\0");
			crear_terceto("=",vector_asig_multiple[indice_expresiones_asign_multiple].nombre,constanteAux);
			indice_expresiones_asign_multiple++;
		}
		else
		{
			sprintf(mensajeDeError, "La Variable: %s No es de tipo real.\n", vector_asig_multiple[indice_expresiones_asign_multiple].nombre);
			mostrarError(mensajeDeError);
		}

	}
};

funcion:
		BRA_O inlist BRA_C {
			// int idx = -1;
			// int idx_jmp= -1;
			// while(!pila_vacia(&pila_saltos)) {
			// 	idx_jmp = sacar_pila(&pila_saltos);

			// 	/*
			// 	 * - Si se cumple por verdadero, salto al terceto actual - 2
			// 	 * - si se cumple por falso, salto al siguiente terceto de comparacion
			// 	 */
			// 	if (strcmp(tercetos[idx_jmp]->t1, saltos[tsJE]) == 0) {
			// 		strcpy(tercetos[idx_jmp]->t2, intToStr($2));
			// 	} else {
			// 		strcpy(tercetos[idx_jmp]->t2, intToStr(idx_jmp + 2));
			// 	}
			// }

			// $$ = $2;
			printf("Regla 53\n");
		};

inlist:
		INLIST BRA_O ID COMMA SBRA_O lista_expresiones_scolon SBRA_C BRA_C {
			// int idx = -1;
			// int idx_exp = -1;
			// while(!pila_vacia(&pila_exp)) {
			// 	idx_exp = sacar_pila(&pila_exp);

			// 	/*
			// 	 * Creo un terceto de comparacion y dos tercetos de salto
			// 	 *  n-2 (CMP, ID, EXPRESION)
			// 	 * 	n-1 (JNE, n-2, NULL) -> completar
			// 	 * 	n   (JE, n-1, NULL) -> completar
			// 	 */
			// 	int cmp = crear_terceto("CMP", $3, intToStr(idx_exp));

			// 	idx = crear_terceto(saltos[tsJNE], NULL, NULL);
			// 	insertar_pila(&pila_saltos, idx);

			// 	idx = crear_terceto(saltos[tsJE], NULL, NULL);
			// 	insertar_pila(&pila_saltos, idx);
			// }

			// /*
			//  * Creo una variable de apoyo con falso
			//  * Si no se encuentra el valor en la lista
			//  * saltará a este terceto.
			//  * debe guardarse en la tabla de simbolos
			//  */
			// char aux[20];
			// sprintf(aux, "_INLIST_%d", ++cantidadInlist);

			// /* terceto resultado falso */
			// idx = crear_terceto(":=", aux, "false");

			// /* salteo un terceto */
			// idx = crear_terceto(saltos[tsJMP], NULL , intToStr(idx + 2));

			// /* terceto resultado verdadero */
			// idx = crear_terceto(":=", aux, "true");

			// // devuelvo el ultimo terceto creado */
			// $$ = idx;
			printf("Regla 54\n");
		};

lista_expresiones_scolon:
		expresion {
			// insertar_pila(&pila_exp, $1);
			// $$ = $1;
			printf("Regla 55\n");
		}
	|	lista_expresiones_scolon SCOLON expresion	{
			// insertar_pila(&pila_exp, $3);
			// $$ = $3;
			printf("Regla 56\n");
		}
	;


%%

int main(int argc,char *argv[]){

	if ((yyin = fopen(argv[1], "rt")) == NULL){
		printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
	}else {

		// inicializo las pilas
		pilaExpresion = crearPila();
		pilaTermino	= crearPila();
		pilaTercetoActual = crearPila();
		pilaFactor = crearPila();
		pilaIf = crearPila();
		pilaRepeat = crearPila();
		pilaOperacion = crearPila();
		pilaFilter = crearPila();

		yyparse();

		guardarTablaDeSimbolos(cantidadTokens, cant_ctes);					// archivos de tabla de simbolos
		escribir_tercetos();		// archivo del codigo intermedio -> tercetos
		preparar_assembler();			// arreglo el vector_tercetos
		escribir_assembler(cant_ctes);			// escribo archivo del codigo assembler
	}
	
	fclose(yyin);
	return 0;
}

void mostrarError(char *mensaje) {
	printf("%s\n", mensaje);
	yyerror();
}

int yyerror(void){
	printf("Syntax Error.\nLinea: %d\nToken: %s\n\n\n", yylineno, yytext);
	system ("Pause");
	exit (1);
}

void guardarEnVectorTablaSimbolos(int opc, char * cad){								// si mando 1 guardo el tipo, sino guardo el nombre
	if(finBloqueDeclaraciones==0){
		if(opc==1){
			strcpy(tablaDeSimbolos[pos_td].tipo,cad);
			cant_tipo_dato++;
			pos_td++;
		}
		else
		{
			strcpy(tablaDeSimbolos[pos_cv].nombre,cad);
			pos_cv++;
			cant_variables++;
		}
	}
}

void guardarTipo(char * tipoVariable) {
	strcpy(tipoVariableActual, tipoVariable);
}

void acomodarPunterosTS(){
	int indice=0;
	if(cant_tipo_dato!=cant_variables){
		if(pos_td<pos_cv){	
			min=pos_td;
			cant_elementos=min;
			pos_td=pos_cv=min;
			diferencia=(cant_variables-cant_tipo_dato);
			indice=min;
			while(diferencia>0){
				strcpy(tablaDeSimbolos[indice].tipo, "");
				strcpy(tablaDeSimbolos[indice].nombre, "");
				diferencia--;
				indice++;
			}
		}
		else
		{
			min=pos_cv;
			cant_elementos=min;
			pos_td=pos_cv=min;
			diferencia=(cant_tipo_dato-cant_variables);
			indice=min;
			while(diferencia>0){
				strcpy(tablaDeSimbolos[indice].tipo, "");
				strcpy(tablaDeSimbolos[indice].nombre, "");
				diferencia--;
				indice++;
			}
		}
	}
	else
	{
		cant_elementos=pos_cv;
		cant_tipo_dato=cant_variables=0;
	}
}

void quitarDuplicados(){
	for(i=0;i<cant_elementos;i++){
		if(strcmp(tablaDeSimbolos[i].nombre,"@")!=0){
			cantidadTokens++;
			for(j=i+1;j<cant_elementos;j++){
				if(strcmp(tablaDeSimbolos[i].tipo,tablaDeSimbolos[j].tipo)==0 && strcmp(tablaDeSimbolos[i].nombre,tablaDeSimbolos[j].nombre)==0){		// si los dos son iguales
					strcpy(tablaDeSimbolos[j].tipo, "@");
					strcpy(tablaDeSimbolos[j].nombre, "@");				// doy de baja a todos los proximos que son iguales
				}
			}
		}
		else
		{
			j=i+1;
			while(j<cant_elementos && strcmp(tablaDeSimbolos[j].tipo,"@")==0)
			j++;
			if(j<cant_elementos){
				strcpy(tablaDeSimbolos[i].nombre,tablaDeSimbolos[j].nombre);
				strcpy(tablaDeSimbolos[i].tipo,tablaDeSimbolos[j].tipo);
				i--;
			}
			else
			{
				i=cant_elementos;
			}

		}
	}
}

/* Agregar una constante a la tabla de simbolos */

void agregarConstante(char* nombre,char* tipo, int tipo_numerico) {
	// printf("Agregar cte %s: %s .\n\n",nombre, tipo);
	
	// Formateo la cadena
	int length = strlen(nombre);

	char nombre_nuevo[length];

	strcpy(nombre_nuevo, "_");
	strcat(nombre_nuevo, nombre);

	strcpy(nombre_nuevo + strlen(nombre_nuevo), "\0");

	// Verificamos si ya esta cargada
	if (buscarCte(nombre_nuevo, tipo) == 0) {

		// Agrego nombre a la tabla
		strcpy(tablaDeSimbolos[cant_ctes].nombre, nombre_nuevo);

		// Agrego el tipo (Se utiliza para imprimir tabla)
		strcpy(tablaDeSimbolos[cant_ctes].tipo, tipo);

		// Agrego el tipo numerico para comparaciones mas sencillas 
		tablaDeSimbolos[cant_ctes].TipodeDato_numerico = tipo_numerico;

		// Agrego valor
		strcpy(tablaDeSimbolos[cant_ctes].valor, nombre_nuevo+1);		// Omito el _

		// Agrego la longitud
		if(strcmp(tipo, CteString)==0){
			tablaDeSimbolos[cant_ctes].longitud = length;
		}
		cant_ctes++;
		// printf("AGREGO A LA TABLA: %s\n", nombre_nuevo);
	}
}

int buscarCte(char* nombre, char* tipo){			//return 1 = ya esta, return 0 = no esta , cad1 es nombre a buscar cad2 es el tipo 
	int i = cantidadTokens;
	for( i ; i < cant_ctes ; i++){
		if(strcmp(tablaDeSimbolos[i].nombre, nombre)==0 
				&& strcmp(tablaDeSimbolos[i].tipo,tipo)==0){
			printf("%s DUPLICADA\n\n", tipo);
			return 1;
		}
	}
	return 0;
}

void validarVariableDeclarada(char* nombre){
	int i;
	for(i=0 ; i< cantidadTokens; i++){
		if(strcmp(tablaDeSimbolos[i].nombre,nombre)==0)
		return;

	}
	sprintf(mensajeDeError, "La Variable: %s - No esta declarada.\n", nombre);
	mostrarError(mensajeDeError);	
}

char* validaTipo(char* id)
{
	int i;
	for(i=0;i<cant_ctes;i++)
	{		
		if(strcmp(id,tablaDeSimbolos[i].nombre)==0)
		{		
			aux_tiponumerico = tablaDeSimbolos[i].TipodeDato_numerico;			// guardo en la variable global aux de tipo numerico, el tipo de la variable encontrada
			return tablaDeSimbolos[i].tipo;
		}
	}

	return id;
}
void invertir_salto(terceto* vector, int indice){

	printf("invertir el salto: %s\n", vector[indice].ope);
	if(strcmp(vector[indice].ope,"JE")==0){
		strcpy(vector[indice].ope,"JNE");
		return;
	}
	if(strcmp(vector[indice].ope,"JNE")==0){
		strcpy(vector[indice].ope,"JE");
		return;
	}
	if(strcmp(vector[indice].ope,"JNAE")==0){
		strcpy(vector[indice].ope,"JAE");
		return;
	}
	if(strcmp(vector[indice].ope,"JAE")==0){
		strcpy(vector[indice].ope,"JNAE");
		return;
	}
	if(strcmp(vector[indice].ope,"JA")==0){
		strcpy(vector[indice].ope,"JNA");
		return;
	}
	if(strcmp(vector[indice].ope,"JNA")==0){
		strcpy(vector[indice].ope,"JA");
		return;
	}
}

void completarTipoNumerico()
{
	int i;
	for(i=0;i<cantidadTokens;i++)
	{		
		if(strcmp(tablaDeSimbolos[i].tipo,"Integer")==0)
		{		
			tablaDeSimbolos[i].TipodeDato_numerico = variableEntera;
		}
		if(strcmp(tablaDeSimbolos[i].tipo,"Float")==0)
		{		
			tablaDeSimbolos[i].TipodeDato_numerico = variableFloat;
		}
		if(strcmp(tablaDeSimbolos[i].tipo,"String")==0)
		{		
			tablaDeSimbolos[i].TipodeDato_numerico = variableString;
		}
	}

}

void agregarAuxAssembler(char* var_aux)
{
	strcpy(tablaDeSimbolos[cant_ctes].nombre,var_aux);
	cant_ctes++;
}

void replace_char(char* str, char find, char replace){
	char *current_pos = strchr(str,find);
	while (current_pos){
		*current_pos = replace;
		current_pos = strchr(current_pos,find);
	}
}
