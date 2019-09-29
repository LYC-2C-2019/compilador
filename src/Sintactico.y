
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

#include "Tabla.h"

#define ERROR -1
#define MAX_TERCETOS 1024
#define MAX_LONG 32 

int yystopparser=0;
FILE  *yyin;
char *yytext;
int yylineno;
int cantidadTiposId = 0;              
int cantidadIds = 0;
char listaTiposId[MAX_SIM][20];
char listaIds[MAX_SIM][50];

void guardarTipoId(char*);
void guardarId(char*);
int esIdDeclarado(char*);
void asignarTipoIds();

int yylex();
int yyerror();

// MENSAJES
void success();

/* Notacion intermedia */
/* estrutura de un terceto */
typedef struct s_terceto {
    char t1[MAX_LONG], // primer termino
         t2[MAX_LONG], // segundo termino
         t3[MAX_LONG]; // tercer termino
    char aux[MAX_LONG]; // nombre variable auxiliar correspondiente
} t_terceto;
/* coleccion de tercetos */
t_terceto* tercetos[MAX_TERCETOS];
/* cantidad de tercetos */
int cant_tercetos;
/** crea una estructura de datos de terceto */
t_terceto* crear_estructura_terceto (const char*, const char*, const char*);
/* crea un terceto y lo agrega a la coleccion */
int crear_terceto(const char*, const char*, const char*);
/* escribe los tercetos en un archivo */
void escribir_tercetos(FILE *);
/* libera memoria pedida para tercetos */
void limpiar_tercetos();
/* Pila */ 
typedef struct s_nodo {
    int valor;
    struct s_nodo *sig;
} t_nodo;
typedef t_nodo* t_pila;
/* apunta al ultimo elemento ingresado */
t_pila pila;
/* Indica que operador de comparacion se uso */
t_pila comparacion;
/* Apila los tipos de condicion (and, or, not) cuando hay anidamiento */
t_pila pila_condicion;
void insertar_pila (t_pila*, int);
int sacar_pila(t_pila*);
void crear_pila(t_pila*);
void destruir_pila(t_pila*);
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
};

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
%token	<real> ID
%token	CTE_S
%token	<entero> CTE_I
%token	<real> CTE_F

%left	PLUS DASH
%left	STAR SLASH
%right	MENOS_UNARIO

%start programa

%%
programa:
		declaraciones bloque
		{success();};

declaraciones:
		VAR lista_declaraciones ENDVAR
		{
			asignarTipoIds();
			printf("declaraciones OK\n");
		};

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
		ID { guardarId(yytext);}
	|	lista_ids COMMA ID 
		{
			guardarId(yytext);
			printf("lista_ids OK\n");
		}
	;

tipo:
		INTEGER 
		{
			guardarTipoId(yytext);
			printf("tipo integer OK\n");			
		}
	|	FLOAT
		{
			guardarTipoId(yytext);
			printf("tipo float OK\n");
		}
	|	STRING	
		{
			guardarTipoId(yytext);
			printf("tipo string OK\n");
		}
	;

bloque:
		sentencia
	|	bloque sentencia {printf("bloque OK\n");}
	;

sentencia:
		expresion SCOLON
	|	asignacion SCOLON
	|	seleccion
	|	iteracion
	|	impresion SCOLON
	|	lectura SCOLON
	|	funcion SCOLON {printf("sentencia OK\n");}
	;

expresion:
		termino
	|	expresion DASH termino	{printf("Resta OK\n");}
	|	expresion PLUS termino  {printf("Suma OK\n");}
	| 	DASH expresion %prec MENOS_UNARIO {printf("menos unario OK\n");}
	;

termino:
		factor
	|	termino STAR factor 	{printf("Multiplicacion OK\n");}
	|	termino SLASH factor	{printf("Division OK\n");}
	;

factor:
		ID
	|	CTE_I		{
            char valor[MAX_LONG];
			sprintf(valor, "%d", $1);
			printf("Valor: " , valor, "\n");
            crear_terceto (valor, NULL, NULL);
			printf("CTE_I es: %d\n", $1);
           }
	|	CTE_F {
            char valor[MAX_LONG];
			sprintf(valor, "%.2f", $1);
			printf("Valor: " , valor, "\n");
            crear_terceto (valor, NULL, NULL);
			printf("CTE_F es: %f\n", $1);
            }
	|	BRA_O expresion BRA_C {printf("factor OK\n");}
	;

asignacion:
		asignacion_simple
	|	asignacion_multiple {printf("asignacion OK\n");}
	;

asignacion_simple:
		ID ASSIG expresion	{printf("asignacion_simple OK\n");}
	|	ID ASSIG CTE_S 		{printf("asignacion_simple OK\nCTE_S es: %s\n", yytext);}
	;

asignacion_multiple:
		SBRA_O lista_ids SBRA_C ASSIG SBRA_O lista_expresiones_comma SBRA_C
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
	|	comparacion	{printf("proposicion OK\n");}
	;

comparacion:
		BRA_O expresion COMP expresion BRA_C
		{printf("comparacion OK\n");};

iteracion:
		repeat
		{printf("iteracion OK\n");};

repeat:
		REPEAT bloque UNTIL condicion SCOLON
		{printf("repeat OK\n");};

impresion:
		PRINT ID {printf("impresion ID OK\n");}
	|	PRINT CTE_S {printf("impresion CTE_S OK\n");}
	;

lectura:
		READ ID
		{
            char valor[MAX_LONG];
            // COMO SE EL VALOR DEL ID SI NO SE DECLARA ANTES?? NO ME CIERRA
            crear_terceto ("READ", valor, NULL);
			printf("lectura OK\n");
           }
funcion:
		inlist
		{printf("funcion OK\n");};

inlist:
		INLIST BRA_O ID COMMA SBRA_O lista_expresiones_scolon SBRA_C BRA_C
		{printf("inlist OK\n");};

lista_expresiones_scolon:
		expresion
	|	lista_expresiones_scolon SCOLON expresion	{printf("lista-expresiones-scolon OK\n");}
	;

%%
int main(int argc,char *argv[])
{
	FILE *intermedia;

	if ((yyin = fopen(argv[1], "rt")) == NULL) {
		printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
		system("Pause");
		exit(1);
	} 
	if((intermedia = fopen("Intermedia.txt", "w"))==NULL){
        printf("No se puede crear el archivo Intermedia.txt\n");
        exit(ERROR);
    }


	yyparse();
	
    escribir_tercetos(intermedia);
    escribir_tercetos(stdout);

    // libero memoria de tercetos
    limpiar_tercetos();

	fclose(yyin);
	return 0;
}

int yyerror(const char *s)
{
	printf("Syntax Error.\nLinea: %d\nToken: %s", yylineno, yytext);
	if (*s)
	{
		printf("\nDetalle del error: %s", s);
	}
	system("Pause");
	exit(1);
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
	for (i = 0 ; i < cantidadIds ; i++)
	{
		if (strcmp(listaIds[i], nombre) == 0)
			return 1;
	}

	return 0;
}

void asignarTipoIds()
{
	int i = 0;
	int j = 0;
	for (i = 0 ; i < cantidadTiposId ; i++)
	{
		if (esIdDeclarado(tablaDeSimbolos[i].nombre))
		{
			strcpy(tablaDeSimbolos[i].tipo, listaTiposId[j]);
			j++;
		}

	}
}

/** crea una estructura de datos de terceto */
t_terceto* _crear_terceto (const char* t1, const char* t2, const char* t3){
    t_terceto* terceto = (t_terceto*) malloc(sizeof(t_terceto));
    // completo sus atributos
    strcpy(terceto->t1, t1);

    if (t2)
        strcpy(terceto->t2, t2);
    else
        *(terceto->t2) = '\0';

    if (t3)
        strcpy(terceto->t3, t3);
    else
        *(terceto->t3) = '\0';
    return terceto; 
}

/** crea una estructura de datos de terceto */
t_terceto* crear_estructura_terceto (const char* t1, const char* t2, const char* t3){
    t_terceto* terceto = (t_terceto*) malloc(sizeof(t_terceto));
    // completo sus atributos
    strcpy(terceto->t1, t1);

    if (t2)
        strcpy(terceto->t2, t2);
    else
        *(terceto->t2) = '\0';

    if (t3)
        strcpy(terceto->t3, t3);
    else
        *(terceto->t3) = '\0';
    return terceto; 
}

int crear_terceto(const char* t1, const char* t2, const char* t3){
    // creo un nuevo terceto y lo agrego a la coleccion de tercetos
    int numero = cant_tercetos;
    tercetos[numero] = _crear_terceto (t1, t2, t3);
    cant_tercetos++;
    // devuelvo numero de terceto
    return numero;
}

void escribir_tercetos (FILE* archivo) {
    int i;
    for (i = 0; i < cant_tercetos; i++)
        fprintf(archivo, "%d (%s, %s, %s)\n", i,
                                              tercetos[i]->t1,
                                              tercetos[i]->t2,
                                              tercetos[i]->t3);
}
void limpiar_tercetos () {
    int i;
    for (i = 0; i < cant_tercetos; i++)
        free(tercetos[i]);
}

void insertar_pila (t_pila *p, int valor) {
    t_nodo *nodo = (t_nodo*) malloc (sizeof(t_nodo));
    nodo->valor = valor;
    nodo->sig = *p;
    *p = nodo;
}

int sacar_pila(t_pila *p) {
    int valor = ERROR;
    t_nodo *aux;
    if (*p != NULL) {
       aux = *p;
       valor = aux->valor;
       *p = aux->sig;
       free(aux);
    }
    return valor;
}

void crear_pila(t_pila *p) {
    *p = NULL;
}

void destruir_pila(t_pila *p) {
    while ( ERROR != sacar_pila(p));
}