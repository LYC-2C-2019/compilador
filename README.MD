# UNLaM - Lenguajes y Compiladores - 2do Cuatrimestre 2019

## Grupo: 4
### Integrantes:
- AMORUSO SERGIO FEDERICO
- PIACENTINI FEDERICO NICOLAS
- CABRERA GONZALO GERMAN
- SENDRAS BRUNO MARTIN
- SAN MARTIN LEONEL ALEJANDRO

### Temas Especiales:

|Generacion de Código Intermedio|Tema Especial 1|Tema Especial 2|
|:---:|:---:|:---:|
|Tercetos|INLIST|Asignaciones en línea múltiple|


## Ejemplo Minimo de Flex

Archivo: ./samples/lex.l
```c
/* Decaraciones C (opcional) */

/* Opciones */
%option noyywrap

/* Declaraciones */
DIGIT	[0-9]+
ALPHA	[a-zA-Z]*

%%
{DIGIT} { printf("%s", "DIGIT"); }
{ALPHA} { printf("%s", "ALPHA"); }

%%
/* Codigo de usuario C (opcional) */
int main() {
    /* Se invoca al automata autogenerado */
	yylex();
}
```
[Flex manpage](http://dinosaur.compilertools.net/flex/manpage.html)

### Compilar ejemplo basico de flex
```
cd samples
flex lexico.l
gcc lex.yy.c -o lexico.exe
./lexico.exe
```
Reconoce Letras, Digitos y Otros

Al ejecutar ./lexico.exe, el programa se queda a la espera del ingreso de caracteres a traves de la entrada estandar STDIN, (generalmente el teclado). Con cada ENTER el programa informa los tipo de token reconocido.

# Compilador

### Compilar el Compilador 😛
Windows:
```
./build.bat
```

Linux
```
./build.sh
```

### Ejecutar el Compilador
```
./Primera.exe Prueba.txt
```


# Herramientas
### Si te gusta C
- [Flex y bison para C](https://sites.google.com/view/lycunlam/compilador/herramientas)

### Si te gusta Java
- [flex](https://jflex.de/manual.html)
- [jcup](http://www2.cs.tum.edu/projects/cup/index.php)
