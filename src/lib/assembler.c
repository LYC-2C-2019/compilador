#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "assembler.h"
#include "tabla.h"


// FUNCIONES PUBLICAS

/** 
 * escribir_assembler
 * 
 * Esta funcion se encarga de escribir en el archivo pasado por parametro todo el codigo assembler
 * utilizando el contenido de la tabla de simbolos y de los tercetos generados en los pasos anteriores.
 * 
 * **/
void escribir_assembler (FILE* archivo)
{
    
    // escribo header (fijo)
    fprintf(archivo, "include macros2.asm\ninclude number.asm\n.MODEL LARGE\n.386\n.STACK 200h\n");

    // escribo seccion de datos, usando la tabla de simbolos
    escribir_seccion_datos(archivo);

    // escribo trailer (fijo)
	fprintf(archivo, "\t mov AX, 4C00h \t ; Genera la interrupcion 21h\n\t int 21h \t ; Genera la interrupcion 21h\nEND MAIN\n");
	
    fclose(archivo);
    
}



// FUNCIONES PRIVADAS

/** 
 * void escribir_seccion_datos(FILE*)
 * 
 * Escribe la parte .DATA correspondiente al archivo .asm, donde se declaran todas las variables.
 * 
 * **/
void escribir_seccion_datos(FILE *pf_asm)
{
	int i;

	fprintf(pf_asm, "\n.DATA\n");

    int cant = obtenerCantidadDeSimbolos();

	for (i = 0 ; i < cant ; i++)
	{
        
		simbolo_t simbolo = tablaDeSimbolos[i];

		if(strcmpi(simbolo.tipo, "Float") == 0 || strcmpi(simbolo.tipo, "Integer") == 0)
		{
			fprintf(pf_asm, "\t%s dd ?\t ; declaracion de variable numerica\n", asignar_nombre_variable_assembler(simbolo.nombre));            
		}
		else if(strcmpi(simbolo.tipo, "String") == 0)
		{
			fprintf(pf_asm, "\t%s db 30 dup (?),\"$\"\t; declaracion de variable String\n", asignar_nombre_variable_assembler(simbolo.nombre));
		}
		else if(strcmpi(simbolo.tipo, "ConstString") == 0)
		{
			fprintf(pf_asm, "\t%s db %s, \"$\", 30 dup (?)\t; declaracion de constante String\n", asignar_nombre_variable_assembler(simbolo.nombre), simbolo.valor);
		}
		else if(strcmpi(simbolo.tipo, "ConstInteger") == 0 || strcmpi(simbolo.tipo, "ConstFloat") == 0)
		{
			// Si se encuentra el caracter "." dentro del valor, es porque es una constante Float,
            // de lo contrario es una constate Integer
            if(strstr(simbolo.valor, "."))
            {                
				fprintf(pf_asm, "\t%s dd %s\t; declaracion de constante Float\n", asignar_nombre_variable_assembler(simbolo.nombre), simbolo.valor);
			} 
            else 
            {
				fprintf(pf_asm, "\t%s dd %s.0\t; declaracion de constante Integer\n", asignar_nombre_variable_assembler(simbolo.nombre), simbolo.valor);
			}
		}
	}
}


/** 
 * char* asignar_nombre_variable_assembler(char*)
 * 
 * Obtiene el nombre de la variable o la constante de la tabla de simbolos, y retorna
 * el nombre de la misma variable pero en formato adecuado para el codigo assembler.
 * 
 * **/
char* asignar_nombre_variable_assembler(char* cte_o_id) {
	char* nombreAsm = (char*) malloc(sizeof(char)*200);
	nombreAsm[0] = '\0';
	strcat(nombreAsm, "@"); // prefijo agregado
	
	if (!simboloEstaEnTabla(cte_o_id)) { //si no lo encuentro con el mismo nombre es porque debe ser cte		
		char *nomCte = (char*) malloc(31*sizeof(char));
		*nomCte = '\0';
		strcat(nomCte, "_");
		strcat(nomCte, cte_o_id);
	
		char *original = nomCte;
		while(*nomCte != '\0') {
			if (*nomCte == ' ' || *nomCte == '"' || *nomCte == '!' 
				|| *nomCte == '.') {
				*nomCte = '_';
			}
			nomCte++;
		}
		nomCte = original;
		strcat(nombreAsm, nomCte);
	} else {
		strcat(nombreAsm, cte_o_id);
	}
	
	return nombreAsm;
}
