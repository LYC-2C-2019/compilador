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
	yylex();
}