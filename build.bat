@echo off
cd src
echo COMPILACION FLEX
flex Lexico.l
REM pause
echo COMPILACION BISON
bison -dyv Sintactico.y
REM pause
echo COMPILACION GCC
gcc.exe lib\*.c lex.yy.c y.tab.c -o ..\bin\Grupo04.exe
REM pause
cd ..
echo EJECUCION DE PRUEBAS
bin\Segunda.exe test\Prueba.txt
cd src
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
cd ..
pause
