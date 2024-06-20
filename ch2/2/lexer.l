/* read several files */

%{
int chars = 0;
int words = 0;
int lines = 0;

int chars_total = 0;
int words_total = 0;
int lines_total = 0;
%}

%%

[^ \t\n\r\f\v]+ { words++; chars += yyleng; }
\n              { chars++; lines++; }
.               { chars++; }

%%

int
main (int argc, char **argv)
{
  // just read from stdin
  if (argc < 2)
    {
      yylex ();
      printf ("lines: %d, words: %d, chars: %d\n", lines, words, chars);
      exit (EXIT_SUCCESS);
    }

  // iterate over all files
  for (int i = 1; i < argc; i++)
    {
      FILE *f = fopen (argv[i], "r");
      if (!f)
        {
          perror (argv[i]);
          exit (EXIT_FAILURE);
        }

      // lexing current file
      yyrestart (f);
      yylex ();

      // print results
      printf ("%s → lines: %d, words: %d, chars: %d\n", argv[i], lines, words, chars);

      // updating totals
      lines_total += lines;
      words_total += words;
      chars_total += chars;

      // resetting vars
      lines = 0;
      chars = 0;
      words = 0;

      // cleanup
      fclose (f);
    }

  printf ("total lines: %d, total words: %d, total chars: %d\n", lines_total, words_total, chars_total);
}
