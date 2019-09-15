#ifndef TABLA_H
#define TABLA_H

#define TD_CTE_S "String"
#define TD_CTE_I "Integer"
#define TD_CTE_F "Float"
#define TD_UNDEFINED "Undefined"

void insertarSimbolo(const char*, const char*);
void guardarTablaDeSimbolos();
int simboloEsConstante(const char*);
int simboloEstaEnTabla(const char*);

#endif
