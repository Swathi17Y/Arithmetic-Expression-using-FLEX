%{
#include <stdio.h>
#include <stdlib.h>
#include "calculator.tab.h"
%}

%%
[0-9]+                   { yylval.intval = atoi(yytext); return INTEGER; }
[0-9]+\.[0-9]+([eE][-+]?[0-9]+)? { yylval.floatval = atof(yytext); return FLOAT; }
"+"                      { return PLUS; }
"-"                      { return MINUS; }
"*"                      { return MULTIPLY; }
"/"                      { return DIVIDE; }
"^"                      { return POWER; }
"("                      { return LPAREN; }
")"                      { return RPAREN; }
"clear"                  { return CLEAR; }
[ \t]                    { /* Ignore spaces and tabs */ }
\n                       { return '\n'; }  // Send newline to the parser
.                        { printf("Invalid character: %s\n", yytext); }
%%

int yywrap() {
    return 1;
}
