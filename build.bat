@echo off
cd src
echo COMPILACION FLEX
c:\GnuWin32\bin\flex Lexico.l
REM pause
echo COMPILACION BISON
c:\GnuWin32\bin\bison -dyv Sintactico.y
REM pause
echo COMPILACION GCC
c:\MinGW\bin\gcc.exe Tabla.c lex.yy.c y.tab.c -o ..\bin\Primera.exe
REM pause
cd ..
echo EJECUCION DE PRUEBAS
bin\Primera.exe test\Prueba.txt
cd src
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
cd ..
pause
