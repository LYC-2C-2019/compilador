#ifndef ASSEMBLER_H
#define ASSEMBLER_H

static int aux_tiponumerico=0;

void escribir_assembler(int);
void escribir_seccion_datos(FILE*, int);
void escribir_seccion_codigo(FILE*);

int esOperacion(int);
int esSalto(int);
void preparar_assembler();
int get_aux_tiponumerico();
void set_aux_tiponumerico(int);
// char* asignar_nombre_variable_assembler(char*);
// char* obtener_instruccion_assembler(char*);
// void prepararAssembler();

#endif