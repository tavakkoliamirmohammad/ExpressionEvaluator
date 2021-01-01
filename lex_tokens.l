%x COMMENT
%option noyywrap

delim   [ \t\n]
ws  {delim}+
digit   [0-9]
number  {digit}+

%{
#include <string.h>
#include <stdlib.h>
#include "y.tab.h"

extern YYSTYPE yylval;
%}

%%

{ws}                { /* skip over blanks */ }
{number}            {yylval.number = atoi(yytext); return TOKNUMBER;}
"+"                 {return PLUS;}
"/"                 {return DIV;}
"*"                 {return MULTIPLY;}
"-"                 {return MINUS;}
"("                 {return LPAREN;}
")"                 {return RPAREN;}
.                   { /* skip all other symbols, they're printed by default */ }

%%