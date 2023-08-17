    /* cs152-miniL phase2 */
%{
  #include <stdio.h>
  #include <stdlib.h>
  void yyerror(const char *msg);
  extern int num_lines;
  extern int num_column;
  FILE * yyin;
%}

%union{
  /* put your types here */
  int num_val;
  char* id_val;
}


%start prog_start
%error-verbose
%locations

/* %start program */

%% 

  /* write your rules here */

%% 

int main(int argc, char **argv) {
   yyparse();
   return 0;
}

void yyerror(const char *msg) {
    /* implement your error handling */
}
