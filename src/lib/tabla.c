#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "tabla.h"
#include "const.h"

// FUNCIONES PUBLICAS

void insertarSimbolo(const char* nombre, const char* tipo)
{
   if (!simboloEstaEnTabla(nombre))
   {
      simbolo_t reg;
      strcpy(reg.nombre, nombre);
      strcpy(reg.tipo, tipo);
      strcpy(reg.valor, simboloEsConstante(tipo) ? nombre : tipos[tdUndefined]);
      if (simboloEsConstante(tipo)) {
         sprintf(reg.longitud, "%lu", strlen(nombre));
      } else {
         sprintf(reg.longitud, "%s", "");
      }

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

   fprintf(fp, FORMATO_REG_TABLA_SIM, "NOMBRE", "TIPO", "VALOR", "LONGITUD");
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

/*
 * int obtenerCantidadDeSimbolos()
 *
 * Devuelve la cantidad de simbolos, que funciona como una variable privada dentro
 * del archivo tabla.c no se por que.
 *
 */

int obtenerCantidadDeSimbolos()
{
   return cantidadSimbolos;
}

int obtenerTipoSimbolo(const char* nombre)
{

   int i;

    for (i = 0; i < cantidadSimbolos; i++)
    {
          if (strcmp(tablaDeSimbolos[i].nombre, nombre) == 0)
          {
             if (strcmp(tablaDeSimbolos[i].tipo, tipos[tdString]) == 0 || strcmp(tablaDeSimbolos[i].tipo, tipos[tdConstString]) == 0)
               return tdString;

             if (strcmp(tablaDeSimbolos[i].tipo, tipos[tdInteger]) == 0 || strcmp(tablaDeSimbolos[i].tipo, tipos[tdConstInteger]) == 0)
               return tdInteger;

             if (strcmp(tablaDeSimbolos[i].tipo, tipos[tdFloat]) == 0 || strcmp(tablaDeSimbolos[i].tipo, tipos[tdConstFloat]) == 0)
               return tdFloat;
          }
    }
}


// FUNCIONES PRIVADAS

int simboloEsConstante(const char* tipo)
{
   if (strcmp(tipo, tipos[tdConstString]) == 0 || strcmp(tipo, tipos[tdConstInteger]) == 0 || strcmp(tipo, tipos[tdConstFloat]) == 0)
      return 1;

   return 0;
}

int tipoDeSimbolo(const char* nombre)
{
    int i;

    for (i = 0; i < MAX_SIM; i++)
    {
          if(strcmp(tablaDeSimbolos[i].nombre, nombre) == 0)
          {
            if(strcmp(tablaDeSimbolos[i].tipo,"Integer")==0)
            {
               return 1;
            }
            if(strcmp(tablaDeSimbolos[i].tipo,"Float")==0)
            {
               return 2;
            }
            if(strcmp(tablaDeSimbolos[i].tipo,"String")==0)
            {
               return 3;
            }
          }
    }
   return 0;
}
