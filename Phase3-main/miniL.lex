   /* cs152-miniL phase1 */
   
%{   
   /* write your C code here for definitions of variables and including headers */
   #include "y.tab.h"
   int num_lines = 1, num_column = 1;
%}
   /* some common rules */
DIGIT  [0-9]
ID     [a-zA-Z][a-zA-Z0-9_]*[a-zA-Z0-9]*
CHAR   [a-zA-z]
E_ID_1 [0-9_][a-zA-Z0-9_]*
E_ID_2 [a-zA-Z][a-zA-Z0-9_]*[_]

%%
   /* specific lexer rules in regex */
{DIGIT}+       {yylval.int_val = atoi(yytext); num_column += yyleng; return NUMBER;}

function       {return FUNCTION; num_column += yyleng;}
beginparams    {return BEGIN_PARAMS; num_column += yyleng;}
endparams      {return END_PARAMS; num_column += yyleng;}
beginlocals    {return BEGIN_LOCALS; num_column += yyleng;}
endlocals      {return END_LOCALS; num_column += yyleng;}
beginbody      {return BEGIN_BODY; num_column += yyleng;}
endbody        {return END_BODY; num_column += yyleng;}
integer        {return INTEGER; num_column += yyleng;}
array          {return ARRAY; num_column += yyleng;}
enum           {return ENUM; num_column += yyleng;}
of             {return OF; num_column += yyleng;}
if             {return IF; num_column += yyleng;}
then           {return THEN; num_column += yyleng;}
endif          {return ENDIF; num_column += yyleng;}
else           {return ELSE; num_column += yyleng;}
for            {return FOR;  num_column += yyleng;}
while          {return WHILE; num_column += yyleng;}
do             {return DO; num_column += yyleng;}
beginloop      {return BEGINLOOP; num_column += yyleng;}
endloop        {return ENDLOOP; num_column += yyleng;}
continue       {return CONTINUE; num_column += yyleng;}
read           {return READ; num_column += yyleng;}
write          {return WRITE; num_column += yyleng;}
and            {return AND; num_column += yyleng;}
or             {return OR; num_column += yyleng;}
not            {return NOT; num_column += yyleng;}
true           {return TRUE; num_column += yyleng;}
false          {return FALSE; num_column += yyleng;}
return         {return RETURN; num_column += yyleng;}

"-"            {return SUB; num_column += yyleng;}
"+"            {return ADD; num_column += yyleng;}
"*"            {return MULT; num_column += yyleng;}
"/"            {return DIV; num_column += yyleng;}
"%"            {return MOD; num_column += yyleng;}

"=="           {return EQ; num_column += yyleng;}
"<>"           {return NEQ; num_column += yyleng;}
"<"            {return LT; num_column += yyleng;}
">"            {return GT; num_column += yyleng;}
"<="           {return LTE; num_column += yyleng;}
">="           {return GTE; num_column += yyleng;}

";"            {return SEMICOLON; num_column += yyleng;}
":"            {return COLON; num_column += yyleng;}
","            {return COMMA; num_column += yyleng;}
"("            {return L_PAREN; num_column += yyleng;}
")"            {return R_PAREN; num_column += yyleng;}
"["            {return L_SQUARE_BRACKET; num_column += yyleng;}
"]"            {return R_SQUARE_BRACKET; num_column += yyleng;}
":="           {return ASSIGN; num_column += yyleng;}

"##"[^\n]*"\n" {num_lines++; num_column = 1;}
[ ]            {num_column++;}
\t             {num_column += 4;}
\n             {num_column = 1; num_lines++;}
<<EOF>>        {exit(0);}

{E_ID_2}       {printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", num_lines, num_column, yytext); exit(-1);}
{ID}+          {yylval.ident = strdup(yytext); num_column += yyleng; return IDENT;}

.                 {printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", num_lines, num_column, yytext); exit(-1);}
{E_ID_1}          {printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", num_lines, num_column, yytext); exit(-1);}



%%
	/* C functions used in lexer */
