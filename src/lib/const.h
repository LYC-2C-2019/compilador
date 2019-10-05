#ifndef CONST_H
#define CONST_H

#include <float.h>
#include <limits.h>

// EXIT CODES
#define SUCCESS 0
#define ERROR -1

// TIPOS DE DATO
#define TD_CTE_S "String"
#define TD_CTE_I "Integer"
#define TD_CTE_F "Float"
#define TD_UNDEFINED "Undefined"

// LIMITES DE COLECCIONES
#define MAX_SIM 200
#define MAX_TERCETOS 1024

// LONGITUDES DE VALORES
#define MAX_ID 32
#define MAX_STRING 32
#define MAX_INT USHRT_MAX // 16 bit
#define MAX_FLOAT FLT_MAX // 32 bit
#define MAX_TYPE 20
#define MAX_REG_TABLA_SIM 160

// CADENAS DE FORMATO
#define FORMATO_HEADER_TABLA_SIM "%-50s|\t%-20s|\t%-50s|\t%-20s\n"
#define FORMATO_REG_TABLA_SIM "%-50s|\t%-20s|\t%-50s|\t%-20d\n"

#endif
