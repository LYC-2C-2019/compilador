#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Tabla.h"


#define FORMATO_COL "%-50s|\t%-20s|\t%-32s|\t%-20s\n"
#define FORMATO_REG_STR "%-50s|\t%-20s|\t%-32s|\t%-20d\n"
#define FORMATO_REG_INT "%-50s|\t%-20s|\t%-32d|\t%-20s\n"
#define FORMATO_REG_FLT "%-50s|\t%-20s|\t%-32f|\t%-20s\n"
#define FORMATO_LEN 126

// TABLA DE SIMBOLOS
void crearTablaDeSimbolos() {
   char buff[FORMATO_LEN];
   FILE *fp;
   if ((fp = fopen("ts.txt", "w+")) == NULL) {
      printf("Error creando en tabla de simbolos\n");
      return;
   }

   fprintf(fp, FORMATO_COL,
      "NOMBRE", "TIPO", "VALOR", "LONGITUD");

   memset(buff, '-', sizeof(char)*FORMATO_LEN);
   fprintf(fp, "%s\n", buff);

   fclose(fp);
}

void insertarSimbolo(const char *nombre, const char* tipo, const char* valor) {
   FILE *fp;
   if ((fp = fopen("ts.txt", "a+")) == NULL) {
      printf("Error escribiendo en tabla de simbolos\n");
      return;
   }

   if (strcmp(tipo, "String") == 0) {
      fprintf(fp, FORMATO_REG_STR,
         nombre, tipo, valor, (int)strlen(valor));
   } else if (strcmp(tipo, "Integer") == 0) {
      fprintf(fp, FORMATO_REG_INT,
         nombre, tipo, atoi(valor), "");
   } else if (strcmp(tipo, "Float") == 0) {
      fprintf(fp, FORMATO_REG_FLT,
         nombre, tipo, atof(valor), "");
   }

   fclose(fp);
}


