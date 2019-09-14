%{
#include "y.tab.h"
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
COMMENT  {COMM_O}({NEWLINE}*|{ANYCHAR}){COMM_C}
ID       ({ALPHA}|_)({ALPHA}|{DIGIT}|_)*
CTE_S    \"{ANYCHAR}\"
CTE_I    {DIGIT}+
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
":="  { return ASIG; }
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
{ID}        { return ID; }
{CTE_S}     { return CTE_S; }
{CTE_I}     { yylval.entero = atoi( yytext ); return CTE_I; }
{CTE_F}     { yylval.real = atof( yytext ); return CTE_F; }

"\t"
"\n"
"\r"
