#include "aux.h"
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

extern int yyparse (void);

ast *
newast (int nodetype, ast *l, ast *r)
{
  ast *a = malloc (sizeof (*a));

  if (!a)
    {
      yyerror ("out of memory");
      exit (EXIT_FAILURE);
    }
  a->nodetype = nodetype;
  a->l        = l;
  a->r        = r;
  return a;
}

ast *
newnum (double d)
{
  numval *a = malloc (sizeof (*a));

  if (!a)
    {
      yyerror ("out of memory");
      exit (EXIT_FAILURE);
    }
  a->nodetype = 'K';
  a->number   = d;
  return (ast *)a;
}

double
eval (ast *a)
{
  double v = 0.0;

  switch (a->nodetype)
    {
    case 'K': // number
      v = ((numval *)a)->number;
      break;
    case '+':
      v = eval (a->l) + eval (a->r);
      break;
    case '-':
      v = eval (a->l) - eval (a->r);
      break;
    case '*':
      v = eval (a->l) * eval (a->r);
      break;
    case '/':
      v = eval (a->l) / eval (a->r);
      break;
    case '|': // absolute value
      v = eval (a->l);
      if (v < 0)
        {
          v = -v;
        }
      break;
    case 'M': // unary minus
      v = -eval (a->l);
      break;
    default:
      printf ("internal error: bad node %c\n", a->nodetype);
    }
  return v;
}

void
treefree (ast *a)
{
  switch (a->nodetype)
    {

      /* two subtrees */
    case '+':
    case '-':
    case '*':
    case '/':
      treefree (a->r);
      // fall through

      /* one subtree */
    case '|':
    case 'M':
      treefree (a->l);
      // fall through

      /* no subtree */
    case 'K':
      free (a);
      break;

    default:
      printf ("internal error: free bad node %c\n", a->nodetype);
    }
}

void
yyerror (char *s, ...)
{
  va_list ap;
  va_start (ap, s);

  fprintf (stderr, "%d: error: ", yylineno);
  vfprintf (stderr, s, ap);
  fprintf (stderr, "\n");
}

int
main (void)
{
  printf ("> ");
  return yyparse ();
}
