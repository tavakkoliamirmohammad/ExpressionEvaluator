%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yydebug;  // TODO: REMOVE IN PROD, 'yacc' it with -t flag.
extern int yylex();
char const *yyerror(const char *str);
%}


%start unit

%union
{
    int number;
    char *string;
}

%token <number> TOKNUMBER
%token <string> TOKWORD

%token PLUS
%token MINUS
%token DIV
%token MULTIPLY

%token LPAREN
%token RPAREN

%token TOKBEGIN
%token TOKCOMMA

%type <string> token

// %left, %right, %nonassoc - precedence and association setting.
// Start with lower priority - next to higher.
// Useful for expression ambiguity like:
// expr: expr '+' expr | expr '*' expr | int;

// Declaration example:
//%left PLUS MINUS
//%left MULTIPLY DIVIDE

// Also some specific RULES may have a precedence equal
// to the precedence of one from this list.
// Just write %prec after the rule before the semantic action.
// Useful for "Dangling else".
// Example of solution for "Dangling else" with variation:
// https://stackoverflow.com/questions/6911214/how-to-make-else-associate-with-farthest-if-in-yacc

%%

unit
        : /* empty */
        | TOKBEGIN
        ;

%%

// Called when parse error was detected.
char const *yyerror(const char *str)
{
    fprintf(stderr, "yyerror: %s\n", str);
}


// Program entry point.
int main()
{
    yydebug = 1;  // TODO: REMOVE IN PROD, set 0 for no debug info.
    return yyparse();
}

char* number_mapping_token(int number){
    switch(number) {
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
    }
}

char* parse_number(int number) {
    int hundreds, tens, unity;
    char* translated = (char*) malloc(400 * sizeof(char));
    int division = 1000;
    int is_digit_found = 0;
    while(number != 0){
        
    }
}


char* translate_number(int num) {
    printf("%d\n", num);

    // 10, 100, 1000 should be printed as Ten, Hun, Tou

    // if value == 0 print Zer

    int upper = num / 1000;
    int lower = num % 1000;
    
    // when number is not zero
    char* up = parse_number(upper, 1, upper != 0);
    // printf("%s", upper && lower ? "_" : "");
    char* low = parse_number(lower, 0, upper != 0);

    if (upper && lower) { 
        strcat(up, "_");
    }
    strcat(up, low);

    return up;
    
}