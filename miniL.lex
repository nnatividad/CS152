   /* cs152-miniL phase1 */
   
%{   
   /* write your C code here for definitions of variables and including headers */
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
{DIGIT}+       {printf("NUMBER %s\n", yytext); num_column += yyleng;}

function       {printf("FUNCTION\n"); num_column += yyleng;}
beginparams    {printf("BEGIN_PARAMS\n"); num_column += yyleng;}
endparams      {printf("END_PARAMS\n"); num_column += yyleng;}
beginlocals    {printf("BEGIN_LOCALS\n"); num_column += yyleng;}
endlocals      {printf("END_LOCALS\n"); num_column += yyleng;}
beginbody      {printf("BEGIN_BODY\n"); num_column += yyleng;}
endbody        {printf("END_BODY\n"); num_column += yyleng;}
integer        {printf("INTEGER\n"); num_column += yyleng;}
array          {printf("ARRAY\n"); num_column += yyleng;}
enum           {printf("ENUM\n"); num_column += yyleng;}
of             {printf("OF\n"); num_column += yyleng;}
if             {printf("IF\n"); num_column += yyleng;}
then           {printf("THEN\n"); num_column += yyleng;}
endif          {printf("ENDIF\n"); num_column += yyleng;}
else           {printf("ELSE\n"); num_column += yyleng;}
for            {printf("FOR\n");  num_column += yyleng;}
while          {printf("WHILE\n"); num_column += yyleng;}
do             {printf("DO\n"); num_column += yyleng;}
beginloop      {printf("BEGINLOOP\n"); num_column += yyleng;}
endloop        {printf("ENDLOOP\n"); num_column += yyleng;}
continue       {printf("CONTINUE\n"); num_column += yyleng;}
read           {printf("READ\n"); num_column += yyleng;}
write          {printf("WRITE\n"); num_column += yyleng;}
and            {printf("AND\n"); num_column += yyleng;}
or             {printf("OR\n"); num_column += yyleng;}
not            {printf("NOT\n"); num_column += yyleng;}
true           {printf("TRUE\n"); num_column += yyleng;}
false          {printf("FALSE\n"); num_column += yyleng;}
return         {printf("RETURN\n"); num_column += yyleng;}

"-"            {printf("SUB\n"); num_column += yyleng;}
"+"            {printf("ADD\n"); num_column += yyleng;}
"*"            {printf("MULT\n"); num_column += yyleng;}
"/"            {printf("DIV\n"); num_column += yyleng;}
"%"            {printf("MOD\n"); num_column += yyleng;}

"=="           {printf("EQ\n"); num_column += yyleng;}
"<>"           {printf("NEQ\n"); num_column += yyleng;}
"<"            {printf("LT\n"); num_column += yyleng;}
">"            {printf("GT\n"); num_column += yyleng;}
"<="           {printf("LTE\n"); num_column += yyleng;}
">="           {printf("GTE\n"); num_column += yyleng;}

";"            {printf("SEMICOLON\n"); num_column += yyleng;}
":"            {printf("COLON\n"); num_column += yyleng;}
","            {printf("COMMA\n"); num_column += yyleng;}
"("            {printf("L_PAREN\n"); num_column += yyleng;}
")"            {printf("R_PAREN\n"); num_column += yyleng;}
"["            {printf("L_SQUARE_BRACKET\n"); num_column += yyleng;}
"]"            {printf("R_SQUARE_BRACKET\n"); num_column += yyleng;}
":="              {printf("ASSIGN\n"); num_column += yyleng;}

"##"[^\n]*"\n" {num_lines++; num_column = 1;}
[ ]            {num_column++;}
\t             {num_column += 4;}
\n             {num_column = 1; num_lines++;}
<<EOF>>        {exit(0);}

{DIGIT}+       {printf("NUMBER %s\n", yytext); num_column += yyleng;}
{ID}+          {printf("IDENT %s\n", yytext); num_column += yyleng;}

.                 {printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", num_lines, num_column, yytext); exit(-1);}
{E_ID_1}          {printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", num_lines, num_column, yytext); exit(-1);}
{E_ID_2}          {printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", num_lines, num_column, yytext); exit(-1);}
%%
	/* C functions used in lexer */

int main(int argc, char ** argv)
{
   yylex();
}
