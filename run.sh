yacc -dt yacc_syntax.y
flex lex_tokens.l
gcc lex.yy.c y.tab.c -ll