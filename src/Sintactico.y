
%{
#include <stdio.h>
#include <stdlib.h>

#if defined(__APPLE__) || defined(__linux__)
	#include <curses.h>
#elif defined(_WIN32)
	#include <conio.h>
#else
	#error "OS not suported"
#endif

#include "y.tab.h"

int yylval;
int yystopparser=0;
FILE  *yyin;
char *yyltext;
char *yytext;
int yylineno;

int yylex();
int yyerror();

void success();
%}

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
%token	ASIG
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

%%
programa:
		declaraciones bloque
		{success();};

declaraciones:
		VAR lista_declaraciones ENDVAR
		{printf("declaraciones OK\n");};

lista_declaraciones:
		lista_declaraciones COMMA declaracion
	|	declaracion {printf("lista_declaraciones OK\n");}
	;

declaracion:
		SBRA_O lista_tipos SBRA_C COLON SBRA_O lista_ids SBRA_C
		{printf("declaracion OK\n");};

lista_tipos:
		tipo
	|	lista_tipos COMMA tipo {printf("lista_tipos OK\n");}
	;

lista_ids:
		ID
	|	lista_ids COMMA ID {printf("lista_ids OK\n");}
	;

tipo:
		INTEGER {printf("tipo integer OK\n");}
	|	FLOAT	{printf("tipo float OK\n");}
	|	STRING	{printf("tipo string OK\n");}
	;

bloque:
		sentencia
	|	bloque sentencia {printf("bloque OK\n");}
	;

sentencia:
		expresion SCOLON
	|	asignacion SCOLON
	|	asignacion_multiple SCOLON
	|	seleccion
	|	iteracion SCOLON
	|	impresion SCOLON
	|	lectura SCOLON
	|	funcion SCOLON {printf("sentencia OK\n");}
	;

expresion:
		termino
	|	expresion DASH termino	{printf("Resta OK\n");}
	|	expresion PLUS termino  {printf("Suma OK\n");}
	;

termino:
		factor
	|	termino STAR factor 	{printf("Multiplicacion OK\n");}
	|	termino SLASH factor	{printf("Division OK\n");}
	;

factor:
		ID
	|	CTE_I {$1 = yylval ;printf("CTE_I es: %d\n", yylval);}
	|	CTE_F {$1 = yylval ;printf("CTE_F es: %d\n", yylval);}
	|	BRA_O expresion BRA_C {printf("factor OK\n");}
	;

asignacion:
		ID ASIG expresion	{printf("asignacion OK\n");}
	|	ID ASIG CTE_S 		{printf("asignacion OK\nCTE_S es: %s\n", yytext);}
	;

asignacion_multiple:
		SBRA_O lista_ids SBRA_C ASIG SBRA_O lista_expresiones_comma SBRA_C
		{printf("asignacion_multiple OK\n");};

lista_expresiones_comma:
		expresion
	| 	lista_expresiones_comma COMMA expresion {printf("lista_expresiones_comma OK\n");}
	;

seleccion:
		ifelse
		{printf("seleccion OK\n");};

ifelse:
		IF condicion THEN bloque ENDIF
	|	IF condicion THEN bloque ELSE bloque ENDIF {printf("ifelse OK\n");}
	;

condicion:
		proposicion
	|	proposicion AND proposicion
	|	proposicion OR proposicion
	|	NOT proposicion	{printf("condicion OK\n");}
	;

proposicion:
		funcion
	|	comparacion	{printf("proposicion OK\n");};

comparacion:
		BRA_O expresion COMP expresion BRA_C
		{printf("comparacion OK\n");};

iteracion:
		repeat
		{printf("iteracion OK\n");};

repeat:
		REPEAT bloque UNTIL condicion
		{printf("repeat OK\n");};

impresion:
		PRINT ID {printf("impresion ID OK\n");}
	|	PRINT CTE_S {printf("impresion CTE_S OK\n");};

lectura:
		READ ID
		{printf("lectura OK\n");};

funcion:
		inlist
		{printf("funcion OK\n");};

inlist:
		INLIST BRA_O ID SCOLON SBRA_O lista_expresiones_scolon SBRA_C BRA_C
		{printf("inlist OK\n");};

lista_expresiones_scolon:
		expresion
	|	lista_expresiones_scolon SCOLON expresion	{printf("lista-expresiones-scolon OK\n");}
	;

%%
int main(int argc,char *argv[])
{
	if ((yyin = fopen(argv[1], "rt")) == NULL) {
		printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
	} else {
		yyparse();
	}

	fclose(yyin);
	return 0;
}

int yyerror(void)
{
	printf("Syntax Error in line %d en token %s \n", yylineno, yytext);
	system ("Pause");
	exit (1);
}

void success() {
	printf("\n");
	printf("------------------------\n");
	printf("  COMPILATION SUCCESS! \n");
	printf("------------------------\n");
	printf("\n");
}




