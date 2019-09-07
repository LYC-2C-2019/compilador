# Primera Entrega

### Elementos lexicos

|TOKEN|LEXEMA|UNICO|DEFINICION|COTA|
|:---|:---|:---:|:---|:---|
|DOT|.|SI|Punto, o Punto decimal||
|COLON|:|SI|Dos puntos||
|SCOLON|;|SI|Punto y coma||
|COMA|,|SI|Coma||
|EQ|=|SI|Signo igual||
|LT|<|SI|Signo menor, operador "menor que"||
|LE|<=|SI|`LT` seguido de `EQ`. Operador "menor o igual que"||
|GT|>|SI|Signo mayor, operador "mayor que"||
|GE|>=|SI|`GT` seguido de `EQ`. Operador "mayor o igual que"||
|EQT|==|SI|`EQ` seguide de `EQ`. Operador "igual a"||
|ASIG|:=|SI|`COLON` seguido de `EQ`. Operador de asignación||
|SLASH|/|SI|Barra u operador de división||
|STAR|*|SI|Asterisco u operador de  multiplicación||
|PLUS|+|SI|Signo más u operador de suma||
|DASH|-|SI|Guión, signo menos u operador de resta||
|US|_|SI|Guión bajo||
|BRA_O|(|SI|Parentesis que abre||
|BRA_C|)|Parentesis que cierra||
|SBRA_O|[|SI|Corchete que abre||
|SBRA_C|[|SI|Corchete que cierra||
|CBRA_O|[|SI|Llave que abre||
|CBRA_C|[|SI|Llave que cierra||
|COMM_O|--/|SI|Comentario que abre. `DASH` seguido de `DASH` seguido de `SLASH`||
|COMM_C|--/|SI|Comentario que cierra. `SLASH` seguido de `DASH` seguido de `DASH`||
|DQUOTE|"|SI|Comillas dobles||
|ALPHA|a..z y A..Z|NO|Letra mayúscula o minúscula||
|DIGIT|0..9|NO|Numeros del 0 al 9||
|ID|varName, _varName, var_name, v4rNam3_ |NO|Cominezan `ALPHA` o `US`. Pueden contener `ALPHA`, `US` y `DIGIT`||
|CTE_S|"C4d3n4 de T3xt0", 'C4d3n4 de T3xt0'|NO|Cualquier conjunto de caracteres delimitados por `DQUOTE`. Hasta 30 caracteres||
|CTE_I|1234, 34560, ...|NO|Comienza con `DIGIT` > 0, pude continuar con cualquier conjunto de `DIGIT`||
|CTE_F|99999.99, 99., .9999|NO|Comienza con 0 o más `DIGIT` > 0 seguido de DOT, Puede continuar con cualquier conjunto de 0 o más `DIGIT`. Debe contener solo una ocurrencia de DOT||
|REPEAT|REPEAT|SI|Palabra reservada `REPEAT`. Estructura de iteración repeat-until||
|UNTIL|UNTIL|SI|Palabra reservada `UNTIL`. Estructura de iteración repeat-until||
|VAR|VAR|SI|Palabra reservada `VAR`. Bloques de declaracion de variables||
|ENDVAR|ENDVAR|SI|Palabra reservada `ENDVAR`. Bloques de declaracion de variables||
|INTEGER|Integer|SI|Palabra reservada `Integer`. Tipo de dato entero, declaraciones de variables|16 bit|
|FLOAT|Float|SI|Palabra reservada `Float`|32 bit|
|INLIST|INLIST|SI|Palabra reservada `INLIST`||
|MOD|MOD|SI|Palabra reservada `MOD`||
|DIV|DIV|SI|Palabra reservada `DIV`||
|CONST|const|SI|Palabra reservada `const`||