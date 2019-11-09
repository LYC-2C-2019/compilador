#ifndef TERCETOS_H
#define TERCETOS_H

#include "const.h"

/* cantidad de tercetos */
static int cant_tercetos = 0;

/* estrutura de un terceto */
typedef struct s_terceto {
    char t1[MAX_STRING],
         t2[MAX_STRING],
         t3[MAX_STRING];
} t_terceto;

/* coleccion de tercetos */
t_terceto* tercetos[MAX_TERCETOS];

/* reserva memoria para un terceto terceto */
t_terceto* nuevo_terceto(const char*, const char*, const char*);
/* crea un terceto y lo agrega a la coleccion */
int crear_terceto(const char* t1, const char* t2, const char* t3);
/* escribe los tercetos en un archivo */
void escribir_tercetos(FILE *);
/* libera memoria pedida para tercetos */
void limpiar_tercetos();
/* devuelve la cantidad de tercetos, funciona como un get de una variable privada 
si no se usa una funcion, no se puede acceder al valor de la variable no se por que */
int obtenerCantidadDeTercetos();

#endif