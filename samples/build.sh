#!/bin/bash
flex lexico.l
gcc lex.yy.c -o lexico.exe
./lexico.exe