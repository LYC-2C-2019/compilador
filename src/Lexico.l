%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#if defined(__APPLE__) || defined(__linux__)
	#include <curses.h>
#elif defined(_WIN32)
	#include <conio.h>
#else
	#error "OS not suported"
#endif
#include <math.h>

#include "y.tab.h"

#include "lib/const.h"
#include "lib/tabla.h"

// VARIABLES GLOBALES
char *end;
int validateID(char * id);
int validateString(char * str);
int validateInteger(int Value);
int validateFloat(float Value);
%}
%option noyywrap
%option yylineno

/* TAGS */
LT       <
LE       <=
GT       >
GE       >=
EQ       ==
NE       <>
D1TO9    [1-9]
DIGIT    [0-9]
ALPHA    [a-zA-Z]
DOT      \.
NEWLINE  \n
ANYCHAR  .*
COMM_O   --\/
COMM_C   \/--

COMP     {LT}|{LE}|{GT}|{GE}|{EQ}|{NE}
COMMENT  {COMM_O}{ANYCHAR}{COMM_C}
ID       ({ALPHA}|_)({ALPHA}|{DIGIT}|_)*
CTE_S    \"{ANYCHAR}\"
CTE_I    ([1-9]{DIGIT}+|{DIGIT})
CTE_F    ({DIGIT}+{DOT})|({DOT}{DIGIT}+)|({DIGIT}+{DOT}{DIGIT}+)

%%
"Integer"   { return INTEGER; }
"Float"     { return FLOAT; }
"String"    { return STRING; }
"REPEAT"    { return REPEAT; }
"UNTIL"     { return UNTIL; }
"IF"        { return IF; }
"THEN"      { return THEN; }
"ELSE"      { return ELSE; }
"ENDIF"     { return ENDIF; }
"AND"       { return AND; }
"OR"        { return OR; }
"NOT"       { return NOT; }
"PRINT"     { return PRINT; }
"READ"      { return READ; }
"VAR"       { return VAR; }
"ENDVAR"    { return ENDVAR; }
"INLIST"    { return INLIST; }

":"   { return COLON; }
";"   { return SCOLON; }
","   { return COMMA; }
":="  { return ASSIG; }
"/"   { return SLASH; }
"*"   { return STAR; }
"+"   { return PLUS; }
"-"   { return DASH; }
"("   { return BRA_O; }
")"   { return BRA_C; }
"["   { return SBRA_O; }
"]"   { return SBRA_C; }
"{"   { return CBRA_O; }
"}"   { return CBRA_C; }

{COMMENT}
{COMP}      { return COMP; }
{ID}        {
                strcpy(yylval.string, yytext);
                if(validateID(yytext)){
                    insertarSimbolo(yytext, TD_UNDEFINED);
                    return ID;
                }
            }
{CTE_S}     {
               if(validateString(yytext)){
                   insertarSimbolo(yytext, TD_CTE_S);
          		   return CTE_S;
               }
            }
{CTE_I}     {
               yylval.entero = atoi( yytext );
       			if(validateInteger(yylval.entero)){
                    insertarSimbolo(yytext, TD_CTE_I);
                    return CTE_I;
                }
            }
{CTE_F}     {
                yylval.real = atof( yytext );
                if(validateFloat(atof( yytext ))){
                    insertarSimbolo(yytext, TD_CTE_F);
                    return CTE_F;
                }
            }
<<EOF>>     {
               guardarTablaDeSimbolos();
               yyterminate();
            }

"\t"
"\n"
"\r"
%%
int validateString(char * str) {
    if(strlen(str) <= (int)MAX_STRING) {
		return 1;
	}
    else {
   	fprintf(stderr, "LEXICAL ERROR (line %d): String size exceeded (Maximum %d characters long) -> \%s\n", yylineno, (int)MAX_STRING - 2, str);
        system("PAUSE");
        exit(ERROR);
    }
}

int validateInteger(int Value) {
    if( strlen(yytext) <= 5 && Value <= (int)MAX_INT ) {
        return 1;
	}
    else {
        fprintf(stderr, "LEXICAL ERROR (line %d): Integer constant out of range (Allowed range: up to %d) -> \%d\n", yylineno, (int)MAX_INT, Value);
        system("PAUSE");
        exit(ERROR);
    }
}

int validateFloat(float Value) {
    double valor = strtod(yytext,NULL);

	if(strlen(yytext) <= 10 && valor >= (float)MAX_FLOAT) {
	    fprintf(stderr, "LEXICAL ERROR (line %d): Float constant out of range (Allowed range: up to %.0f) -> \%f\n", yylineno, (float)MAX_FLOAT, atof(yytext));
        system("PAUSE");
	    exit(ERROR);
	} else {
	    return 1;
   }
}

int validateID(char * id) {
    if(strlen(id) <= (int)MAX_ID) {
		return 1;
	}
    else {
		fprintf(stderr, "LEXICAL ERROR (line %d): ID size exceeded (Maximum %d characters long) -> \%s\n", yylineno, (int)MAX_ID, id);
        system("PAUSE");
        exit(ERROR);
    }
}

