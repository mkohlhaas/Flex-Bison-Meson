/* Recognize tokens for the calculator and print them out. */

%{

#include "parser.h"
#include <stdio.h>

char buffer[100];
int max_len = sizeof buffer;

void yyerror (char *);

%}

%%

"+"	    { return ADD; }
"-"	    { return SUB; }
"*"	    { return MUL; }
"/"	    { return DIV; }
"|"     { return ABS; }
"("     { return OP; }
")"     { return CP; }
[0-9]+	{ yylval = atoi(yytext); return NUMBER; }

\n      { return EOL; }
"//".*  /* ignore comments */
[ \t]   { /* ignore white space */ }
.	      { snprintf(buffer, max_len, "Mystery character '%s'\n", yytext); yyerror(buffer); }

%%
