%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void yyerror(const char *s);
int yylex(void);
%}

%union {
    int intval;
    double floatval;
}

%token <intval> INTEGER
%token <floatval> FLOAT
%token PLUS MINUS MULTIPLY DIVIDE POWER
%token LPAREN RPAREN CLEAR

%type <floatval> expr

%left PLUS MINUS
%left MULTIPLY DIVIDE
%right POWER
%right UNARY

%%

program:
    /* Empty rule to allow zero or more expressions */
    | program expr '\n' { printf("Result: %.2f\n", $2); }
    | program CLEAR '\n' {
#ifdef _WIN32
        system("cls");
#else
        system("clear");
#endif
    }
    ;

expr:
    INTEGER { $$ = (double)$1; }
    | FLOAT { $$ = $1; }
    | expr PLUS expr { $$ = $1 + $3; }
    | expr MINUS expr { $$ = $1 - $3; }
    | expr MULTIPLY expr { $$ = $1 * $3; }
    | expr DIVIDE expr {
        if ($3 == 0) {
            yyerror("Division by zero!");
            YYABORT;
        }
        $$ = $1 / $3;
    }
    | expr POWER expr { $$ = pow($1, $3); }
    | LPAREN expr RPAREN { $$ = $2; }
    | MINUS expr %prec UNARY { $$ = -$2; }
    | PLUS expr %prec UNARY  { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Enter expressions (press Ctrl+Z to exit):\n");
    return yyparse();
}
