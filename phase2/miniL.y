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
%token FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO FOR BEGINLOOP ENDLOOP CONTINUE READ WRITE TRUE FALSE ASSIGN SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET RETURN
%token _id_val> IDENT
%token <num_val> NUMBER

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
