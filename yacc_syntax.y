%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
char const *yyerror(const char *str);
char *convert_number(char *num);
int variable;
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
expr {printf("Print %s\n", $1);};
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
    | NUMBER {strcpy($$,convert_number($1));};
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
    return yyparse();
}

const char *number_mapping_token(int number) {
    switch (number) {
        case 0:
            return "Zer";
        case 1:
            return "One";
        case 2:
            return "Two";
        case 3:
            return "Thr";
        case 4:
            return "Fou";
        case 5:
            return "Fiv";
        case 6:
            return "Six";
        case 7:
            return "Sev";
        case 8:
            return "Eig";
        case 9:
            return "Nin";
        case 1000:
            return "Tou_";
        case 100:
            return "Hun_";
        case 10:
            return "Ten_";
    }
}


char *number_mapper(char *number) {
    char *converted_number = (char *) malloc(200 * sizeof(char));
    converted_number[0] = '\0';
    int division = 1;
    for (int i = 0; i < strlen(number) - 1; ++i) {
        division *= 10;
    }
    while (*number) {
        strcat(converted_number, number_mapping_token((*number) - '0'));
        if (division > 1) {
            strcat(converted_number, number_mapping_token(division));
        } else {
            return converted_number;
        }
        division /= 10;
        ++number;
    }
}

char *convert_number(char *num) {

    char *converted = (char *) malloc(400 * sizeof(char));
    char *lower_part = (char *) malloc(4 * sizeof(char));
    if (strlen(num) > 3) {
        char *upper_part = (char *) malloc(4 * sizeof(char));
        strncpy(upper_part, num, strlen(num) - 3);
        upper_part = number_mapper(upper_part);
        if (strlen(upper_part) != 0) {
            strcat(converted, "(");
            strcat(converted, upper_part);
            strcat(converted, ")");
            strcat(converted, number_mapping_token(1000));
        }
        strcpy(lower_part, num + strlen(num) - 3);
        lower_part = number_mapper(lower_part);
    } else {
        strcpy(lower_part, num);
        lower_part = number_mapper(lower_part);
    }
    strcat(converted, lower_part);
    return converted;
}