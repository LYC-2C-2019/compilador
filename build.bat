cd src
c:\GnuWin32\bin\flex Lexico.l
pause
c:\GnuWin32\bin\bison -dyv Sintactico.y
pause
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o ..\bin\Primera.exe
pause
pause
cd ..
bin\Primera.exe test\Prueba.txt

cd src
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
pause
