// simplest version of calculator

%{

#include <stdio.h>

int yylex(void);
void yyerror(char* s); // uses the default implementation in liby.a

%}

%token NUMBER ADD SUB MUL DIV ABS OP CP EOL

%%

calclist: /* nothing */
 | calclist exp EOL { printf("↳ %d\n> ", $2); }
 | calclist EOL     { printf("> "); } /* blank line or a comment */
 ;

exp: factor // default $$ = $1
 | exp ADD exp    { $$ = $1 + $3; }
 | exp SUB factor { $$ = $1 - $3; }
 | exp ABS factor { $$ = $1 | $3; }
 ;

factor: term
 | factor MUL term { $$ = $1 * $3; }
 | factor DIV term { $$ = $1 / $3; }
 ;

term: NUMBER
 | ABS term  { $$ = $2 >= 0? $2 : - $2; }
 | OP exp CP { $$ = $2; }
 ;

%%

int main(void)
{
  printf("> ");
  yyparse();
}
