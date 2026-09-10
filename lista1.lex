%{

#include <math.h>

%}


DIGITO [0-9]
ID [a-zA-Z][a-zA-Z0-9]*

%%  

{DIGITO}+|"+"{DIGITO}+ {
     printf( "Um valor inteiro positivo: %s (%d)\n", yytext,
             atoi( yytext ) );
}

{DIGITO}+"."{DIGITO}*|"+"{DIGITO}+"."{DIGITO}* {
     printf( "Um valor real positivo: %s (%g)\n", yytext,
             atof( yytext ) );
}

"-"{DIGITO}+ {
     printf( "Um valor inteiro negativo: %s (%d)\n", yytext,
             atoi( yytext ) );
}

"-"{DIGITO}+"."{DIGITO}* {
     printf( "Um valor real negativo: %s (%g)\n", yytext,
             atof( yytext ) );
}

if|then|begin|end|procedure|function {
     printf( "Uma palavra-chave: %s\n", yytext );
}

{ID} printf( "Um identificador: %s\n", yytext );

"+"|"-"|"*"|"/" printf( "Um operador: %s\n", yytext );

"{"[^}\n]*"}" /* Lembre-se... comentários não tem utilidade! */

[ \t\n]+ /* Lembre-se... espaços em branco não tem utilidade! */

. printf( "Caracter não reconhecido: %s\n", yytext );

%%

int main( argc, argv )
int argc;
char **argv;
{
     ++argv, --argc;
     if ( argc > 0 )
          yyin = fopen( argv[0], "r" );
     else
          yyin = stdin;

     yylex();

     return 0;
}