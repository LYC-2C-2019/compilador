#ifndef TERCETOS_H
#define TERCETOS_H


/* cantidad de tercetos */
static int cant_tercetos = 0;

// /* estrutura de un terceto */
// typedef struct s_terceto {
//     char t1[MAX_STRING],
//          t2[MAX_STRING],
//          t3[MAX_STRING];
// } t_terceto;

// /* coleccion de tercetos */
// t_terceto* tercetos[MAX_TERCETOS];

/* estrutura de un terceto */
	typedef struct terceto {
		int nroTerceto;
		char ope[35];
		char te1[30];
		char te2[30];
		char resultado_aux[10];
		int esEtiqueta;
	}	terceto;

/* coleccion de tercetos */
terceto vector_tercetos[1000];

static int indice_terceto = 0;	

/* reserva memoria para un terceto terceto */
// t_terceto* nuevo_terceto(const char*, const char*, const char*);
/* crea un terceto y lo agrega a la coleccion */
int crear_terceto(char*, char*, char*);
/* escribe los tercetos en un archivo */
void escribir_tercetos();
// /* libera memoria pedida para tercetos */
// void limpiar_tercetos();
// /* devuelve la cantidad de tercetos, funciona como un get de una variable privada 
// si no se usa una funcion, no se puede acceder al valor de la variable no se por que */
int obtenerIndiceTercetos();
void setIndiceTercetos(int);

#endif