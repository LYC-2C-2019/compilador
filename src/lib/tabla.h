#ifndef TABLA_H
#define TABLA_H

static int cantidadSimbolos = 0;

// typedef struct simbolo_s {
//    char nombre[MAX_ID];
//    char tipo[MAX_TYPE];
//    char valor[MAX_STRING];
//    char longitud[MAX_LONG];
// } simbolo_t;

// simbolo_t tablaDeSimbolos[MAX_SIM];

	typedef struct
	{
		char nombre[100];
		char tipo  [20];
		char valor [100];
		int longitud;
		int TipodeDato_numerico;
	} struct_tabla_de_simbolos;

	struct_tabla_de_simbolos tablaDeSimbolos[200];

// void insertarSimbolo(const char*, const char*);
void guardarTablaDeSimbolos(int, int);
// int simboloEsConstante(const char*);
// int simboloEstaEnTabla(const char*);
// int obtenerCantidadDeSimbolos();
// int obtenerTipoSimbolo(const char*);

#endif
