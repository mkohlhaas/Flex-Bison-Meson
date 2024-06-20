/* skeleton for include files */
/* See p.28 in flex.pdf (official documentation) */

%option noyywrap warn nodefault
%x IFILE

/* indented text will also be copied verbatimly */

 typedef struct bufstack {
   struct bufstack *prev;
   YY_BUFFER_STATE buf_state;
   int             lineno;
   char            *filename;
   FILE            *file;
 } bufstack;

 bufstack *current_bufstack = NULL;  /* current buffer stack */

 int push(char *filename);
 int pop(void);

%%

^"#"[ \t]*include[ \t]*[\"<] { BEGIN IFILE; }
^.                           { fprintf(yyout, "%d %s", yylineno,   yytext); }  // replaces first char with line number and first char
^\n                          { fprintf(yyout, "%d %s", yylineno++, yytext); }  // yytext = newline 
.                            { ECHO; }                                         // print current character ("." = anything but newline) */
\n                           { ECHO; yylineno++; }                             // print newline */
<<EOF>>                      {
                               if(!pop()) {
                                 yyterminate();
                               }
                             }

<IFILE>[^ \t\n\">]+          {
                               { int c;
                        			   while((c = input()) && c != '\n') ;
                        			 }
                        			 if(!push(yytext)) {
                                 yyterminate(); /* no such file */
                               }
                        			 BEGIN INITIAL;
                             }

<IFILE>.|\n                  { fprintf(stderr, "%d bad include line\n", yylineno); yyterminate(); }

%%

int main(int argc, char **argv) {
  if (argc < 2) {
    fprintf(stderr, "need filename\n");
    exit(EXIT_FAILURE);
  }

  if (push(argv[1])) {
    yylex();
  }
}

// opens file, creates a new buffer and switches to it
int push(char *filename) {
  FILE *file = fopen(filename, "r");

  /* die if no file or no room */
  if (!file) {
    perror(filename);
    return 0;
  }

  bufstack *buf_stack = malloc(sizeof(bufstack));

  if (!buf_stack) {
    perror("malloc");
    exit(EXIT_FAILURE);
  }

  /* remember state */
  if (current_bufstack) {
    current_bufstack->lineno = yylineno;
  }
  buf_stack->prev = current_bufstack;

  /* set up current entry */
  buf_stack->buf_state = yy_create_buffer(file, YY_BUF_SIZE);
  buf_stack->file = file;
  buf_stack->filename = filename;
  yy_switch_to_buffer(buf_stack->buf_state);
  current_bufstack = buf_stack;
  yylineno = 1;
  return 1;
}

// goes back to previous buffer stack (if available)
int pop(void) {
  bufstack *buf_stack = current_bufstack;
  bufstack *prev_bufstack;

  if (!buf_stack) {
    return 0;
  }

  /* get rid of current entry */
  fclose(buf_stack->file);
  yy_delete_buffer(buf_stack->buf_state);

  /* switch back to previous */
  prev_bufstack= buf_stack->prev;
  free(buf_stack);

  if (!prev_bufstack) {
    return 0;
  }

  yy_switch_to_buffer(prev_bufstack->buf_state);
  current_bufstack = prev_bufstack;
  yylineno = current_bufstack->lineno;
  return 1;
}
