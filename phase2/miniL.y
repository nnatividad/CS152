    /* cs152-miniL phase2 */
%{
  #include <stdio.h>
  #include <stdlib.h>
  void yyerror(const char *msg);
  extern int currLine;
  extern int currPos;
  FILE * yyin;
%}

%error-verbose
%union{
  int num_val;
  char* id_val;
}


%start prog_start
%token FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO FOR BEGINLOOP ENDLOOP CONTINUE READ WRITE TRUE FALSE ASSIGN SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET RETURN
%token _id_val> IDENT
%token <num_val> NUMBER
%right ASSIGN
%left OR
%left AND
%right NOT
%left LT LTE GT GTE EQ NEQ
%left ADD SUB
%left MULT DIV MOD

%locations

/* %start program */

%% 

 prog_start:    functions { printf("prog_start -> functions\n"); }
        ;

 functions:    /*empty*/{printf("functions -> epsilon\n");}
        | function functions {printf("functions -> function functions\n";}
        ;

 function:      FUNCTION ident SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY {printf("function -> FUNCTION IDENT SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY\n", ident);}

        ;

 declarations:        /*empty*/ {printf("declarations -> epsilon\n");}
        | declaration SEMICOLON declarations {printf("declarations -> declaration SEMICOLON declarations\n");}
        ;

 declaration: identifiers COLON INTEGER {printf("declaration -> identifiers COLON INTEGER\n");}
        | identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER {printf("declaration -> identifiers\n");}
        ;

 identifiers:    ident {printf("identifiers -> indent\n");}
        | ident COMMA identifiers {printf("identifiers -> IDENT COMMA identifiers\n", ident);}
        ;

 ident:        IDENT {printf("ident -> IDENT %s\n", $1);}
        ;


statements:    /*empty*/ {printf("statements -> epsilon\n");}
        | statement SEMICOLON statements {printf("statements -> statement SEMICOLON statements\n");}
        ;

statement: var ASSIGN expression {printf("statement -> var ASSIGN expression\n");}
	| IF bool_exp THEN statements ENDIF {printf("statement -> IF bool_exp THEN statements ENDIF\n");}
	| IF bool_exp THEN statements ELSE statements ENDIF {printf("statement -> IF bool_exp THEN statements ELSE statements ENDIF\n");}
	| WHILE bool_exp BEGINLOOP statements ENDLOOP {printf("statement -> WHILE bool_exp BEINGLOOP statements ENDLOOP\n");}
	| DO BEGINLOOP statements ENDLOOP WHILE bool_exp {printf("statement -> DO BEGINLOOP statements ENDLOOP WHILE bool_exp\n");}
	| FOR vars ASSIGN NUMBER SEMICOLON bool_exp SEMICOLON vars ASSIGN expression BEGINLOOP statements ENDLOOP {printf("
   	| READ vars {printf("statement -> READ vars\n");}
	| WRITE vars {printf("statement -> WRITE vars\n");}
	| CONTINUE {printf("statement -> CONTINUE\n");}
	| RETURN expression {printf("statement -> RETURN expression\n");}
	;

bool_exp: relation_and_exp {printf("bool_exp -> relation_and_exp\n");}
	| relation_and_exp OR bool_exp {printf("bool_exp -> relation_and_exp OR bool_exp\n");}
	;

relation_and_exp: relation_exp {printf("relation_and_exp -> relation_exp\n");}
	| relation_exp AND relation_and_exp {printf("relation_and_exp -> relation_exp AND relation_and_exp\n");}
	;

	relation_exp: expression comp expression {printf("relation_exp -> expression comp expression\n");}
	| NOT expression comp expression {printf("relation_exp -> NOT expression comp expression\n");}
	| TRUE {printf("relation_exp -> TRUE\n");}
	| NOT TRUE {printf("relation_exp -> NOT TRUE\n");}
	| FALSE {printf("relation_exp -> FALSE\n");}
	| NOT FALSE {printf("relation_exp -> NOT FALSE\n");}
	| L_PAREN bool_exp R_PAREN {printf("relation exp -> L_PAREN bool_exp R_PAREN\n");}
	;

comp: EQ {printf("comp -> EQ\n");}
	| NEQ {printf("comp -> NEQ\n");}
	| LT {printf("comp -> LT\n");}
	| GT {printf("comp -> GTn");}
	| LTE {printf("comp -> LTE\n");}
	| GTE {printf("comp -> GTE\n");}
	;

expression: multiplicative_exp {printf("expression -> multiplicative_exp\n");}
	| multiplicative_exp ADD expression {printf("expression -> multiplicative_exp ADD expression\n");}
	| multiplicative_exp SUB expression {printf("expression -> multiplicative_exp SUB expression\n");}
	;

expressions: /*Epsilon*/ {printf("expressions -> Epsilon\n");}
	| multiple_exp {printf("expressions -> multiple_exp\n");}
	;

multiplicative_expr: term {printf("multiplicative_exp -> term\n");}
	| term MULT multiplicative_exp {printf("multiplicative_exp -> term MULT multiplicative_exp\n");}
	| term DIV multiplicative_exp {printf("multiplicative_exp -> term DIV multiplicative_exp\n");}
	| term MOD multiplicative_exp {printf("multiplicative_exp -> term MOD multiplicative_exp\n");}
	;

multiple_exp: expression {printf("multiple_exp -> expression\n");}
	| expression COMMA multiple_exp {printf("multiple_exp -> expression COMMA multiple_exp\n");}
	;
term: var {printf("term -> var\n");}
	| NUMBER {printf("term -> NUMBER\n");}
	| L_PAREN expression R_PAREN {printf("term -> L_PAREN expression R_PAREN\n");}
	| identifier L_PAREN expressions R_PAREN {printf("term -> identifier L_PAREN expressions R_PAREN\n");}
	;

var: identifier {printf("var -> identifier\n");}
	| identifier L_SQUARE_BRACKET expression R_SQUARE_BRACKET {printf("var -> identifier L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n");}
	;
	
%% 

int main(int argc, char **argv) {
	if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (yyin == NULL) {
            printf("error: %s file error", argv[0]);
        }
    }
   yyparse();
   return 0;
}

void yyerror(const char *msg) {
    printf("Error at line %d: %s \n", currLine, currPos, msg);
}
