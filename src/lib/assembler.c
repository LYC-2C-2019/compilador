#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <conio.h>

#include "assembler.h"
#include "tabla.h"
#include "tercetos.h"
#include "const.h"

char bufferaux1[20];
int cant_op = 0;
int yyerror();

// FUNCIONES PUBLICAS

/** 
 * escribir_assembler
 * 
 * Esta funcion se encarga de escribir en el archivo pasado por parametro todo el codigo assembler
 * utilizando el contenido de la tabla de simbolos y de los tercetos generados en los pasos anteriores.
 * 
 * **/
void escribir_assembler(int cant_ctes)
{
    FILE *archivo;

    	if((archivo = fopen("Final.asm", "w"))==NULL){
        printf("No se puede crear el archivo \"Final.asm\"\n");
        exit(ERROR);
    }

    // escribo header (fijo)
    fprintf(archivo, "include macros2.asm\ninclude number.asm\n.MODEL LARGE\n.386\n.STACK 200h\n\nMAXTEXTSIZE EQU 32\n\n");

    // escribo seccion de datos, usando la tabla de simbolos
    escribir_seccion_datos(archivo, cant_ctes);

    // escribo header de seccion de codigo
    fprintf(archivo, "\n.CODE\n.startup\n\tmov AX,@DATA\n\tmov DS,AX\n\n\tFINIT\n\n");

    // escribo seccion de codigo, usando los tercetos
    escribir_seccion_codigo(archivo);

    // escribo trailer (fijo)
    fprintf(archivo, "\nMOV AH, 1\nINT 21h\nMOV AX, 4C00h\nINT 21h\n\nEND START\n");

    fclose(archivo);
}

// FUNCIONES PRIVADAS

void escribir_seccion_datos(FILE *archivoAssembler, int cant_ctes) {
    int i;
	char valorAuxiliar[100];

	fprintf(archivoAssembler, ".DATA\n");
	
	for(i=0; i < cant_ctes; i++)
	{
		char nombre [100];
		
		strcpy(nombre,  tablaDeSimbolos[i].nombre);
		if(tablaDeSimbolos[i].TipodeDato_numerico==constanteFloat){
			replace_char(nombre,'.', '_');
		}
		
		fprintf(archivoAssembler, "%s ", nombre);
		strcpy(valorAuxiliar, tablaDeSimbolos[i].valor);

		switch(tablaDeSimbolos[i].TipodeDato_numerico){
		case variableEntera:
			fprintf(archivoAssembler, "dd %s?\n", valorAuxiliar);
			break;

		case variableFloat:
			fprintf(archivoAssembler, "dd %s?\n", valorAuxiliar);
			break;

		case variableString:
			fprintf(archivoAssembler, "dd %s?\n", valorAuxiliar);        
			break;

		case constanteEntera:
			strcpy(bufferaux1,".0");				// transformo la constante int en un float para poder usar FLD en el coProcesador
			strcat(valorAuxiliar,bufferaux1);
			fprintf(archivoAssembler, "dd %s\n", valorAuxiliar);
			break;

		case constanteFloat:
			fprintf(archivoAssembler, "dd %s\n", valorAuxiliar);
			break;

		case constanteString:
			fprintf(archivoAssembler, "db \"%s\", '$'\n", valorAuxiliar);
			break;

		default: //Es una variable int, float o puntero a string
			fprintf(archivoAssembler, "dd ?\n");
		}
	}

	fprintf(archivoAssembler, "\n");
	fprintf(archivoAssembler, ".CODE\n\nSTART:\n\nMOV AX,@DATA\nMOV DS, AX\nFINIT\n\n");
}

void escribir_seccion_codigo(FILE *archivoAssembler)
{
	int i;
    int indice_terceto = obtenerIndiceTercetos();

	for(i=0;i< indice_terceto;i++)
	{		        

		if(vector_tercetos[i].esEtiqueta == 99)
		{
            // printf("\nVALOR i: %d", i);
            // printf("\nES ETIQUETA[%s, %s, %s]", vector_tercetos[i].te1, vector_tercetos[i].te2, vector_tercetos[i].resultado_aux);
			fprintf(archivoAssembler,"etiqueta_%d:\n",i);		
		}

        // printf("ES OPERACION %d", esOperacion(i));
        // printf("\n[%s, %s, %s]", vector_tercetos[i].te1, vector_tercetos[i].te2, vector_tercetos[i].resultado_aux);
		
		switch(esOperacion(i))
		{
		case 1:
			fprintf(archivoAssembler,"fld %s\nfld %s\nfadd\nfstp %s\n",vector_tercetos[i].te1,vector_tercetos[i].te2, vector_tercetos[i].resultado_aux);
			break;
			
		case 2:
			fprintf(archivoAssembler,"fld %s\nfld %s\nfsub\nfstp %s\n", vector_tercetos[i].te1,vector_tercetos[i].te2, vector_tercetos[i].resultado_aux);
			break;
			
		case 3:
			fprintf(archivoAssembler,"fld %s\nfld %s\nfmul\nfstp %s\n", vector_tercetos[i].te1,vector_tercetos[i].te2, vector_tercetos[i].resultado_aux);
			break;
			
		case 4:
			fprintf(archivoAssembler,"fld %s\nfld %s\nfdiv\nfstp %s\n", vector_tercetos[i].te1,vector_tercetos[i].te2, vector_tercetos[i].resultado_aux);
			break;
			
		case 5:
			fprintf(archivoAssembler,"fld %s\nfstp %s\n", vector_tercetos[i].te2, vector_tercetos[i].te1);
			break;
			
		case 6:
			fprintf(archivoAssembler,"DisplayFloat %s,1\nnewLine\n\n", vector_tercetos[i].te1);
			break;
			
		case 7:
			fprintf(archivoAssembler,"DisplayString %s,1\nnewLine\n\n", vector_tercetos[i].te1);
			break;
			
		case 8: //Read enteros
			fprintf(archivoAssembler,"DisplayString @msj_entero \n");
			fprintf(archivoAssembler,"int 21h \n");
			fprintf(archivoAssembler,"newLine 1\n");
			fprintf(archivoAssembler,"GetFloat %s \n",vector_tercetos[i].te1);
			break;
			
		case 9: //Read Real
			fprintf(archivoAssembler,"DisplayString @msj_real \n");
			fprintf(archivoAssembler,"int 21h \n");
			fprintf(archivoAssembler,"newLine 1\n");
			fprintf(archivoAssembler,"GetFloat %s \n",vector_tercetos[i].te1);
			break;
			
		case 10:
			fprintf(archivoAssembler,"LEA EAX, %s\n MOV %s , EAX\n", vector_tercetos[i].te2, vector_tercetos[i].te1);
			break;
			
		case 11:
			fprintf(archivoAssembler,"DisplayFloat %s,3\nnewLine\n\n", vector_tercetos[i].te1);
			break;
			
		}
		
		
		if(strcmp(vector_tercetos[i].ope,"CMP")==0)						// terceto de COMPARACION
		fprintf(archivoAssembler,"fld %s\nfld %s\nfxch\nfcomp\nfstsw ax\nsahf\n", vector_tercetos[i].te1,vector_tercetos[i].te2);
		
		
		switch(esSalto(i))
		{		
		case 1:
			fprintf(archivoAssembler,"JNA %s\n\n", vector_tercetos[i].te1);			// condicion >
			break;
			
		case 2:
			fprintf(archivoAssembler,"JAE %s\n\n", vector_tercetos[i].te1);			// condicion <
			break;
			
		case 3:
			fprintf(archivoAssembler,"JNAE %s\n\n", vector_tercetos[i].te1);			// condicion >=
			break;
			
		case 4:
			fprintf(archivoAssembler,"JA %s\n\n", vector_tercetos[i].te1);			// condicion <=
			break;
			
		case 5:
			fprintf(archivoAssembler,"JNE %s\n\n", vector_tercetos[i].te1);			// condicion ==
			break;
			
		case 6:
			fprintf(archivoAssembler,"JE %s\n\n", vector_tercetos[i].te1);			// condicion !=
			break;
			
		case 7:
			fprintf(archivoAssembler,"JMP %s\n\n", vector_tercetos[i].te1);			// salto incondicional
			break;
		}
		
		
	}
}


void preparar_assembler()
{
	char etiqueta[20] = "etiqueta_";
	int entero_aux;
    int i;
    int j;
    int indice_terceto = obtenerIndiceTercetos();
	
	/*printf("ANTES: \n\n");
	for(i=0;i<indice_terceto;i++)
	{
		printf("%-5s%-5s%-5s%-5s%-5d%\n",vector_tercetos[i].ope,vector_tercetos[i].te1,vector_tercetos[i].te2,vector_tercetos[i].resultado_aux,vector_tercetos[i].esEtiqueta);
	}*/

	for(i=0;i<indice_terceto;i++)
	{
		
		if(strcmp(vector_tercetos[i].te1,"_")==0 && strcmp(vector_tercetos[i].te2,"_")==0 && vector_tercetos[i].esEtiqueta!=99 )
		{
			//printf("ESTOY EN _ , _ : %d\n",i);
			//printf("OPE: %s - TE1: %s - TE2: %s\n",vector_tercetos[i].ope,vector_tercetos[i].te1,vector_tercetos[i].te2);
			for(j=i+1;j< indice_terceto;j++)
			{
				itoa(i,bufferaux1,10);
				if(strcmp(vector_tercetos[j].te1,bufferaux1)==0)
				{
					strcpy(vector_tercetos[j].te1,vector_tercetos[i].ope);
				}
				if(strcmp(vector_tercetos[j].te2,bufferaux1)==0)
				{
					strcpy(vector_tercetos[j].te2,vector_tercetos[i].ope);
				}
			}
		}
		
		if(strcmp(vector_tercetos[i].te1,"_")==0 && strcmp(vector_tercetos[i].te2,"_")==0 && vector_tercetos[i].esEtiqueta==99 )
		{
			//printf("ETIQUETA + TERCETO _ _\n");
			j=i+1;
			itoa(i,bufferaux1,10);
			while(strcmp(vector_tercetos[j].te1,bufferaux1)!=0 && strcmp(vector_tercetos[j].te2,bufferaux1)!=0)
			j++;
			if(strcmp(vector_tercetos[j].te1,bufferaux1)==0)
			strcpy(vector_tercetos[j].te1,vector_tercetos[i].ope);
			else
			strcpy(vector_tercetos[j].te2,vector_tercetos[i].ope);
			
		}
		
		if(esOperacion(i))
		{
			//printf("ESTOY EN esOperacion : %d\n",i);
			for(j=i+1;j< indice_terceto;j++)
			{	
				itoa(i,bufferaux1,10);
				if(strcmp(vector_tercetos[j].te1,bufferaux1)==0)
				{
					strcpy(vector_tercetos[j].te1,vector_tercetos[i].resultado_aux);
				}
				
				if(strcmp(vector_tercetos[j].te2,bufferaux1)==0)
				{
					strcpy(vector_tercetos[j].te2,vector_tercetos[i].resultado_aux);
				}
				
			}
			
		}
		
		if(esSalto(i))
		{	
			//printf("OPE: %s - TE1: %s - TE2: %s\n",vector_tercetos[i].ope,vector_tercetos[i].te1,vector_tercetos[i].te2);
			entero_aux = atoi(vector_tercetos[i].te1);
			//printf("entero_aux: %d\n",entero_aux);
			vector_tercetos[entero_aux].esEtiqueta = 99;
			strcat(etiqueta,vector_tercetos[i].te1);
			//printf("ETIQUETA: %s\n",etiqueta);
			strcpy(vector_tercetos[i].te1,etiqueta);
			//printf("vector_tercetos[%d].te1: %s\n",i,vector_tercetos[i].te1);
			strcpy(etiqueta,"etiqueta_");
		}
		
	}
	
	/*printf("DESPUES: \n\n");
	for(i=0;i<indice_terceto;i++)
	{
		printf("%-5s%-5s%-5s%-5s%-5d%\n",vector_tercetos[i].ope,vector_tercetos[i].te1,vector_tercetos[i].te2,vector_tercetos[i].resultado_aux,vector_tercetos[i].esEtiqueta);
	}*/
}

int esOperacion(int indice)
{
	if(strcmp(vector_tercetos[indice].ope,"+")==0)
	return 1;	
	if(strcmp(vector_tercetos[indice].ope,"-")==0)
	return 2;
	if(strcmp(vector_tercetos[indice].ope,"*")==0)
	return 3;
	if(strcmp(vector_tercetos[indice].ope,"/")==0)
	return 4;
	if(strcmp(vector_tercetos[indice].ope,"=")==0){
		validaTipo(vector_tercetos[indice].te1);
		if(aux_tiponumerico==3 || aux_tiponumerico==6){				// asignacion de una CADENA
			return 10;
		}
		
		return 5;
	}
	
	if(strcmp(vector_tercetos[indice].ope,"PRINT")==0)
	{
		validaTipo(vector_tercetos[indice].te1);
		if(aux_tiponumerico==1 || aux_tiponumerico==4)		// se trata de variables o ctes int
		return 6;
		if(aux_tiponumerico==2 || aux_tiponumerico==5)		// se trata de una variable o cte float
		return 11;
		else
		return 7;											// sino es de tipo CADENA
	}
	if(strcmp(vector_tercetos[indice].ope,"READ")==0){
		validaTipo(vector_tercetos[indice].te1);
		if(aux_tiponumerico==1){ //Variable Entera
			return 8;
		}
		if(aux_tiponumerico==2){ //Variable Float
			return 9;
		}
	}
	
	//OJO NO USAR 10 YA HAY UN 10 en la sentencia que devuelve 5
	return 0;
}

int esSalto(int indice)
{	
	if(strcmp(vector_tercetos[indice].ope,"JNA")==0)		// >
	return 1;
	
	if(strcmp(vector_tercetos[indice].ope,"JAE")==0)		// <
	return 2;
	
	if(strcmp(vector_tercetos[indice].ope,"JNAE")==0)		// >=
	return 3;
	
	if(strcmp(vector_tercetos[indice].ope,"JA")==0)			// <=
	return 4;
	
	if(strcmp(vector_tercetos[indice].ope,"JNE")==0)		// ==
	return 5;
	
	if(strcmp(vector_tercetos[indice].ope,"JE")==0)			// !=
	return 6;
	
	if(strcmp(vector_tercetos[indice].ope,"JMP")==0)		// salto incondicional
	return 7;
	
	return 0;
}

int obteneraux_tiponumerico()
{
   return aux_tiponumerico;
}