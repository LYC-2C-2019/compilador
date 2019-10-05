#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "tercetos.h"

/* cantidad de tercetos */
int cant_tercetos = 0;

/** crea una estructura de datos de terceto */
t_terceto* nuevo_terceto (const char* t1, const char* t2, const char* t3)
{
    t_terceto* terceto = (t_terceto*) malloc(sizeof(t_terceto));
    // completo sus atributos
    strcpy(terceto->t1, t1);

    if (t2)
        strcpy(terceto->t2, t2);
    else
        *(terceto->t2) = '\0';

    if (t3)
        strcpy(terceto->t3, t3);
    else
        *(terceto->t3) = '\0';
    return terceto;
}

int crear_terceto(const char* t1, const char* t2, const char* t3)
{
    // creo un nuevo terceto y lo agrego a la coleccion de tercetos
    int numero = cant_tercetos;
    tercetos[numero] = nuevo_terceto (t1, t2, t3);
    cant_tercetos++;
    // devuelvo numero de terceto
    return numero;
}

void escribir_tercetos (FILE* archivo)
{
    int i;
    for (i = 0; i < cant_tercetos; i++)
        fprintf(archivo, "%d (%s, %s, %s)\n", i,
                                              tercetos[i]->t1,
                                              tercetos[i]->t2,
                                              tercetos[i]->t3);
}

void limpiar_tercetos ()
{
    int i;
    for (i = 0; i < cant_tercetos; i++)
        free(tercetos[i]);
}
