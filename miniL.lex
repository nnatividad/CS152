   /* cs152-miniL phase1 */
   
%{   
   /* write your C code here for definitions of variables and including headers */
	int num_lines = 1, num_column = 1;
%}

   /* some common rules */
DIGIT  [0-9]
ID     [a-zA-Z][a-zA-z0-9]*[a-zA-Z0-9]
CHAR   [a-zA-z]
E_ID_1 [0-9_][a-zA-Z0-9_]*
E_ID_2 [a-zA-Z][a-zA-Z0-9_]*[_]

%%
   /* specific lexer rules in regex */



%%
	/* C functions used in lexer */

int main(int argc, char ** argv)
{
   yylex();
}
