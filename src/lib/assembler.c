#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "assembler.h"
#include "tabla.h"
#include "tercetos.h"



char lista_operandos_assembler[100][100];
int cant_op = 0;

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

    // escribo header de seccion de codigo
    fprintf(archivo,"\n.CODE\n.startup\n\tmov AX,@DATA\n\tmov DS,AX\n\n\tFINIT\n\n");

    // escribo seccion de codigo, usando los tercetos
    escribir_seccion_codigo(archivo);

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
void escribir_seccion_datos(FILE* pf_asm)
{
	int i;

	fprintf(pf_asm, "\n.DATA\n");

    int cantSimbolos = obtenerCantidadDeSimbolos();

	for (i = 0 ; i < cantSimbolos ; i++)
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


void escribir_seccion_codigo(FILE* pf_asm)
{

        int i, 
        j,
	    opSimple,  // Formato terceto (x,  ,  ) 
		opUnaria,  // Formato terceto (x, x,  )
		opBinaria, // Formato terceto (x, x, x)
        cantTercetos,
	    agregar_etiqueta_final_nro = -1;

      // escribo el contenido de la seccion de codigo
    cantTercetos = obtenerCantidadDeTercetos();

	for (i = 0 ; i < cantTercetos ; i++) 
	{
		if (strcmp("", tercetos[i]->t2) == 0) {
			opSimple = 1;
			opUnaria = 0;
			opBinaria = 0;
		} else if (strcmp("", tercetos[i]->t3) == 0) {
			opSimple = 0;
			opUnaria = 1;
			opBinaria = 0;
		} else {
			opSimple = 0; 
			opUnaria = 0;
			opBinaria = 1;
		}

		if (opSimple == 1) {
			
            // OPERACION SIMPLE:
            // * ID
            // * CONSTANTE

			cant_op++;
			strcpy(lista_operandos_assembler[cant_op], tercetos[i]->t1);

            printf("\nOPERACION SIMPLE TERCETO NRO %d: [%s, %s, %s]", i, tercetos[i]->t1, tercetos[i]->t2, tercetos[i]->t3);
		} 
		else if (opUnaria == 1) 
        {
            // OPERACION UNARIA:
            // * SALTO
            // * PRINT
			// * READ

            printf("\nOPERACION UNARIA TERCETO NRO %d: [%s, %s, %s]", i, tercetos[i]->t1, tercetos[i]->t2, tercetos[i]->t3);

            escribir_operacion_unaria(pf_asm, i);


			
	// 		if (strcmp("DISPLAY", tercetos[i].uno) == 0) 
	// 		{	
	// 			int tipo = buscarTipoTS(tercetos[atoi(tercetos[i].dos)].uno);
	// 			if (tipo == Float) 
	// 			{
	// 				fprintf(pf_asm, "\t DisplayFloat %s,2 \n", getNombreAsm(tercetos[atoi(tercetos[i].dos)].uno));
	// 			}
	// 			else if (tipo == Integer) 
	// 			{
	// 				fprintf(pf_asm, "\t DisplayFloat %s,2 \n", getNombreAsm(tercetos[atoi(tercetos[i].dos)].uno));
	// 			} else 
	// 			{
	// 				fprintf(pf_asm, "\t DisplayString %s \n", getNombreAsm(tercetos[atoi(tercetos[i].dos)].uno));
	// 			}
	// 			// Siempre inserto nueva linea despues de mostrar msj
	// 			fprintf(pf_asm, "\t newLine \n");
	// 		}
	// 		else if (strcmp("GET", tercetos[i].uno) == 0) 
	// 		{
	// 			int tipo = buscarTipoTS(tercetos[atoi(tercetos[i].dos)].uno);
	// 			if (tipo == Float) 
	// 			{
	// 				fprintf(pf_asm, "\t GetFloat %s\n", getNombreAsm(tercetos[atoi(tercetos[i].dos)].uno));
	// 			} 
	// 			else if (tipo == Integer) 
	// 			{
	// 				// pongo getfloat para manejar todo con fld en las operaciones
	// 				fprintf(pf_asm, "\t GetFloat %s\n", getNombreAsm(tercetos[atoi(tercetos[i].dos)].uno));
	// 			}	
	// 			else 
	// 			{
	// 				fprintf(pf_asm, "\t GetString %s\n", getNombreAsm(tercetos[atoi(tercetos[i].dos)].uno));
	// 			}
	// 		}
	// 		else // saltos
	// 		{
	// 			char *codigo = getCodOp(tercetos[i].uno);
	// 			sprintf(etiqueta_aux, "ETIQ_%d", atoi(tercetos[i].dos));
	// 			if (atoi(tercetos[i].dos) >= terceto_index) 
	// 			{
	// 				agregar_etiqueta_final_nro = atoi(tercetos[i].dos);
	// 			}
	// 			fflush(pf_asm); 
	// 			fprintf(pf_asm, "\t %s %s \t;Si cumple la condicion salto a la etiqueta\n", codigo, etiqueta_aux);
	// 		}
 		}
		else 
        {
            // OPERACION BINARIA:
            // * EXPRESION
            // * COMPARACION
			// * ASIGNACION

            printf("\nOPERACION BINARIA TERCETO NRO %d: [%s, %s, %s]", i, tercetos[i]->t1, tercetos[i]->t2, tercetos[i]->t3);

	// 		char *op2 = (char*) malloc(100*sizeof(char));
	// 		strcpy(op2, lista_operandos_assembler[cant_op]);
	// 		cant_op--;
	// 		char *op1 = (char*) malloc(100*sizeof(char));
	// 		if (strcmp(tercetos[i].uno, "CMP" ) == 0 && strcmp(ult_op1_cmp, tercetos[i].dos) == 0 )
	// 		{
	// 			strcpy(op1, op1_guardado);
	// 		}
	// 		else 
	// 		{
	// 			strcpy(op1, lista_operandos_assembler[cant_op]); 
	// 			cant_op--;
	// 			strcpy(op1_guardado, op1);
	// 		}
	// 		if (strcmp(tercetos[i].uno, "=" ) == 0)
	// 		{
	// 			int tipo = buscarTipoTS(tercetos[atoi(tercetos[i].dos)].uno);
	// 			if (tipo == Float | tipo == Integer) // Si se quiere separar integer hay que ver tambien las expresiones
	// 			{
	// 				fprintf(pf_asm, "\t FLD %s \t;Cargo valor \n", getNombreAsm(op1));
	// 				fprintf(pf_asm, "\t FSTP %s \t; Se lo asigno a la variable que va a guardar el resultado \n", getNombreAsm(op2));
	// 			}
	// 			else
	// 			{
	// 				fprintf(pf_asm, "\t mov si,OFFSET %s \t;Cargo en si el origen\n", getNombreAsm(op1));
	// 				fprintf(pf_asm, "\t mov di,OFFSET %s \t; cargo en di el destino \n", getNombreAsm(op2));
	// 				fprintf(pf_asm, "\t STRCPY\t; llamo a la macro para copiar \n");
	// 			}	
	// 		}
	// 		else if (strcmp(tercetos[i].uno, "CMP" ) == 0)
	// 		{
	// 			int tipo = buscarTipoTS(op1);
	// 			if (tipo == Float | tipo == Integer) 
	// 			{
	// 				fprintf(pf_asm, "\t FLD %s\t\t;comparacion, operando1 \n", getNombreAsm(op1));
	// 				fprintf(pf_asm, "\t FLD %s\t\t;comparacion, operando2 \n", getNombreAsm(op2));
	// 				fprintf(pf_asm, "\t FCOMP\t\t;Comparo \n");
	// 				fprintf(pf_asm, "\t FFREE ST(0) \t; Vacio ST0\n");
	// 				fprintf(pf_asm, "\t FSTSW AX \t\t; mueve los bits C a FLAGS\n");
	// 				fprintf(pf_asm, "\t SAHF \t\t\t;Almacena el registro AH en el registro FLAGS \n");
	// 			}
	// 			else
	// 			{
	// 				fprintf(pf_asm, "\t mov si,OFFSET %s \t;Cargo operando1\n", getNombreAsm(op1));
	// 				fprintf(pf_asm, "\t mov di,OFFSET %s \t; cargo operando2 \n", getNombreAsm(op2));
	// 				fprintf(pf_asm, "\t STRCMP\t; llamo a la macro para comparar \n");	
	// 			}

	// 			strcpy(ult_op1_cmp, tercetos[i].dos);
	// 		}
	// 		else
	// 		{
	// 			int tipo = buscarTipoTS(op1);
	// 			char* auxx;
	// 			if (tipo == String)
	// 			{
	// 				yyerror("Ops! No estan soportadas las operaciones entre cadenas\n");
	// 			}
	// 			sprintf(aux, "_aux%d", i); // auxiliar relacionado al terceto
	// 			insertar_ts_si_no_existe(aux, "FLOAT", "", "");
	// 			fflush(pf_asm);
	// 			fprintf(pf_asm, "\t FLD %s \t;Cargo operando 1\n", getNombreAsm(op1));
	// 			fprintf(pf_asm, "\t FLD %s \t;Cargo operando 2\n", getNombreAsm(op2));
	// 			fflush(pf_asm);
			
	// 			auxx=buscaDatoEnTerceto(1,i);


	// 			fprintf(pf_asm, "\t %s \t\t;Opero\n", getCodOp(auxx));
	// 			fprintf(pf_asm, "\t FSTP %s \t;Almaceno el resultado en una var auxiliar\n", getNombreAsm(aux));
	// 			cant_op++;
	// 			strcpy(lista_operandos_assembler[cant_op], aux);
	// 		}
			
	// 	}
	// }
	// if(agregar_etiqueta_final_nro != -1) {
	// 	sprintf(etiqueta_aux, "ETIQ_%d", agregar_etiqueta_final_nro);
	// 	fprintf(pf_asm, "%s: \n", etiqueta_aux);
	// }

        } // END IF

    } // END for

}


void escribir_operacion_unaria(FILE *pf_asm, int i)
{
    int tipo = 0;

    if (strcmp("PRINT", tercetos[i]->t1) == 0) 
    {	 
        tipo = obtenerTipoSimbolo(tercetos[i]->t2);

        if (tipo == tdFloat || tipo == tdInteger) 
        {
            fprintf(pf_asm, "\t DisplayFloat %s,2 \n", asignar_nombre_variable_assembler(tercetos[i]->t2));
        }
        else 
        {
            fprintf(pf_asm, "\t DisplayString %s \n", asignar_nombre_variable_assembler(tercetos[i]->t2));
        }
        // Siempre inserto nueva linea despues de mostrar msj
        fprintf(pf_asm, "\t newLine \n");
    }
    else if (strcmp("READ", tercetos[i]->t1) == 0) 
    {
        tipo = obtenerTipoSimbolo(tercetos[i]->t2);

        if (tipo == tdFloat || tipo == tdInteger)  
        {
            fprintf(pf_asm, "\t GetFloat %s\n", asignar_nombre_variable_assembler(tercetos[i]->t2));
        } 
        else 
        {
            fprintf(pf_asm, "\t GetString %s\n", asignar_nombre_variable_assembler(tercetos[i]->t2));
        }
    }
    // else // saltos
    // {
    //     char *codigo = getCodOp(tercetos[i].uno);
    //     sprintf(etiqueta_aux, "ETIQ_%d", atoi(tercetos[i].dos));
    //     if (atoi(tercetos[i].dos) >= terceto_index) 
    //     {
    //         agregar_etiqueta_final_nro = atoi(tercetos[i].dos);
    //     }
    //     fflush(pf_asm); 
    //     fprintf(pf_asm, "\t %s %s \t;Si cumple la condicion salto a la etiqueta\n", codigo, etiqueta_aux);
    // }

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
	
    // se agrega prefijo para distinguir de variables de usuario
    strcat(nombreAsm, "@"); 
	
	if (!simboloEstaEnTabla(cte_o_id)) {
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


/** 
 * char* obtener_instruccion_assembler(char*)
 * 
 * Obtiene la instruccion assembler correspondiente al token recibido por parametro.
 * 
 * **/
char* obtener_instruccion_assembler(char* token)
{
	if(strcmp(token, "+") == 0)
	{
		return "FADD";
	}
	else if(strcmp(token, "=") == 0)
	{
		return "MOV";
	}
	else if(strcmp(token, "-") == 0)
	{
		return "FSUB";
	}
	else if(strcmp(token, "*") == 0)
	{
		return "FMUL";
	}
	else if(strcmp(token, "/") == 0)
	{
		return "FDIV";
	}
}