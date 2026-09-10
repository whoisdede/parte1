%{

/* Linguagem: Pascal-like */

/* ========================================================================== */
/* Abaixo, indicado pelos limitadores "%{" e "%}", as includes necessárias... */
/* ========================================================================== */

/* Para as funções atoi() e atof() */
#include <math.h>
#include <string.h>
/* ========================================================================== */
/* =========================== Sessão DEFINIÇÔES ========================== */
/* ========================================================================== */

%}


DIGITO [0-9]
ID [a-z][a-z0-9]*
ROMANO M{0,4}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})
TEXTO [a-zA-z]*
%%

"+"?"55"?[ ]?"("?{DIGITO}{2}?")"?[ ]?{DIGITO}{4}[- .]?{DIGITO}{4} {
printf("Numero de telefone 8 digitos: %s\n", yytext);
}

"+"?"55"?[ ]?"("?{DIGITO}{2}?")"?[ ]?"9"{DIGITO}{4}[- .]?{DIGITO}{4} {
printf("Numero de telefone 9 digitos: %s\n", yytext);
}

{DIGITO}+ {
printf( "Um valor inteiro: %s (%d)\n", yytext,
atoi( yytext ) );
}

{DIGITO}+"."{DIGITO}* {
printf( "Um valor real: %s (%g)\n", yytext,
atof( yytext ) );
}

{ROMANO} {
printf( "Um número romano: %s\n", yytext );
}

"<HIDE>"" "?{TEXTO}" "?"</HIDE>" {
    int i;
    int inicio = 6; 
    if (yytext[inicio] == ' ') {
        inicio++;
    }
    int fim = yyleng - 7; 
    if (yytext[fim - 1] == ' ') {
        fim--;
    }
    for (i = 0; i < inicio; i++) {
        printf("%c", yytext[i]);
    }
    for (i = inicio; i < fim; i++) {
        printf("X");
    }

    for (i = fim; i < yyleng; i++) {
        printf("%c", yytext[i]);
    }
    
    printf("\n");
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