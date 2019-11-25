#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "tabla.h"

int yyerror();

void guardarTablaDeSimbolos(int cantidadTokens, int cant_ctes){

	// Verifico si se cargo algo en la tabla
	if(cantidadTokens == -1)
	yyerror();

	FILE* arch = fopen("ts.txt", "w+");
	if(!arch){
		printf("No se pudo abrir archivo ts.txt\n");
		return;
	}

	fprintf(arch,"%-30s%-25s%-30s%-5s\n","NOMBRE","TIPO","VALOR", "LONGITUD");
	fprintf(arch, "======================================================================================================\n");
	
	// Recorro la tabla
	int i = 0;
	while (i < cant_ctes) {

		fprintf(arch, "%-30s%-25s%-30s%-5d\n", &(tablaDeSimbolos[i].nombre), &(tablaDeSimbolos[i].tipo) , &(tablaDeSimbolos[i].valor), tablaDeSimbolos[i].longitud);
		//printf("%-30s%-20s%-30s%-5d%\n", &(tablaDeSimbolos[i].nombre), &(tablaDeSimbolos[i].tipo) , &(tablaDeSimbolos[i].valor), tablaDeSimbolos[i].TipodeDato_numerico);
		i++;
	}

	fclose(arch);
}
