
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if defined(__APPLE__) || defined(__linux__)
	#include <curses.h>
#elif defined(_WIN32)
	#include <conio.h>
#else
	#error "OS not suported"
#endif

#include "y.tab.h"

#include "lib/const.h"
#include "lib/tabla.h"
#include "lib/pila.h"
#include "lib/tercetos.h"
#include "lib/assembler.h"
#include "lib/utils.h"

int yystopparser=0;
FILE  *yyin;
char *yytext;
int yylineno;
int cantidadTiposId = 0;
int cantidadIds = 0;
char listaTiposId[MAX_SIM][MAX_TYPE];
char listaIds[MAX_SIM][MAX_ID];
int cantidadRepeat = 0;

void guardarTipoId(const char*);
void guardarId(char*);
int esIdDeclarado(char*);
void asignarTipoIds();
void tercetosIfThen(int);
int yylex();
int yyerror();

// MENSAJES
void success();

/* apunta al ultimo elemento terceto de salto */
t_pila pila;
/* Apila los tipos de condicion (and, or, not) cuando hay anidamiento */
t_pila pila_operador_logico;
/* Apila los ids en declaraciones y en asignaciones multiples */
t_pila pila_ids;
/* Apila las expresiones del lado derecho en asignaciones multiples */
t_pila pila_asig_mult_exp;
/* Apila etiquetas para el bloque repeat */
t_pila pila_repeat_etiq;

%}

/*
	Estructura de yylval.
	los tipos <entero> y <real> deben anteponerse
	a los tokens de los cuales queremos obtener el valor
	Ahora el valor del lexema reconocido se encuentra en
	$<n> ($1,$2 ... etc) donde cada $<n> es la posicion del
	elemento del lado derecho de la regla gramatical
*/
%union {
	int entero;
	float real;
	char texto[100];
};

%token	<entero> INTEGER
%token	<entero> FLOAT
%token	<entero> STRING
%token	REPEAT
%token	UNTIL
%token	IF
%token	THEN
%token	ELSE
%token	ENDIF
%token	<entero> AND
%token	<entero> OR
%token	<entero> NOT
%token	<texto> PRINT
%token	<texto> READ
%token	VAR
%token	ENDVAR
%token	INLIST

%token	COLON
%token	SCOLON
%token	COMMA
%token	<texto> COMP
%token	<texto> ASSIG
%token	<texto> SLASH
%token	<texto> STAR
%token	<texto> PLUS
%token	<texto> DASH
%token	BRA_O
%token	BRA_C
%token	SBRA_O
%token	SBRA_C
%token	CBRA_O
%token	CBRA_C
%token	<texto> ID
%token	<texto> CTE_S
%token	<texto> CTE_I
%token	<texto> CTE_F

%left	PLUS DASH
%left	STAR SLASH
%right	MENOS_UNARIO

%type <entero> declaracion
%type <entero> bloque
%type <entero> sentencia
%type <entero> expresion
%type <entero> termino
%type <entero> factor
%type <entero> asignacion
%type <entero> asignacion_simple
%type <entero> seleccion
%type <entero> ifelse
%type <entero> condicion
%type <entero> proposicion
%type <entero> comparacion
%type <entero> iteracion
%type <entero> repeat
%type <entero> impresion
%type <entero> lectura
%type <entero> lista_ids
%type <entero> asignacion_multiple
%type <entero> lista_expresiones_comma
%type <entero> lista_expresiones_scolon
%type <entero> inlist
%type <entero> funcion

%start programa

%%
programa: declaraciones bloque
		{
			printf("Regla 0\n");
			success();
		};

declaraciones:
		VAR lista_declaraciones ENDVAR
		{
			asignarTipoIds();
			printf("Regla 1\n");
		};

lista_declaraciones:
		lista_declaraciones COMMA declaracion	{printf("Regla 2\n");}
	|	declaracion 							{printf("Regla 3\n");}
	;

declaracion:
		SBRA_O lista_tipos SBRA_C COLON SBRA_O lista_ids SBRA_C {
			int idx_id = -1;
			int idx_tipo = -1;
			while(!pila_vacia(&pila_ids)) {
				idx_id = sacar_pila(&pila_ids);
				idx_tipo = sacar_pila(&pila);
				strcpy(tercetos[idx_id]->t2, tercetos[idx_id]->t1);
				strcpy(tercetos[idx_id]->t1, tipos[idx_tipo]);
			}
			$$ = $6;
			printf("Regla 4\n");
		}
		;

lista_tipos:
		tipo {printf("Regla 5\n");}
	|	lista_tipos COMMA tipo {
			printf("Regla 6\n");
		}
	;

lista_ids:
		ID {
			guardarId($1);
			int idx = crear_terceto($1, NULL, NULL);
			insertar_pila(&pila_ids, idx);
			$$ = idx;
			printf("Regla 7\n");
		}
	|	lista_ids COMMA ID {
			guardarId($3);
			int idx = crear_terceto($3, NULL, NULL);
			insertar_pila(&pila_ids, idx);
			$$ = idx;
			printf("Regla 8\n");
		}
	;

tipo:
		INTEGER {
			guardarTipoId(tipos[$1]);
			insertar_pila(&pila, $1);
			{printf("Regla 9\n");}
		}
	|	FLOAT {
			guardarTipoId(tipos[$1]);
			insertar_pila(&pila, $1);
			printf("Regla 10\n");
		}
	|	STRING {
			guardarTipoId(tipos[$1]);
			insertar_pila(&pila, $1);
			printf("Regla 11\n");
		}
	;

bloque:
		sentencia {
			$$ = $1;
			printf("Regla 12\n");
		}
	|	bloque sentencia 	{
			$$ = $2;
			printf("Regla 13\n");
		}
	;

sentencia:
		expresion SCOLON {
			$$ = $1;
			printf("Regla 14\n");
		}
	|	asignacion SCOLON {
			$$ = $1;
			printf("Regla 15\n");
		}
	|	seleccion {
			$$ = $1;
			printf("Regla 16\n");
		}
	|	iteracion {
			$$ = $1;
			printf("Regla 17\n");
		}
	|	impresion SCOLON {
			$$ = $1;
			printf("Regla 18\n");
		}
	|	lectura SCOLON {
			$$ = $1;
			printf("Regla 19\n");}
	|	funcion SCOLON		{
			$$ = $1;
			printf("Regla 20\n");
		}
	;

expresion:
		termino {
			$$ = $1;
			printf("Regla 21\n");
		}
	|	expresion DASH termino {
			$$ = crear_terceto($2, intToStr($1), intToStr($3));
			printf("Regla 22\n");
		}
	|	expresion PLUS termino {
			$$ = crear_terceto($2, intToStr($1), intToStr($3));
			printf("Regla 23\n");
		}
	| 	DASH expresion %prec MENOS_UNARIO	{
			$$ = crear_terceto($1, intToStr($2), NULL);
			printf("Regla 24\n");
		}
	;

termino:
		factor {
			$$ = $1;
			printf("Regla 25\n");
		}
	|	termino STAR factor	{
			$$ = crear_terceto($2, intToStr($1), intToStr($3));
			printf("Regla 26\n");
		}
	|	termino SLASH factor {
			$$ = crear_terceto($2, intToStr($1), intToStr($3));
			printf("Regla 27\n");
		}
	;

factor:
		ID {
			$$ = crear_terceto($1, NULL, NULL);
			printf("Regla 28\n");
		}
	|	CTE_I {
			$$ = crear_terceto($1, NULL, NULL);
			{printf("Regla 29\n");}
        }
	|	CTE_F {
			$$ = crear_terceto($1, NULL, NULL);
			{printf("Regla 30\n");}
        }
	|	BRA_O expresion BRA_C {
			$$ = $2;
			printf("Regla 31\n");
		}
	;

asignacion:
		asignacion_simple	{
			$$ = $1;
			printf("Regla 32\n");
		}
	|	asignacion_multiple {
			$$ = $1;
			printf("Regla 33\n");
		}
	;

asignacion_simple:
		ID ASSIG expresion {
			$$ = crear_terceto($2, $1, intToStr($3));
			printf("Regla 34\n");
		}
	|	ID ASSIG CTE_S {
			$$ = crear_terceto($2, $1, $3);
			printf("Regla 35\n");
		}
	;

asignacion_multiple:
		SBRA_O lista_ids SBRA_C ASSIG SBRA_O lista_expresiones_comma SBRA_C
		{
			int idx_exp = -1;
			int idx_id = -1;
			int idx = -1;
			while(!pila_vacia(&pila_ids)) {
				idx_id = sacar_pila(&pila_ids);
				idx_exp = sacar_pila(&pila_asig_mult_exp);
				idx = crear_terceto($4, intToStr(idx_id), intToStr(idx_exp));
			}
			$$ = idx;
			printf("Regla 36\n");
		};

lista_expresiones_comma:
		expresion {
			insertar_pila(&pila_asig_mult_exp, $1);
			$$ = $1;
			printf("Regla 37\n");
		}
	| 	lista_expresiones_comma COMMA expresion {
			insertar_pila(&pila_asig_mult_exp, $3);
			$$ = $3;
			printf("Regla 38\n");
		}
	;

seleccion:
		ifelse {
			$$ = $1;
			printf("Regla 39\n");
		};

ifelse:
		IF condicion THEN bloque {
			/*
			 * Fin del bloque verdadero
			 * - Desapilar
			 * - Completar en el terceto desapilado el nro de terceto actual + 1
			 * - Apilar el n° del terceto actual
			 *
			 *	Terceto actual: $4
			 */
			int op_logico = sacar_pila(&pila_operador_logico);

			/*
			 * condicion derecha:
			 * - Si no se cumple salto siempre al final del bloque
			 */
			int idx_right = sacar_pila(&pila);

			strcpy(tercetos[idx_right]->t2, intToStr($4 + 1));

			/*
			 * condicion izquierda:
			 * - AND: Si no se cumple salto siempre al final del bloque
			 * - OR: Si se cumple salto al principio del then. Si no,
			 *   continuo a la siguiente condicion.
			 */
			int idx_left = -1;

			if (op_logico == olAND) {
				idx_left = sacar_pila(&pila);
				strcpy(tercetos[idx_left]->t3, intToStr($4 + 1));
			} else if (op_logico == olOR) {
				idx_left = sacar_pila(&pila);
				// salto por verdadero por simplicidad.
				char *salto = tercetos[idx_left]->t1;
				strcpy(tercetos[idx_left]->t1, salto_opuesto(salto));
				strcpy(tercetos[idx_left]->t3, intToStr(idx_right + 1));
			}
		} ENDIF {
			$$ = $4;
			printf("Regla 40\n");
		}
	|	IF condicion THEN bloque {
			/*
			 * Fin del bloque verdadero
			 * - Desapilar
			 * - Completar en el terceto desapilado el nro de terceto actual + 1
			 * - Apilar el n° del terceto actual
			 *
			 *	Terceto actual: $4
			 */
			int op_logico = sacar_pila(&pila_operador_logico);

			/*
			 * condicion derecha:
			 * - Si no se cumple salto siempre al final del bloque
			 */
			int idx_right = sacar_pila(&pila);

			strcpy(tercetos[idx_right]->t2, intToStr($4 + 1));			

			/*
			 * condicion izquierda:
			 * - AND: Si no se cumple salto siempre al final del bloque
			 * - OR: Si se cumple salto al principio del then. Si no,
			 *   continuo a la siguiente condicion.
			 */
			int idx_left = -1;

			if (op_logico == olAND) {
				idx_left = sacar_pila(&pila);
				strcpy(tercetos[idx_left]->t2, intToStr($4 + 1));
			} else if (op_logico == olOR) {
				idx_left = sacar_pila(&pila);
				// salto por verdadero por simplicidad.
				char *salto = tercetos[idx_left]->t1;
				strcpy(tercetos[idx_left]->t1, salto_opuesto(salto));
				strcpy(tercetos[idx_left]->t2, intToStr(idx_right + 1));
			}

			// salto incondicional al final del else
			int idx = crear_terceto(saltos[tsJMP], NULL, NULL);
			insertar_pila(&pila, idx);
		} ELSE bloque ENDIF {
			/*
			 * - Desapilar
			 * - Completar en el terceto desapilado el n° de Terceto actual + 1
			 *
			 *   Terceto actual: $7
			 */
			int idx = sacar_pila(&pila);
			strcpy(tercetos[idx]->t2, intToStr($7 + 1));
			$$ = $7;
			printf("Regla 41\n");
		}
	;

condicion:
		proposicion {
			/**
			 * Fin de la condicion
			 * - Apilar nro del terceto actual
			 */
			insertar_pila(&pila, $1);
			insertar_pila(&pila_operador_logico, olNULL);
			$$ = $1;
			printf("Regla 42\n");
		}
	|	proposicion AND proposicion	{
			/**
			 * Fin de la condicion
			 * - Apilar nro del terceto actual
			 */
			insertar_pila(&pila, $1);
			insertar_pila(&pila, $3);
			insertar_pila(&pila_operador_logico, $2);
			$$ = $3;
			printf("Regla 43\n");
		}
	|	proposicion OR proposicion {
			/**
			 * Fin de la condicion
			 * - Apilar nro del terceto actual
			 */
			insertar_pila(&pila, $1);
			insertar_pila(&pila, $3);
			insertar_pila(&pila_operador_logico, $2);
			$$ = $3;
			printf("Regla 44\n");
		}
	|	NOT proposicion	{
			/**
			 * Fin de la condicion
			 * - Apilar nro del terceto actual
			 */
			insertar_pila(&pila, $2);
			insertar_pila(&pila_operador_logico, $1);
			$$ = $2;
			printf("Regla 45\n");
		}
	;

proposicion:
		funcion		{
			$$ = $1;
			printf("Regla 46\n");
		}
	|	comparacion	{
			$$ = $1;
			printf("Regla 47\n");
		}
	;

comparacion:
		BRA_O expresion COMP expresion BRA_C {
			int idx = crear_terceto("CMP", intToStr($2), intToStr($4));		
			$$ = crear_terceto($3, intToStr(idx), NULL);
			printf("Regla 48\n");
		};

iteracion:
		repeat {
			$$ = $1;
			printf("Regla 49\n");
		};

repeat:
		REPEAT {
			/*
			* Apilar el nro de terceto actual creando una etiqueta
			*/
			char etiq[10];
			sprintf(etiq, "REPEAT_%d", ++cantidadRepeat);
			int idx_etiq = crear_terceto(etiq, NULL, NULL);
			insertar_pila(&pila_repeat_etiq, idx_etiq);
		} bloque UNTIL condicion SCOLON {

			/* Desapilo la etiqueta de inicio */
			int idx_etiq = sacar_pila(&pila_repeat_etiq);

			/* desapilo el operador logico utilizado */
			int op_logico = sacar_pila(&pila_operador_logico);

			/*
			 * condicion derecha:
			 * - Si no se cumple salto siempre al inicio del repeat
			 */
			int idx_right = sacar_pila(&pila);

			strcpy(tercetos[idx_right]->t2, intToStr(idx_etiq + 1));

			/*
			 * condicion izquierda:
			 * - AND: Si no se cumple salto siempre al inicio del repeat
			 * - OR: Si se cumple salto al final del repeat. Si no,
			 *   continuo a la siguiente condicion.
			 */
			int idx_left = -1;

			if (op_logico == olAND) {
				idx_left = sacar_pila(&pila);
				strcpy(tercetos[idx_left]->t2, intToStr(idx_etiq + 1));				
			} else if (op_logico == olOR) {
				idx_left = sacar_pila(&pila);
				// salto por verdadero por simplicidad.
				char *salto = tercetos[idx_left]->t1;
				strcpy(tercetos[idx_left]->t1, salto_opuesto(salto));
				strcpy(tercetos[idx_left]->t2, intToStr(idx_right + 1));				
			}

			$$ = $5;
			printf("Regla 50\n");
		};

impresion:
		PRINT ID {

			if (!esIdDeclarado($2)) {
				printf("\nERROR: ID no declarado\n");
    			yyerror();
			}
			int idx = crear_terceto($2, NULL, NULL);
			$$ = crear_terceto($1, intToStr(idx), NULL);
			printf("Regla 51\n");

		}
	|	PRINT CTE_S {

			int idx = crear_terceto($2, NULL, NULL);
			$$ = crear_terceto($1, intToStr(idx), NULL);
			printf("Regla 52\n");

		}
	;

lectura:
		READ ID {
			/*
			 * No se que deberia dejar preparado
			 * para la generacion del assembler
			 * en este tipo de instrucciones
			 */
			$$ = crear_terceto($1, $2, NULL);
			printf("Regla 52\n");
        }
funcion:
		inlist {
			$$ = $1;
			printf("Regla 53\n");
		};

inlist:
		INLIST BRA_O ID COMMA SBRA_O lista_expresiones_scolon SBRA_C BRA_C {
			$$ = $6;
			printf("Regla 54\n");
		};

lista_expresiones_scolon:
		expresion {
			$$ = $1;
			printf("Regla 55\n");
		}
	|	lista_expresiones_scolon SCOLON expresion	{
			$$ = $3;
			printf("Regla 56\n");
		}
	;

%%
int main(int argc,char *argv[])
{
	FILE *intermedia;
	FILE *assembler;

	if ((yyin = fopen(argv[1], "rt")) == NULL) {
		printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
		system("Pause");
		exit(ERROR);
	}

	if((intermedia = fopen("Intermedia.txt", "w"))==NULL){
        printf("No se puede crear el archivo \"Intermedia.txt\"\n");
        exit(ERROR);
    }

	if((assembler = fopen("Final.asm", "w"))==NULL){
        printf("No se puede crear el archivo \"Final.asm\"\n");
        exit(ERROR);
    }

	yyparse();

    // Muestro los tercetos
    escribir_tercetos(intermedia);
    escribir_tercetos(stdout);

	// Genero codigo assembler
	escribir_assembler(assembler);

	fclose(yyin);

    // libero memoria de tercetos
    limpiar_tercetos();

	return SUCCESS;
}

int yyerror(const char *s)
{
	printf("Syntax Error.\nLinea: %d\nToken: %s", yylineno, yytext);
	if (*s) {
		printf("\nDetalle del error: %s", s);
	}
	system("Pause");
	exit(ERROR);
}

void success() {
	printf("\n");
	printf("------------------------\n");
	printf("  COMPILATION SUCCESS! \n");
	printf("------------------------\n");
	printf("\n");
}

void guardarTipoId(const char* tipo)
{
	strcpy(listaTiposId[cantidadTiposId], tipo);
	cantidadTiposId++;
}

void guardarId(char* id)
{
	strcpy(listaIds[cantidadIds], id);
	cantidadIds++;
}

int esIdDeclarado(char* nombre)
{
	int i = 0;
	for (i = 0 ; i < cantidadIds ; i++) {
		if (strcmp(listaIds[i], nombre) == 0) {
			return 1;
		}
	}

	return 0;
}

void asignarTipoIds()
{
	int i = 0;
	int j = 0;
	for (i = 0 ; i < cantidadTiposId ; i++) {
		if (esIdDeclarado(tablaDeSimbolos[i].nombre)) {
			strcpy(tablaDeSimbolos[i].tipo, listaTiposId[j]);
			j++;
		}

	}
}