#include <string.h>

typedef struct _nodoP {
   int valor;
   struct _nodoP *anterior;
} tipoNodoPila;

typedef tipoNodoPila *pNodoPila;

typedef struct _pila {
   pNodoPila tope;
   pNodoPila base;
} Pila;


/* Funciones con pila: */
void apilar(Pila *p, int v);
int desapilar(Pila *p);
void mostrarPila(Pila *p);
int buscarEnPila(Pila *p, int v);
Pila crearPila();
void vaciarPila(Pila *p);
int pilaVacia(Pila*p);