#ifndef PILA_H
#define PILA_H

/* Pila */
typedef struct s_nodo {
    int valor;
    struct s_nodo *sig;
} t_nodo;
typedef t_nodo* t_pila;

void insertar_pila (t_pila*, int);
int sacar_pila(t_pila*);
void crear_pila(t_pila*);
void destruir_pila(t_pila*);

#endif