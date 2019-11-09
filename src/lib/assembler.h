#ifndef ASSEMBLER_H
#define ASSEMBLER_H


void escribir_assembler(FILE*);
void escribir_seccion_datos(FILE*);
void escribir_seccion_codigo(FILE*);
char* asignar_nombre_variable_assembler(char*);
void escribir_operacion_unaria(FILE*, int);

#endif