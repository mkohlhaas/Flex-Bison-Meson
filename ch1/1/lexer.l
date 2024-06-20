/* just like unix wc */

%{
int chars = 0;
int words = 0;
int lines = 0;
%}

%%

[^ \t\n\r\f\v]+ { words++; chars += yyleng; }
\n		          { chars++; lines++; }
.		            { chars++; }

%%

int main(void)
{
  yylex();
  printf("lines: %d, words: %d, chars: %d\n", lines, words, chars);
}
