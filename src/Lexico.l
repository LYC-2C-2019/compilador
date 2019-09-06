%{
#include <stdio.h>
#include <stdlib.h>

#if defined(__APPLE__) || defined(__linux__)
  #include <curses.h>
#elif defined(_WIN32)
  #include <conio.h>
#else
  #error "OS not suported"
#endif

#include "y.tab.h"

FILE  *yyin;
int yylval;

%}
%option noyywrap
%option yylineno

DIGITO			[0-9]
LETRA			[a-zA-Z]
ID			{LETRA}({LETRA}|{DIGITO}|_)*


%%
"="			{ return ASIG;}
"+"			{ return OP_SUMA;}
"-"			{ return OP_RESTA;}
"*"			{ return OP_MUL;}
"/"			{ return OP_DIV;}
"("			{ return P_A;}
")"			{ return P_C;}
{ID}			{ return ID;}

{DIGITO}+	      { yylval = atoi( yytext ) ;return ENTERO;}

"\n"
"\t"



