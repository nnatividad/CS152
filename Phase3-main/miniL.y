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

%start program
%token <int_val> NUMBER
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
            printf("ERROR: Continue outside loop in function %s\n", $2.place);
          }
          temp.append(statements);
          temp.append("endfunc\n\n");
          printf(temp.c_str());
        }
        ;
   declarations: declaration SEMICOLON declarations 
      {
        std::string temp;
        temp.append($1.code);
        temp.append($3.code);
        $$.code = strdup(temp.c_str());
        $$.place = strdup("");
        }
        | %empty
        {
          $$.place = strdup("");
          $$.code = strdup("");
      }
      ;

 declaration: identifiers COLON INTEGER 
      {
        int left = 0;
        int right = 0;
        std::string parse($1.place);
        std::string temp; //used to build output
        bool ex = false; //controls while loop

        while(!ex){
          right = parse.find("|", left);
          temp.append(". ");
          if (right == std::string::npos){
            std::string ident = parse.substr(left, right);
            if(reserved.find(ident) != reserved.end()){
              printf("Identifier %s's name is a reserved worde.\n", ident.c_str());
            }
            if (funcs.find(ident) != funcs.end() || varTemp.find(ident) != varTemp.end()){
               printf("Identifier %s is previosuly declared.\n", ident.c_str());
            } else{
              varTemp[ident] = ident;
              arrSize[ident] = 1;
            }
            temp.append(ident);
            ex = true;
          }
          else{
            varTemp[ident] = ident;
            arrSize[ident] = 1;
          }
          temp.append(ident);
          left = right+1;
        }
        $$.code = strdup(temp.c_str());
        $$.place = strdup("");
        }
        | identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER 
        {
          int left = 0;
          int right = 0;
          std::string temp;
          std::string parse($1.place);
          bool ex = false;
          while(!ex) {
            right = parse.find("|", left);
            temp.append(".[] ");
            if (right == std::string::npos){
              std::string ident = parse.substr(left,right);
              if(reserved.find(ident) != reserved.end()){
                printf("Identifier %s's name is a reserved word.\n", ident.c_str());
              }
              if (funcs.find(ident) != funcs.end() || varTemp.find(ident) != varTemp.end()){
                printf("Identifier %s's name is previously declared. \n", ident.c_str());
              }
            } else{
              if($5 <= 0){
                printf("Declaring array ident %s of size <= 0.\n", ident.c_str());
              }
              varTemp[ident] = ident;
              arrSizep[ident] = $5;
            }
            temp.append(ident);
            ex = true;
           else{
            std::string ident = parse.substr(left, right - left);
            if(reserved.find(ident) != reserved.end())
              {
                printf("Identifier %s's name is a reserved word.\n", ident.c_str());
              }
              if(funcs.find(ident) != funcs.end() || varTemp.find(ident) != varTemp.end())
              {
                printf("Identifier %s is previously declared.\n", ident.c_str());
              }
              else
              {
                if($5 <= 0){
                   printf("Declaring array ident %s of size <= 0.\n", ident.c_str());
                }
                varTemp[ident] = ident;
                arrSize[ident] = $5;
              }
              temp.append(ident);
              left = right + 1;
            }
            temp.append(", ");
            temp.append(std::to_string($5));
            temp.append("\n");
          }
            $$.code = strdup(temp.c_str());
            $$.place = strdup("");
        }
      ;

 identifiers: ident 
      {
        if(funcs.find($1) != funcs.end()){
          printf("function name %s already declared.\n", $1);
        }
        else{
          funcs.insert($1);
        }
      $$.place = strdup($1);
      $$.code = strdup("");      
      }
        | ident COMMA identifiers 
        {
          std::string temp;
          temp.append($1.place);
          temp.append("|");
          temp.append($3.place);
          $$.place = strdup(temp.c_str());
          $$.code = strdup("");
        }
        ;

 ident: IDENT 
      {
        $$.place = strdup($1.place);
        $$.code = strdup("");
      }
        ;


statements: statement SEMICOLON 
      {
        $$.code = strdup($1.place);
      }
        | statement SEMICOLON statements 
          {
            std::string temp;
            temp.append($1.code);
            temp.append($3.code);
            $$.code = strdup(temp.c_str());
          }
        ;

statement: var ASSIGN expression 
  {
    std::string temp;
    temp.append($1.code);
    temp.append($3.code);
    std::string middle = $3.place;
    if($1.arr && $3.arr){
      temp += "[]= ";
    } else if($1.arr){
      temp += "[]= ";
    } else if($3.arr){
      temp += "[]= ";
    } else{
      temp += "= ";
    }

    temp.append($1.place);
    temp.append(", ");
    temp.append(middle);
    temp += "\n";
    $$.code = strdup(temp.c_str());
  }
	| IF bool_exp THEN statements ENDIF 
  {
    std:string ifS = new_label();
    std::string after = new_label();
    std::string temp;
    temp.append($2.code);
    temp = temp + "?:= " + ifS + ", " + $2.place + "\n";
    temp = temp + ":= " + after + "\n";
    temp = temp + ": " + ifS + "\n";
    temp.append($4.code);
    temp = temp + ": " + after + "\n";
    $$.code = strdup(temp.c_str());
  }
	| IF bool_exp THEN statements ELSE statements ENDIF 
  {
    std::string ifS = new_label();
    std::string after = new_label();
    std::string temp;
    temp.append($2.code);
    temp = temp + "?:= " + ifS + ", " + $2.place + "\n";
    temp.append($6.code);

  }
	| WHILE bool_exp BEGINLOOP statements ENDLOOP 
  {
    std::string temp;
    std::string begin = new_label();
    std::string inner = new_label();
    std::string after = new_label();
    std::string code = $4.code;
    size_t pos = code.find("continue");
    while(pos != std::string::npos){
      code.replace(pos, 8, ":= "+begin);
      pos = code.find("continue");
    }
     temp.append(": ");
     temp += begin + "\n";
     temp.append($2.code);
     temp += "?:= " + inner + ", ";
     temp.append($2.place);
     temp.append("\n");
     temp += ":= " + after + "\n";
     temp += ": " + inner + "\n";
     temp.append(code);
     temp += ":= " + begin + "\n";
     temp += ": " + after + "\n";
     $$.code = strdup(temp.c_str());
  }
	| DO BEGINLOOP statements ENDLOOP WHILE bool_exp 
  {
    std::string temp;
    std::string begin = new_label();
    std::string condition = new_label();
    std::string code = $3.code;
    size_t pos = code.find("continue");
    while(pos != std::string::npos){
      code.replace(pos, 8, ":= "+condition);
      pos = code.find("continue");
    }
    temp.append(": ");
    temp += begin + "\n";
    temp.append(code);
    temp += ": " + condition + "\n";
    temp.append($6.code);
    temp += "?:= " + begin + ", ";
    temp.append($6.place);
    temp.append("\n");
    $$.code = strdup(temp.c_str());
  }
  | READ vars 
  {
    std::string temp;
    temp.append($2.code);
    size_t pos = temp.find("|", 0);
    while(pos != std::string::npos){
      temp.replace(pos, 1, "<");
      pos = temp.find("|", pos);
    }
    $$.code = strdup(temp.c_str());
  }
	| WRITE vars 
  {
    std::string temp;
    temp.append($2.code);
    size_t pos = temp.find("|", 0);
    while(pos != std::string::npos){
      temp.replace(pos, 1, ">");
      pos = temp.find("|", pos);
    }
    $$.code = strdup(temp.c_str());
  }
	| CONTINUE 
  {
    $$.code = strdup(temp.c_str());
  }
	| RETURN expression 
  {
    std::string temp;
    temp.append($2.code);
    temp.append("ret ");
    temp.append($2.place);
    temp.append("\n");
    $$.code = strdup(temp.c_str());
  }
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

std::string new_temp(){
  std::string t = "t" + std::to_string(tempCount);
  tempCount++;
  return t;
}
std::string new_label(){
  std::string l = "L" + std::to_string(labelCount);
  labelCount++;
  return l;
}

void yyerror(const char *msg) {
    /* implement your error handling */
}