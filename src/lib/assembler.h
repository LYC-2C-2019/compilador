#ifndef ASSEMBLER_H
#define ASSEMBLER_H


void escribir_assembler(FILE*);
void escribir_seccion_datos(FILE*);
void escribir_seccion_codigo(FILE*);
char* asignar_nombre_variable_assembler(char*);
char* obtener_instruccion_assembler(char*);

#endif