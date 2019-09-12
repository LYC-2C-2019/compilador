#!/bin/bash

N=$1;

if [ -z N ]; then
    N=1;
fi
if [[ $N -lt 0 || $N -gt 2 ]]; then
    echo "Numero de entrega invalido, (0 = Primera Entrega, 1 = Segunda Entega 2 = Entrega Final)";
    exit;
fi;

entregas=("Primera" "Segunda" 'Final');

cd src

echo "";
echo "Generando snalizador léxico";
flex *.l
read -p "Presione una tecla para continuar...";

echo "";
echo "Generando snalizador sintáctico";
bison -dyv *.y
read -p "Presione una tecla para continuar...";

echo "";
echo "Compilando procesador de lenguaje";
gcc *.c -o "../bin/${entregas[$N]}.exe"
read -p "Presione una tecla para continuar...";

cd ..

echo "";
echo "Ejecutando procesador sobre prueba.txt";
./bin/${entregas[$n]}.exe test/prueba.txt;
echo "Completado";
read -p "Presione una tecla para continuar...";

cd src

echo "";
echo "Limpiando temporales";
rm lex.yy.c
rm y.tab.c
rm y.output
rm y.tab.h
echo "Fin";