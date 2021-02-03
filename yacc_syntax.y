%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
char const *yyerror(const char *str);
int variable;
int number_count;
extern int yydebug;  // TODO: REMOVE IN PROD, 'yacc' it with -t flag.
%}

%union
{
    char number[100];
}

%token <number> NUMBER

%token PLUS
%token MINUS
%token DIVIDE
%token MULTIPLY


%token <number> LPAREN
%token <number> RPAREN

%type <number> expr T F;

%%

L: 
expr { if (number_count == 1)
        {
            printf("Assign %s to t%d\n", $1, variable);
            printf("Print t%d\n", variable++);
        }
        else
        {
            printf("Print %s\n", $1);        
        }
    };
expr: 
    expr PLUS T {
        printf("Assign %s PLU %s to t%d\n",$1, $3, variable);
        sprintf($$,"t%d", variable++);
        }
    |expr MINUS T {printf("Assign %s Min %s to t%d\n",$1, $3, variable);
     sprintf($$,"t%d", variable++);
    }
    |T {
        strcpy($$, $1);
    };
T: 
    T MULTIPLY F {
        printf("Assign %s Mul %s to t%d\n",$1, $3, variable);
        sprintf($$,"t%d", variable++);
     }
    |T DIVIDE F {
        printf("Assign %s Div %s to t%d\n",$1, $3, variable);
        sprintf($$,"t%d", variable++);
        }
    |F {
        strcpy($$, $1);
       
    };
F:
    LPAREN expr RPAREN {
        strcpy($$, $2);
    }
    | NUMBER {strcpy($$,$1); number_count++;};
%%

// Called when parse error was detected.
char const *yyerror(const char *str)
{
    fprintf(stderr, "yyerror: %s\n", str);
}

// Program entry point.
int main()
{
    variable = 1;
    yydebug = 0;
    number_count = 0;
    return yyparse();
}