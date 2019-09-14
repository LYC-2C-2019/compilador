#ifndef TABLA_H
#define TABLA_H

// TIPOS
typedef enum { tInteger, tFloat, tString } tipo_t;
typedef struct simbolo_s {
   char *nombre;
   tipo_t tipoDato;
   int valorEntero;
   float valorReal;
   char *valorString;
   int longitud;
} simbolo_t;

void crearTablaDeSimbolos();
void insertarSimbolo(const char *nombre, const char * tipo, const char* valor);

#endif
