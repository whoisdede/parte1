%{
#include <math.h>
#include <string.h>

int linha_atual = 1;
int coluna_atual = 1;

#define YY_USER_ACTION coluna_atual += strlen(yytext);
%}

ROMANO M{0,4}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})
DIGITO [0-9]
ID [a-z][a-z0-9]*
TEXTO [a-zA-z]*
%%

"+"?"55"?[ ]?"("?{DIGITO}{2}?")"?[ ]?{DIGITO}{4}[- .]?{DIGITO}{4} {
    printf("Numero de telefone 8 digitos: %s\n", yytext);
}

"+"?"55"?[ ]?"("?{DIGITO}{2}?")"?[ ]?"9"{DIGITO}{4}[- .]?{DIGITO}{4} {
    printf("Numero de telefone 9 digitos: %s\n", yytext);
}

{DIGITO}+ {
    printf("Um valor inteiro: %s (%d)\n", yytext, atoi(yytext));
}

{DIGITO}+"."{DIGITO}* {
    printf("Um valor real: %s (%g)\n", yytext, atof(yytext));
}

{ROMANO} {
    printf("Um número romano: %s\n", yytext);
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

"return" {
    printf("Return\n");
}

if|:|while|for|else|def|"("|")"|"," {
    printf("Uma palavra-chave: %s\n", yytext);
}

"=" {
    printf("Uma palavra-chave de atribuição: %s\n", yytext);
}

{ID} {
    printf("Um identificador: %s\n", yytext);
}

"=="|"!="|">"|"<"|"<="|">=" {
    printf("Um operador relacional: %s\n", yytext);
}

"+"|"-"|"*"|"/" {
    printf("Um operador matematico: %s\n", yytext);
}

"{"[^}\n]*"}" 

[\n] {
    linha_atual++;
    coluna_atual = 1;
}

[\t] {
    printf("Inicio/fim de bloco\n");
}

[ ]+ 

. {
    printf("ERRO LÉXICO: %s na linha %d, e coluna %d\n", yytext, linha_atual, coluna_atual - yyleng); 
} 

%%

int main(argc, argv)
int argc;
char **argv;
{
    ++argv, --argc;
    if (argc > 0)
        yyin = fopen(argv[0], "r");
    else
        yyin = stdin;

    yylex();
    return 0;
}