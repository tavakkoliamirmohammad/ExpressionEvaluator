%x COMMENT

delim   [ \t\n]
ws  {delim}+
digit   [0-9]
number  {digit}+

%{
#include <string.h>
#include <stdlib.h>
#include "y.tab.h"

char *convert_number(char *num);

%}

%%

{ws}                { /* skip over blanks */ }
{number}            {sscanf(convert_number(yytext), "%s", yylval.number); return NUMBER;}
"+"                 {return PLUS;}
"/"                 {return DIVIDE;}
"*"                 {return MULTIPLY;}
"-"                 {return MINUS;}
"("                 {return LPAREN;}
")"                 {return RPAREN;}
.                   { /* skip all other symbols, they're printed by default */ }

%%

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