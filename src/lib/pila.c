#include <stdio.h>
#include <stdlib.h>
#include "pila.h"

Pila crearPila()
{
   Pila pila;
   pila.base = NULL;
   pila.tope = NULL;
   return pila;
}

void vaciarPila(Pila *pila)
{
   pila->base = NULL;
   pila->tope = NULL;
}

void apilar(Pila *pila, int v){
   /* Crear un nodo nuevo */
   pNodoPila nuevo = (pNodoPila)malloc(sizeof(tipoNodoPila));
   nuevo->valor = v;

   if(pila->tope == NULL)
   {
      pila->base = pila->tope = nuevo;
      nuevo->anterior = NULL;
   } else {
      nuevo->anterior = pila->tope;
      pila->tope = nuevo;
   }
}


int desapilar(Pila *pila){
	if(pila->tope == NULL){
		return 0;
	}
	pNodoPila aux;
	int res;
	res = pila->tope->valor;
	aux = pila->tope;
	pila->tope = pila->tope->anterior;
	free(aux);
	return res;
}

int buscarEnPila(Pila *pila, int v){
	if(pila->tope == NULL){
		return 0;
	}
	pNodoPila aux;
	aux = pila->tope;
	while(aux != NULL)
	{
		if (aux->valor == v)
		{
			return 1;
		}
		aux = aux->anterior;
	}
	return 0;

}

void mostrarPila(Pila *pila)
{
   pNodoPila nodo = pila->tope;
   while(nodo)
   {
      printf("%s\n", nodo->valor);
      nodo = nodo->anterior;
   }

}

int pilaVacia(Pila *pila)
{
	return pila->tope == NULL;
}