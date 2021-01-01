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


char *parse_number(int number) {
    char *translated = (char *) malloc(400 * sizeof(char));
    translated[0] = '\0';
    int division = 100;
    int is_digit_found = 0;
    while (1) {
        int upper_part;
        if (division == 0) {
            upper_part = number;
        } else {
            upper_part = number / division;
            number = number % division;
        }
        if (upper_part != 0) {
            strcat(translated, number_mapping_token(upper_part));
            if (division > 1) {
                strcat(translated, number_mapping_token(division));
            } else {
                return translated;
            }
            number = number % division;
            division /= 10;
            is_digit_found = 1;
        }
        if (upper_part == 0) {
            if (division && is_digit_found) {
                strcat(translated, number_mapping_token(upper_part));
                strcat(translated, number_mapping_token(division));
                division /= 10;
            } else if (division == 0) {
                return translated;
            } else {
                division /= 10;
            }
        }
    }
}


char *translate_number(int num) {
    printf("%d\n", num);

    int upper = num / 1000;
    int lower = num % 1000;
    char *translated = (char *) malloc(400 * sizeof(char));
    // when number is not zero
    char *up = parse_number(upper);
    if (strlen(up) != 0) {
        strcat(translated, "(");
        strcat(translated, up);
        strcat(translated, ")");
        strcat(translated, number_mapping_token(1000));
    }
    // printf("%s", upper && lower ? "_" : "");
    char *low = parse_number(lower);
    strcat(translated, low);
    printf("%s\n", translated);
    return translated;
}

//int main() {
////    translate_number(45320);
//    translate_number(45032);
////    translate_number(45320);
////    translate_number(1);
////    translate_number(10000);
////    translate_number(1000);
////    translate_number(100);
////    translate_number(12925);
////    translate_number(106);
////    translate_number(5);
////    translate_number(2840);
////    translate_number(99999);
////    translate_number(9999);
//
//    return 0;
//}