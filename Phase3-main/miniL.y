/* cs152-miniL phase3 */


%{
#include <stdio.h>
#include <stdlib.h>
#include <map>
#include <string.h>
#include <set>

int tempCount = 0;
int labelCount = 0;
extern char* yytext;
extern int num_column;
extern FILE *yyin;
std::map<std::string, std::string> varTemp;
std::map<std::string, int> arrSize;
bool mainFunc = false;
std::set<std::string> funcs;
std::set<std::string> reserved{"NUMBER", "IDENT", "RETURN", "FUNCTION", "BEGIN_PARAMS", "END_PARAMS", "BEGIN_LOCALS", "END_LOCALS", 
    "BEGIN_BODY", "END_BODY", "INTEGER", "ARRAY", "OF", "IF", "THEN", "ENDIF", "ELSE", "WHILE", "FOR", "DO", "BEGINLOOP", "ENDLOOP",
    "CONTINUE", "READ", "WRITE", "TRUE", "FALSE", "SEMICOLON", "COLON", "COMMA", "L_PAREN", "R_PAREN", "L_SQUARE_BRACKET", 
    "R_SQUARE_BRACKET", "ENUM", "ASSIGN", "OR", "AND", "NOT", "LT", "LTE", "GT", "GTE", "EQ", "NEQ", "ADD", "SUB", "MULT", "DIV", "MOD",
    "function", "declaration", "declarations", "var", "vars", "expressions", "expression", "identifiers", "ident", "bool_exp", "relation_and_exp",
    "relation_exp_inv", "relation_exp", "comp", "multiplicative_exp", "multiple_exp", "statements", "statement", "term" };

void yyerror(const char *msg);
extern int yylex();
extern int yyparse();
std::string new_temp();
std::string new_label();
#include "lib.h"

%}

%union {
  int int_val;
  char* ident;
  struct S{
    char* code;
  } statement;
  struct E{
    char* place;
    char* code;
    bool arr;
  }expression;
}

%error-verbose

%token<int_val> DIGIT
%start program
%token <num_val> NUMBER
%token <ident> IDENT
%type <expression> function declarations declaration vars var expressions expression identifiers ident
%type <expression> bool_exp relation_and_exp relation_exp relation_exp_inv comp multiple_exp  multiplicative_exp term
%type <statement> statement statements

%token FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE FOR DO BEGINLOOP ENDLOOP CONTINUE READ WRITE TRUE FALSE SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET RETURN
%token ENUM
%left ASSIGN
%left OR
%left AND
%right NOT
%left LT LTE GT GTE EQ NEQ
%left ADD SUB
%left MULT DIV MOD


%% 

  /* write your rules here */
program: %empty
        {
          if(!mainFunc)
          {
            printf("No main function declared!\n");
          }
        }
        | function program 
        { 
        }
        ;

 function: FUNCTION ident SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY
        {
          std::string temp = "func";
          temp.append($2.place);
          temp.append("\n");
          std::string s = $2.place;
          if (s == "main"){
            mainFunc == true;
          }
          temp.append($5.code);
          std::string decs = $5.code
          int decNum = 0;
          //tracks number of occurences of . character in the decs string

          while(decs.find(".") != std::string:npos){
            //continue as long as theres a . character in decs string
            int pos = decs.find(".");
            decs.replace(pos, 1, "=")
            std::string part = ", $" + std::to_string(decNum) + "\n";
            decNum++;
            decs.replace(decs.find("\n", pos), 1, part);
          }
          temp.append(decs);

          temp.append($8.code);
          std::string statements = $11.code;
          if(statements.find("continue") != std::string::npos){
            printf("ERROR: Continue outside loop in function %s\n", $s2.place);
          }
          temp.append(statements);
          temp.append("endfunc\n\n");
          printf(temp.c_str());
        }
        ;
   declarations:        /*empty*/ {printf("declarations -> epsilon\n");}
        | declaration SEMICOLON declarations {printf("declarations -> declaration SEMICOLON declarations\n");}
        ;

 declaration: identifiers COLON INTEGER {printf("declaration -> identifier COLON INTEGER\n");}
        | identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER {printf("declaration -> identifiers\n");}
        ;

 identifiers: ident {printf("identifiers -> ident\n");}
        | ident COMMA identifiers {printf("identifiers -> ident COMMA identifiers\n");}
        ;

 ident: IDENT {printf("ident -> IDENT %s\n", $1);}
        ;


statements:    statement SEMICOLON {printf("statements -> statement SEMICOLON epsilon\n");}
        | statement SEMICOLON statements {printf("statements -> statement SEMICOLON statements\n");}
        ;

statement: var ASSIGN expression {printf("statement -> var ASSIGN expression\n");}
	| IF bool_exp THEN statements ENDIF {printf("statement -> IF bool_exp THEN statements ENDIF\n");}
	| IF bool_exp THEN statements ELSE statements ENDIF {printf("statement -> IF bool_exp THEN statements ELSE statements ENDIF\n");}
	| WHILE bool_exp BEGINLOOP statements ENDLOOP {printf("statement -> WHILE bool_exp BEINGLOOP statements ENDLOOP\n");}
	| DO BEGINLOOP statements ENDLOOP WHILE bool_exp {printf("statement -> DO BEGINLOOP statements ENDLOOP WHILE bool_exp\n");}
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
	| NOT L_PAREN bool_exp R_PAREN {printf("relation_exp -> NOT L_PAREN bool_exp R_PAREN\n");}
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

multiplicative_exp: term {printf("multiplicative_exp -> term\n");}
	| term MULT multiplicative_exp {printf("multiplicative_exp -> term MULT multiplicative_exp\n");}
	| term DIV multiplicative_exp {printf("multiplicative_exp -> term DIV multiplicative_exp\n");}
	| term MOD multiplicative_exp {printf("multiplicative_exp -> term MOD multiplicative_exp\n");}
	;

multiple_exp: expression {printf("multiple_exp -> expression\n");}
	| expression COMMA multiple_exp {printf("multiple_exp -> expression COMMA multiple_exp\n");}
	;
term: var {printf("term -> var\n");}
	| SUB var {printf("term -> SUB var\n");}
	| NUMBER {printf("term -> NUMBER\n");}
	| SUB NUMBER {printf("term -> SUB NUMBER\n");}
	| L_PAREN expression R_PAREN {printf("term -> L_PAREN expression R_PAREN\n");}
	| SUB L_PAREN expression R_PAREN {printf("term -> SUB L_PAREN expression R_PAREN\n");}
	| ident L_PAREN expressions R_PAREN {printf("term -> identifier L_PAREN expressions R_PAREN\n");};

var: ident {printf("var -> identifier\n");}
	| ident L_SQUARE_BRACKET expression R_SQUARE_BRACKET {printf("var -> identifier L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n");}
	;

vars: var {printf("vars -> var\n");}
                 | var COMMA vars {printf("vars -> var COMMA vars\n");}
	;

%% 

int main(int argc, char **argv) {
   yyparse();
   return 0;
}

void yyerror(const char *msg) {
    /* implement your error handling */
}