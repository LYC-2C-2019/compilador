#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "tabla.h"

// FUNCIONES PUBLICAS

void insertarSimbolo(const char* nombre, const char* tipo)
{
   if (!simboloEstaEnTabla(nombre))
   {
      simbolo_t reg;
      strcpy(reg.nombre, nombre);
      strcpy(reg.tipo, tipo);
      strcpy(reg.valor, simboloEsConstante(tipo) ? nombre : TD_UNDEFINED);
      reg.longitud = strlen(nombre);

      tablaDeSimbolos[cantidadSimbolos] = reg;

      cantidadSimbolos++;

   }

}

void guardarTablaDeSimbolos()
{
   FILE *fp;
   int i = 0;
   char buff[MAX_REG_TABLA_SIM];

   if ((fp = fopen("ts.txt", "w+")) == NULL)
   {
      printf("Error al guardar tabla de simbolos\n");
      exit(ERROR);
   }

   fprintf(fp, FORMATO_HEADER_TABLA_SIM, "NOMBRE", "TIPO", "VALOR", "LONGITUD");
   memset(buff, '-', (sizeof(char) * MAX_REG_TABLA_SIM) - 2);
   fprintf(fp, "%s\n", buff);

   for (i = 0 ; i < cantidadSimbolos ; i++) {

      fprintf(fp,
      FORMATO_REG_TABLA_SIM,
      tablaDeSimbolos[i].nombre,
      tablaDeSimbolos[i].tipo,
      tablaDeSimbolos[i].valor,
      tablaDeSimbolos[i].longitud);

   }

   fclose(fp);
}



// FUNCIONES PRIVADAS

int simboloEsConstante(const char* tipo)
{
   if (strcmp(tipo, tipos[tdString]) == 0 || strcmp(tipo, tipos[tdInteger]) == 0 || strcmp(tipo, tipos[tdFloat]) == 0)
      return 1;

   return 0;
}

/*
 * int simboloEstaEnTabla(const char* nombre)
 *
 * Determina si el simbolo especificado con el nombre se encuentra
 * o no dentro de la tabla. Devuelve 1 en caso de encontrarse; 0 en caso de no
 * encontrarse.
 *
 */

int simboloEstaEnTabla(const char* nombre)
{
    int i;

    for (i = 0; i < MAX_SIM; i++)
    {
          if(strcmp(tablaDeSimbolos[i].nombre, nombre) == 0)
             return 1;
    }

    return 0;
}

