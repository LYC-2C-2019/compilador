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
char auxS[100];
int validateID(char *id);
int validateString(char *str);
int validateInteger(char *);
int validateFloat(char *);
int validateComment();
int finDeclaraciones = 0;
int validarVariableDeclarada(char* nombre);
void quitarComillas();

%}
%option noyywrap
%option yylineno

/* TAGS */
D1TO9    [1-9]
DIGIT    [0-9]
ALPHA    [a-zA-Z]
DOT      \.
NEWLINE  \n
ANYCHAR  .*
COMM_O   --\/
COMM_C   \/--

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
"ENDVAR"    {
				finDeclaraciones=1;
				return ENDVAR;
			}
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

">"	 {return GT;}
"<"	 {return LT;}
">=" {return GE;}
"<=" {return LE;}
"==" {return EQ;}
"<>" {return NE;}

{ID}        {
                sprintf(auxS,"%s", yytext);
                if(validateID(yytext)){                    
                    yylval.str_val=auxS;
                    if(finDeclaraciones==1){
                        validarVariableDeclarada(yytext);
                    }
					return ID;
                }
            }
{CTE_S}     {


               if(validateString(yytext)){ 
                            sprintf(auxS,"%s", yytext);
							quitarComillas();
							yylval.str_val=auxS;              
          		   return CTE_S;
               }

            }
{CTE_I}     {
       			if(validateInteger(yytext)){
 				yylval.str_val=yytext;
                    return CTE_I;
                }
            }
{CTE_F}     {
                if(validateFloat(yytext)){
                   	yylval.str_val=yytext;
                    return CTE_F;
                }
            }
{COMMENT}   {
                if (validateComment())
                {
                    fprintf(stderr, "LEXICAL ERROR (line %d): Comment exceed\n", yylineno);
                    system("PAUSE");
                    exit(ERROR);	
                }
            }

"\t"
"\n"
"\r"
"\r\n"
" "

.           { printf("\nCaracter invalido!\n");  exit(1);}

%%
int validateString(char * str) {
    if(strlen(str) <= (int)MAX_STRING) {
		return 1;
	} else {
   	fprintf(stderr, "LEXICAL ERROR (line %d): String size exceeded (Maximum %d characters long) -> \%s\n", yylineno, (int)MAX_STRING - 2, str);
        system("PAUSE");
        exit(ERROR);
    }
}

int validateInteger(char *str) {
    int value = atoi(str);
    if(strlen(str) <= 5 && value <= (int)MAX_INT ) {
        return 1;
	} else {
        fprintf(stderr, "LEXICAL ERROR (line %d): Integer constant out of range (Allowed range: up to %d) -> \%d\n", yylineno, (int)MAX_INT, value);
        system("PAUSE");
        exit(ERROR);
    }
}

int validateFloat(char *str) {
    double value = strtod(str, NULL);

	if(value >= (float)MAX_FLOAT) {
	    fprintf(stderr, "LEXICAL ERROR (line %d): Float constant out of range (Allowed range: up to %.0f) -> \%f\n", yylineno, (float)MAX_FLOAT, value);
        system("PAUSE");
	    exit(ERROR);
	} else {
	    return 1;
   }
}

int validateID(char *id) {
    if(strlen(id) <= (int)MAX_ID) {
		return 1;
	} else {
		fprintf(stderr, "LEXICAL ERROR (line %d): ID size exceeded (Maximum %d characters long) -> \%s\n", yylineno, (int)MAX_ID, id);
        system("PAUSE");
        exit(ERROR);
    }
}

int validateComment(){
    char *comentario_1;
	char *comentario_2;
	comentario_1 = strstr(yytext,"--/");
	comentario_2 = strstr(comentario_1 + 3,"--/");
	if(comentario_2 != NULL){
		if ( strstr(comentario_2 + 3,"--/") != NULL){
			return 1;							
		}
	}
    return 0;
}

void quitarComillas() {
	int i = 0;
	while(auxS[i+1] != '\"') {
		auxS[i] = auxS[i+1];
		i++;
	}
	auxS[i] = '\0';
}