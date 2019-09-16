# Primera Entrega
## Reglas Gramaticales
### Programa Generico
< programa > -> < declaraciones > < bloque >  
< bloque > -> < bloque > < sentencia >  
< bloque > -> < sentencia >  

### Declaraciones
< declaraciones > -> VAR < lista-declaraciones > ENDVAR  
< lista-declaraciones > -> < lista-declaraciones > COMMA < declaracion >  
< lista-declaraciones > -> < declaracion >  
< declaracion > -> SBRA_O < lista-tipos > SBRA_C COLON SBRA_O < lista-ids > SBRA_C  
< lista-tipos > -> < lista-tipos > COMMA < tipo >  
< lista-tipos > -> < tipo >  
< tipo > -> INTEGER | FLOAT | STRING  

### Asignacion
< asignacion > -> < asignacion-simple >  
< asignacion > -> < asignacion-multiple >  

### Asignacion Simple
< asignacion-simple > -> ID ASIG < expresion >  
< asignacion-simple > -> ID ASIG CONST_S  

### Asignacion Multiple
< asignacion-multiple > -> SBRA_O < lista-ids > SBRA_C ASIG SBRA_O < lista-expresiones-comma > SBRA_C  
< lista-expresiones-comma > -> < lista-expresiones-comma > COMMA < expresion >  
< lista-expresiones-comma > -> < expresion >  
< lista-expresiones-scolon > -> < lista-expresiones-scolon > SCOLON < expresion >  
< lista-expresiones-scolon > -> < expresion >  
< lista-ids > -> < lista-ids > COMMA ID  
< lista-ids > -> ID  

### Tipo de Estructuras o Sentencias
< sentencia > -> < expresion > SCOLON  
< sentencia > -> < asignacion > SCOLON  
< sentencia > -> < seleccion >  
< sentencia > -> < iteracion >  
< sentencia > -> < impresion > SCOLON  
< sentencia > -> < lectura > SCOLON  
< sentencia > -> < funcion > SCOLON  

### Expresion
< expresion > -> < expresion > PLUS < termino >  
< expresion > -> < expresion > DASH < termino >  
< expresion > -> < termino >  

### Termino
< termino > -> < termino > STAR < factor >  
< termino > -> < termino > SLASH < factor >  
< termino > -> < factor >  

### Factor
< factor > -> ID  
< factor > -> CONST_I  
< factor > -> CONST_F  
< factor > -> BRA_O < expresion > BRA_C  

### Seleccion
< seleccion > -> < ifelse >  
< ifelse > -> IF < condicion > THEN < bloque > ENDIF  
< ifelse > -> IF < condicion > THEN < bloque > ELSE < bloque > ENDIF  
< condicion > -> < proposicion>  
< condicion > -> < proposicion> AND < proposicion >  
< condicion > -> < proposicion> OR < proposicion >  
< condicion > -> NOT < proposicion>  
< proposicion > -> funcion  
< proposicion > -> comparacion  
< comparacion > -> BRA_O < expresion > COMP < expresion > BRA_C  

### Iteracion
< iteracion > -> < repeat >  
< repeat > -> REPEAT < bloque > UNTIL < condicion >  

### Impresion por Pantalla
< impresion > -> PRINT CTE_S  
< impresion > -> PRINT ID  

### Ingreso por Teclado
< lectura > -> READ ID  

### Funcion INLIST
< funcion > -> < inlist >  
< inlist > -> INLIST BRA_O ID COMMA SBRA_O < lista-expresiones-scolon > SBRA_C BRA_C  