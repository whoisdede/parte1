%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int linha_atual = 1;
int coluna_atual = 1;
int nivel_tabulacao = 0;

typedef struct {
    char *lexema;
    char *tipo;
    int linha;
    int coluna;
} Token;

#define YY_USER_ACTION coluna_atual += yyleng; 
%}

DIGITO [0-9]
ID [a-zA-Z_][a-zA-Z0-9_]*
STRING \"[^\n"]*\" 

%%

[\n] {
    linha_atual++;
    coluna_atual = 1;
    nivel_tabulacao = 0;
}

^[\t]+ {
    nivel_tabulacao = yyleng;
    printf("Bloco nivel %d\n", nivel_tabulacao);
}

^[ ]+ {
    nivel_tabulacao = yyleng / 4;
    printf("Bloco nivel %d\n", nivel_tabulacao);
}

[ \t]+ 

{DIGITO}+{ID} {
    printf("ERRO LEXICO: %s na linha %d, e coluna %d\n", yytext, linha_atual, coluna_atual - yyleng);
}

{DIGITO}+"."{DIGITO}* {
    printf("Um valor real: %s (%g)\n", yytext, atof(yytext));
}

{DIGITO}+ {
    printf("Um valor inteiro: %s (%d)\n", yytext, atoi(yytext));
}

{STRING} {
    printf("Uma String: %s\n", yytext);
}

"return" {
    printf("Return\n");
}

"if" {
    printf("IF: %s\n", yytext);
}

":" {
    printf("DOIS PONTOS: %s\n", yytext);
}

"while" {
    printf("WHILE: %s\n", yytext);
}

"for" {
    printf("FOR: %s\n", yytext);
}

"else" {
    printf("ELSE: %s\n", yytext);
}

"def" {
    printf("FUNCAO: %s\n", yytext);
}

"(" {
    printf("INICIO PARENTESIS: %s\n", yytext);
}

")" {
    printf("FIM PARENTESIS: %s\n", yytext);
}

"," {
    printf("VIRGULA: %s\n", yytext);
}

"==" {
    printf("IGUALDADE COMPARATIVA: %s\n", yytext);
}

"!=" {
    printf("DIFERENTE: %s\n", yytext);
}

">=" {
    printf("MAIOR OU IGUAL: %s\n", yytext);
}

"<=" {
    printf("MENOR OU IGUAL: %s\n", yytext);
}

">" {
    printf("MAIOR QUE: %s\n", yytext);
}

"<" {
    printf("MENOR QUE: %s\n", yytext);
}

"=" {
    printf("Atribuicao: %s\n", yytext);
}

"+" {
    printf("MAIS: %s\n", yytext);
}

"-" {
    printf("MENOS: %s\n", yytext);
}

"*" {
    printf("MULTIPLICACAO: %s\n", yytext);
}

"/" {
    printf("DIVISAO: %s\n", yytext);
}

{ID} {
    printf("Um identificador: %s\n", yytext);
}

. {
    printf("ERRO LEXICO: %s na linha %d, e coluna %d\n", yytext, linha_atual, coluna_atual - yyleng); 
} 

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            printf("Erro ao abrir o arquivo %s\n", argv[1]);
            return 1;
        }
    } else {
        yyin = stdin;
    }

    yylex();
    
    if (yyin != stdin) {
        fclose(yyin);
    }
    
    return 0;
}