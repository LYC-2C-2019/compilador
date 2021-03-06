# Primera Entrega

### Elementos lexicos

|TOKEN|LEXEMA|UNICO|DEFINICION|COTA|PATTERN|
|:---|:---|:---:|:---|:---|:---|
|COLON|:|SI|Dos puntos. Usado dentro del bloque de declaraciones.|||
|SCOLON|;|SI|Punto y coma. Usado para finalizar sentencias.|||
|COMMA|,|SI|Coma. Usado dentro del bloque de declaraciones y en asignación en línea múltiple.|||
|COMP|<, <=, >, >=, ==, <>|NO|Operadores de comparación|||
|ASSIG|:=|SI|`COLON` seguido de `EQ`. Operador de asignación|||
|SLASH|/|SI|Barra u operador de división|||
|STAR|*|SI|Asterisco u operador de  multiplicación|||
|PLUS|+|SI|Signo más u operador de suma|||
|DASH|-|SI|Guión, signo menos u operador de resta|||
|BRA_O|(|SI|Parentesis que abre|||
|BRA_C|)|SI|Parentesis que cierra||
|SBRA_O|[|SI|Corchete que abre|||
|SBRA_C|]|SI|Corchete que cierra|||
|CBRA_O|{|SI|Llave que abre|||
|CBRA_C|}|SI|Llave que cierra|||
|COMMENT|--/ 3st0 3s un c0m3nt4r1 0 /*-+ FIN /--|NO|Cualquier conjunto de caracteres excepto “newline” delimitados por “--/” y “/--”|||
|ALPHA|a..z y A..Z|NO|Letra mayúscula o minúscula|||
|DIGIT|0..9|NO|Numeros del 0 al 9|||
|ID|varName, _varName, var_name, v4rNam3_ |NO|Cominezan `ALPHA` o `UNDERSCORE`. Pueden contener `ALPHA`, `UNDERSCORE` y `DIGIT`|||
|CTE_S|"C4d3n4 de T3xt0%@"|NO|Cualquier conjunto de caracteres delimitados por `DQUOTE`|Hasta 30 caracteres||
|CTE_I|1234, 34560, ...|NO|Comienza con `DIGIT` > 0, pude continuar con cualquier conjunto de `DIGIT`|||
|CTE_F|99999.99, 99., .9999|NO|Comienza con 0 o más `DIGIT` > 0 seguido de DOT, Puede continuar con cualquier conjunto de 0 o más `DIGIT`. Debe contener solo una ocurrencia de DOT|||
|INTEGER|Integer|SI|Palabra reservada `Integer`. Tipo de dato entero, declaraciones de variables|16 bit||
|FLOAT|Float|SI|Palabra reservada `Float. Tipo de dato flotante, declaraciones de variables|32 bit||
|STRNG|String|SI|Palabra reservada “String” para referirse al tipo de dato para cadenas|String||
|REPEAT|REPEAT|SI|Palabra reservada `REPEAT`. Estructura de iteración repeat-until|||
|UNTIL|UNTIL|SI|Palabra reservada `UNTIL`. Estructura de iteración repeat-until|||
|IF|IF|SI|Palabra reservada `IF`. Estructura de decición if|||
|THEN|THEN|Palabra reservada `THEN`. Estructura de decición if|||
|ELSE|ELSE|Palabra reservada `ELSE`. Estructura de decición if|||
|ENDIF|ENDIF|SI|Palabra reservada `ENDIF`. Estructura de decicion if|||
|AND|AND|SI|Palabra reservada `AND`. Operador logico and. Condiciones|||
|OR|OR|SI|Palabra reservada `OR`. Operador logico or. Condiciones|||
|NOT|NOT|SI|Palabra reservada `NOT`. Operador logico not. Condiciones|||
|PRINT|PRINT|SI|Palabra reservada `PRINT`. Salida por pantalla|||
|READ|READ|SI|Palabra reservada `READ`. Entrada por teclado|||
|VAR|VAR|SI|Palabra reservada `VAR`. Bloques de declaracion de variables|||
|ENDVAR|ENDVAR|SI|Palabra reservada `ENDVAR`. Bloques de declaracion de variables|||
|INLIST|INLIST|SI|Palabra reservada INLIST. Función del lenguaje que permite buscar el valor de una variable dentro de una lista de expresiones.|||

