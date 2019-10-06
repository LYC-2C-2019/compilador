
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
#include "lib/index.h"
#include "lib/utils.h"

int yystopparser=0;
FILE  *yyin;
char *yytext;
int yylineno;
int cantidadTiposId = 0;
int cantidadIds = 0;
char listaTiposId[MAX_SIM][MAX_TYPE];
char listaIds[MAX_SIM][MAX_ID];

void guardarTipoId(char*);
void guardarId(char*);
int esIdDeclarado(char*);
void asignarTipoIds();

int yylex();
int yyerror();

// MENSAJES
void success();

/* apunta al ultimo elemento ingresado */
t_pila pila;
/* Indica que operador de comparacion se uso */
t_pila comparacion;
/* Apila los tipos de condicion (and, or, not) cuando hay anidamiento */
t_pila pila_condicion;
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

%token	<texto> INTEGER
%token	<texto> FLOAT
%token	<texto> STRING
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

%start bloque

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
		SBRA_O lista_tipos SBRA_C COLON SBRA_O lista_ids SBRA_C
		{printf("Regla 4\n");};

lista_tipos:
		tipo {printf("Regla 5\n");}
	|	lista_tipos COMMA tipo {printf("Regla 6\n");}
	;

lista_ids:
		ID {
			guardarId($1);
			printf("Regla 7\n");
		}
	|	lista_ids COMMA ID {
			guardarId($3);
			{printf("Regla 8\n");}
		}
	;

tipo:
		INTEGER {
			guardarTipoId($1);
			{printf("Regla 9\n");}
		}
	|	FLOAT {
			guardarTipoId($1);
			{printf("Regla 10\n");}
		}
	|	STRING {
			guardarTipoId($1);
			{printf("Regla 11\n");}
		}
	;

bloque:
		sentencia {
			idx_bloque = idx_sentencia;
			printf("Regla 12\n");
		}
	|	bloque sentencia 	{printf("Regla 13\n");}
	;

sentencia:
		expresion SCOLON {
			idx_sentencia = idx_expresion;
			printf("Regla 14\n");
		}
	|	asignacion SCOLON {
			idx_sentencia = idx_asignacion;
			printf("Regla 15\n");
		}
	|	seleccion {
			idx_sentencia = idx_seleccion;
			printf("Regla 16\n");
		}
	|	iteracion {
			idx_sentencia = idx_iteracion;
			printf("Regla 17\n");
		}
	|	impresion SCOLON {
			idx_sentencia = idx_impresion;
			printf("Regla 18\n");
		}
	|	lectura SCOLON {
			idx_sentencia = idx_lectura;
			printf("Regla 19\n");}
	|	funcion SCOLON		{
			idx_funcion = idx_funcion;
			printf("Regla 20\n");
		}
	;

expresion:
		termino {
			idx_expresion = idx_termino;
			printf("Regla 21\n");
		}
	|	expresion DASH termino {
			idx_expresion = crear_terceto($2, intToStr(idx_expresion), intToStr(idx_termino));
			printf("Regla 22\n");
		}
	|	expresion PLUS termino {
			idx_expresion = crear_terceto($2, intToStr(idx_expresion), intToStr(idx_termino));
			printf("Regla 23\n");
		}
	| 	DASH expresion %prec MENOS_UNARIO	{
			idx_expresion = crear_terceto($1, intToStr(idx_expresion), NULL);
			printf("Regla 24\n");
		}
	;

termino:
		factor {
			idx_termino = idx_factor;
			printf("Regla 25\n");
		}
	|	termino STAR factor	{
			idx_termino = crear_terceto($2, intToStr(idx_termino), intToStr(idx_factor));
			printf("Regla 26\n");
		}
	|	termino SLASH factor {
			idx_termino = crear_terceto($2, intToStr(idx_termino), intToStr(idx_factor));
			printf("Regla 27\n");
		}
	;

factor:
		ID {
			idx_factor = crear_terceto($1, NULL, NULL);
			printf("Regla 28\n");
		}
	|	CTE_I {
            idx_factor = crear_terceto($1, NULL, NULL);
			{printf("Regla 29\n");}
        }
	|	CTE_F {
            idx_factor = crear_terceto($1, NULL, NULL);
			{printf("Regla 30\n");}
        }
	|	BRA_O expresion BRA_C {
			idx_factor = idx_expresion;
			printf("Regla 31\n");
		}
	;

asignacion:
		asignacion_simple	{
			idx_asignacion = idx_asignacion_simple;
			printf("Regla 32\n");
		}
	|	asignacion_multiple {printf("Regla 33\n");}
	;

asignacion_simple:
		ID ASSIG expresion {
			idx_asignacion_simple = crear_terceto($2, $1, intToStr(idx_expresion));
			printf("Regla 34\n");
		}
	|	ID ASSIG CTE_S {
			idx_asignacion_simple = crear_terceto($2, $1, $3);
			printf("Regla 35\n");
		}
	;

asignacion_multiple:
		SBRA_O lista_ids SBRA_C ASSIG SBRA_O lista_expresiones_comma SBRA_C
		{printf("Regla 36\n");};

lista_expresiones_comma:
		expresion 								{printf("Regla 37\n");}
	| 	lista_expresiones_comma COMMA expresion {printf("Regla 38\n");}
	;

seleccion:
		ifelse {
			idx_seleccion = idx_ifelse;
			printf("Regla 39\n");
		};

ifelse:
		IF condicion THEN bloque ENDIF {
			printf("Regla 40\n");
		}
	|	IF condicion THEN bloque ELSE bloque ENDIF 	{printf("Regla 41\n");}
	;

condicion:
		proposicion						{printf("Regla 42\n");}
	|	proposicion AND proposicion		{printf("Regla 43\n");}
	|	proposicion OR proposicion		{printf("Regla 44\n");}
	|	NOT proposicion	{printf("Regla 45\n");}
	;

proposicion:
		funcion		{printf("Regla 46\n");}
	|	comparacion	{printf("Regla 47\n");}
	;

comparacion:
		BRA_O expresion COMP expresion BRA_C
		{printf("Regla 48\n");};

iteracion:
		repeat
		{printf("Regla 49\n");};

repeat:
		REPEAT bloque UNTIL condicion SCOLON
		{printf("Regla 50\n");};

impresion:
		PRINT ID {printf("Regla 51\n");}
	|	PRINT CTE_S {printf("Regla 52\n");}
	;

lectura:
		READ ID {
			idx_lectura = crear_terceto("READ", $2, NULL);
			printf("Regla 52\n");
        }
funcion:
		inlist
		{printf("Regla 53\n");};

inlist:
		INLIST BRA_O ID COMMA SBRA_O lista_expresiones_scolon SBRA_C BRA_C
		{printf("Regla 54\n");};

lista_expresiones_scolon:
		expresion									{printf("Regla 55\n");}
	|	lista_expresiones_scolon SCOLON expresion	{printf("Regla 56\n");}
	;

%%
int main(int argc,char *argv[])
{
	FILE *intermedia;

	if ((yyin = fopen(argv[1], "rt")) == NULL) {
		printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
		system("Pause");
		exit(ERROR);
	}

	if((intermedia = fopen("Intermedia.txt", "w"))==NULL){
        printf("No se puede crear el archivo Intermedia.txt\n");
        exit(ERROR);
    }

	yyparse();

    // Muestro los tercetos
    escribir_tercetos(intermedia);
    escribir_tercetos(stdout);

    // libero memoria de tercetos
    limpiar_tercetos();

	fclose(yyin);
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

void guardarTipoId(char* tipo)
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
