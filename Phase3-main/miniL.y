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
%token <expression> function declarations declaration vars var expressions expressions identifiers ident
%token <expression> bool_exp relation_and_exp relation_exp relation_exp_inv comp multiple_exp  multiplicative_exp term
%token <statement> statement statements

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
program: 

%% 

int main(int argc, char **argv) {
   yyparse();
   return 0;
}

void yyerror(const char *msg) {
    /* implement your error handling */
}