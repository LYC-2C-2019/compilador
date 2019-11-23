#ifndef CONST_H
#define CONST_H

#include <float.h>
#include <limits.h>

// EXIT CODES
#define SUCCESS 0
#define ERROR -1

// TIPOS DE DATO
#define TD_S "String"
#define TD_I "Integer"
#define TD_F "Float"
#define TD_CTE_S "ConstString"
#define TD_CTE_I "ConstInteger"
#define TD_CTE_F "ConstFloat"
#define TD_UNDEFINED "Undefined"

#define variableEntera 1
#define	variableFloat 2
#define variableString 3
#define constanteEntera 4
#define constanteFloat 5
#define constanteString 6

static const char * tipos[] = {
    TD_S,
    TD_I,
    TD_F,
    TD_CTE_S,
    TD_CTE_I,
    TD_CTE_F,
    TD_UNDEFINED
};

typedef enum {
    tdString,
    tdInteger,
    tdFloat,
    tdConstString,
    tdConstInteger,
    tdConstFloat,
    tdUndefined
} t_tipo_dato;

// LIMITES DE COLECCIONES
#define MAX_SIM 200
#define MAX_TERCETOS 1024

// LONGITUDES DE VALORES
#define MAX_LONG 3
#define MAX_ID 50
#define MAX_STRING 32
#define MAX_INT USHRT_MAX // 16 bit
#define MAX_FLOAT FLT_MAX // 32 bit
#define MAX_TYPE 20
#define MAX_REG_TABLA_SIM 98

// CADENAS DE FORMATO
#define FORMATO_REG_TABLA_SIM "%-34s| %-14s| %-34s| %-10s\n"

// ISTRUCCIONES DE SALTO
typedef enum {
    olNULL,
    olAND,
    olNOT,
    olOR,
} t_op_logico;

typedef enum {
    tsJE,
    tsJNE,
    tsJL,
    tsJLE,
    tsJG,
    tsJGE,
    tsJMP,
} t_salto;

/* signados */
static const char * saltos[] = {
    "JE",
    "JNE",
    "JL",
    "JLE",
    "JG",
    "JGE",
    "JMP"
};

/* sin signar */
static const char * saltos_u[] = {
    "JE",
    "JNE",
    "JB",
    "JBE",
    "JNBE",
    "JAE",
    "JMP"
};

#endif
