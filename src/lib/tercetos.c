#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "tercetos.h"

int  crear_terceto(char* p_ope, char* p_te1, char* p_te2)
{
	terceto res;
	res.nroTerceto = indice_terceto;
	strcpy(res.ope, p_ope);
	strcpy(res.te1, p_te1);
	strcpy(res.te2, p_te2);
	strcpy(res.resultado_aux,"_");
	vector_tercetos[indice_terceto] = res;
	indice_terceto++;
	return indice_terceto-1;
}

void escribir_tercetos()
{
	FILE* arch;
	int i;
	terceto aux;
	arch = fopen("intermedia.txt", "w+");

	for(i = 0; i < indice_terceto; i++)
	{	
		aux =  vector_tercetos[i];
		fprintf(arch, "[%d] (%s,%s,%s)\n", aux.nroTerceto, aux.ope,aux.te1, aux.te2 );
		
	}
	fclose(arch);
}

int obtenerIndiceTercetos()
{
   return indice_terceto;
}

void setIndiceTercetos(int value)
{
   indice_terceto = value;
}