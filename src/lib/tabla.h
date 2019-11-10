#ifndef TABLA_H
#define TABLA_H

#include "const.h"

static int cantidadSimbolos = 0;

typedef struct simbolo_s {
   char nombre[MAX_ID];
   char tipo[MAX_TYPE];
   char valor[MAX_STRING];
   char longitud[MAX_LONG];
} simbolo_t;

simbolo_t tablaDeSimbolos[MAX_SIM];

void insertarSimbolo(const char*, const char*);
void guardarTablaDeSimbolos();
int simboloEsConstante(const char*);
int simboloEstaEnTabla(const char*);
int tipoDeSimbolo(const char*);

#endif
