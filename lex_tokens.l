%x COMMENT

delim   [ \t\n]
ws  {delim}+
digit   [0-9]
number  {digit}+

%{
#include <string.h>
#include <stdlib.h>
#include "y.tab.h"

%}

%%

{ws}                { /* skip over blanks */ }
{number}            {sscanf(yytext, "%s", yylval.number); return NUMBER;}
"+"                 {return PLUS;}
"/"                 {return DIVIDE;}
"*"                 {return MULTIPLY;}
"-"                 {return MINUS;}
"("                 {return LPAREN;}
")"                 {return RPAREN;}
.                   { /* skip all other symbols, they're printed by default */ }

%%