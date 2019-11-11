
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
int cantidadInlist = 0;
int inicio_asignacion=0;
int tipo_dato_asignacion=0;
int tipo_dato_id_asignacion=0;
int inicio_condicion=0;
int tipo_dato_condicion=0;
int tipo_dato_id_condicion=0;

void guardarTipoId(const char*);
void guardarId(char*);
int esIdDeclarado(char*);
void asignarTipoIds();
void tercetosIfThen(int);
int yylex();
int yyerror();
void validarTipoDatoAsignacion(int);
void validarTipoDatoCondicion(int);

// MENSAJES
void success();

/* apunta al ultimo elemento terceto de salto */
t_pila pila;
/* Apila los valores de enumeracion de tipos de condicion (and, or, not) cuando hay anidamiento */
t_pila pila_operador_logico;
/* Apila los valores de enumeracion de tipos de dato para delaraciones */
t_pila pila_operador_logico;
/* Apila los indices de tercetos ids, para listas de ids*/
t_pila pila_ids;
/* Apila los indices a tercetos de expresiones, para listas de expresiones*/
t_pila pila_exp;
/* Apila indice de tercetos de etiquetas para el bloque repeat */
t_pila pila_repeat_etiq;
/* Apila los indices de tercetos de salto que quedaron por completar */
t_pila pila_saltos;

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
			tipo_dato_id_asignacion = obtenerTipoSimbolo($1);
			tipo_dato_id_condicion = obtenerTipoSimbolo($1);
			validarTipoDatoAsignacion(tipo_dato_id_asignacion);
			validarTipoDatoCondicion(tipo_dato_id_condicion);
			printf("Regla 28\n");
		}
	|	CTE_I {
			$$ = crear_terceto($1, NULL, NULL);
			validarTipoDatoAsignacion(tdInteger);
			validarTipoDatoCondicion(tdInteger);
			printf("Regla 29\n");
        }
	|	CTE_F {
			$$ = crear_terceto($1, NULL, NULL);
			validarTipoDatoAsignacion(tdFloat);
			validarTipoDatoCondicion(tdFloat);
			printf("Regla 30\n");
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
		ID ASSIG{inicio_asignacion = 1;tipo_dato_asignacion = obtenerTipoSimbolo($1);} expresion {
			$$ = crear_terceto($2, $1, intToStr($4));
			inicio_asignacion=0;
			printf("Regla 34\n");
		}
	|	ID ASSIG CTE_S {
			$$ = crear_terceto($2, $1, $3);
			inicio_asignacion=1;
			tipo_dato_asignacion=obtenerTipoSimbolo($1);
			validarTipoDatoAsignacion(tdString);
			inicio_asignacion=0;
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
				idx_exp = sacar_pila(&pila_exp);
				idx = crear_terceto($4, intToStr(idx_id), intToStr(idx_exp));
			}
			$$ = idx;
			printf("Regla 36\n");
		};

lista_expresiones_comma:
		expresion {
			insertar_pila(&pila_exp, $1);
			$$ = $1;
			printf("Regla 37\n");
		}
	| 	lista_expresiones_comma COMMA expresion {
			insertar_pila(&pila_exp, $3);
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
		funcion	{
			$$ = $1;
			printf("Regla 46\n");
		}
	|	comparacion	{
			$$ = $1;
			printf("Regla 47\n");
		}
	;

comparacion:
		BRA_O expresion COMP {inicio_condicion = 1;tipo_dato_condicion = obtenerTipoSimbolo(intToStr($2));} expresion BRA_C {
			int idx = crear_terceto("CMP", intToStr($2), intToStr($5));
			$$ = crear_terceto($3, intToStr(idx), NULL);
			inicio_condicion = 0;
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
			// char etiq[10];
			// sprintf(etiq, "REPEAT_%d", ++cantidadRepeat);
			// int idx_etiq = crear_terceto(etiq, NULL, NULL);
			
			insertar_pila(&pila_repeat_etiq, obtenerCantidadDeTercetos());
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
			$$ = crear_terceto($1, $2, NULL);
			printf("Regla 51\n");

		}
	|	PRINT CTE_S {

			$$ = crear_terceto($1, $2, NULL);
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
		;

funcion:
		BRA_O inlist BRA_C {
			int idx = -1;
			int idx_jmp= -1;
			while(!pila_vacia(&pila_saltos)) {
				idx_jmp = sacar_pila(&pila_saltos);

				/*
				 * - Si se cumple por verdadero, salto al terceto actual - 2
				 * - si se cumple por falso, salto al siguiente terceto de comparacion
				 */
				if (strcmp(tercetos[idx_jmp]->t1, saltos[tsJE]) == 0) {
					strcpy(tercetos[idx_jmp]->t2, intToStr($2));
				} else {
					strcpy(tercetos[idx_jmp]->t2, intToStr(idx_jmp + 2));
				}
			}

			$$ = $2;
			printf("Regla 53\n");
		};

inlist:
		INLIST BRA_O ID COMMA SBRA_O lista_expresiones_scolon SBRA_C BRA_C {
			int idx = -1;
			int idx_exp = -1;
			while(!pila_vacia(&pila_exp)) {
				idx_exp = sacar_pila(&pila_exp);

				/*
				 * Creo un terceto de comparacion y dos tercetos de salto
				 *  n-2 (CMP, ID, EXPRESION)
				 * 	n-1 (JNE, n-2, NULL) -> completar
				 * 	n   (JE, n-1, NULL) -> completar
				 */
				int cmp = crear_terceto("CMP", $3, intToStr(idx_exp));

				idx = crear_terceto(saltos[tsJNE], NULL, NULL);
				insertar_pila(&pila_saltos, idx);

				idx = crear_terceto(saltos[tsJE], NULL, NULL);
				insertar_pila(&pila_saltos, idx);
			}

			/*
			 * Creo una variable de apoyo con falso
			 * Si no se encuentra el valor en la lista
			 * saltará a este terceto.
			 * debe guardarse en la tabla de simbolos
			 */
			char aux[20];
			sprintf(aux, "_INLIST_%d", ++cantidadInlist);

			/* terceto resultado falso */
			idx = crear_terceto(":=", aux, "false");

			/* salteo un terceto */
			idx = crear_terceto(saltos[tsJMP], NULL , intToStr(idx + 2));

			/* terceto resultado verdadero */
			idx = crear_terceto(":=", aux, "true");

			// devuelvo el ultimo terceto creado */
			$$ = idx;
			printf("Regla 54\n");
		};

lista_expresiones_scolon:
		expresion {
			insertar_pila(&pila_exp, $1);
			$$ = $1;
			printf("Regla 55\n");
		}
	|	lista_expresiones_scolon SCOLON expresion	{
			insertar_pila(&pila_exp, $3);
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

void validarTipoDatoAsignacion(int tipoDeDato)
{
  if (inicio_asignacion == 1 && tipo_dato_asignacion != tdFloat  && tipoDeDato != tdInteger)
  {	  	
    printf("ERROR EN ASIGNACION DE DATOS DE DISTINTOS TIPOS\n");
    system ("Pause");
    exit (1);
  }
}

void validarTipoDatoCondicion(int tipoDeDato)
{
  if (inicio_condicion == 1 && tipo_dato_condicion != tdFloat  && tipoDeDato != tdInteger)
  {	  	
    printf("ERROR EN COMPARACION DE DATOS DE DISTINTOS TIPOS\n");
    system ("Pause");
    exit (1);
  }
}
