#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "pila.h"

int pila_vacia(t_pila* p) {
    return (*p == NULL);
}

void insertar_pila (t_pila *p, int valor) {
    t_nodo *nodo = (t_nodo*) malloc (sizeof(t_nodo));
    nodo->valor = valor;
    nodo->sig = *p;
    *p = nodo;
}

int sacar_pila(t_pila *p) {
    int valor = -1;
    t_nodo *aux;
    if (*p != NULL) {
       aux = *p;
       valor = aux->valor;
       *p = aux->sig;
       free(aux);
    }
    return valor;
}

void crear_pila(t_pila *p) {
    *p = NULL;
}

void destruir_pila(t_pila *p) {
    while (sacar_pila(p) > 0);
}