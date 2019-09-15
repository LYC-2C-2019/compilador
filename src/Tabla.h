#ifndef TABLA_H
#define TABLA_H

#define TD_CTE_S "String"
#define TD_CTE_I "Integer"
#define TD_CTE_F "Float"
#define TD_UNDEFINED "Undefined"

typedef struct simbolo_s {
   char nombre[50];
   char tipo[20];
   char valor[32];
   int longitud;
} simbolo_t;

#define MAX_SIM 200

simbolo_t tablaDeSimbolos[MAX_SIM];

void insertarSimbolo(const char*, const char*);
void guardarTablaDeSimbolos();
int simboloEsConstante(const char*);
int simboloEstaEnTabla(const char*);

#endif
