%{
#include <stdio.h>
#include <stdlib.h>
#include "hash.h"
int yylex();
int yyerror(char *msg);

%}

%union {
	HASH_NODE* symbol;
}

%token KW_CHAR
%token KW_INT
%token KW_FLOAT
%token KW_IF
%token KW_THEN
%token KW_ELSE
%token KW_WHILE
%token KW_READ
%token KW_RETURN
%token KW_PRINT
%token OPERATOR_LE
%token OPERATOR_GE
%token OPERATOR_EQ
%token OPERATOR_OR
%token OPERATOR_AND
%token OPERATOR_NOT
%token<symbol> TK_IDENTIFIER
%token<symbol> LIT_INTEGER
%token<symbol> LIT_FLOAT
%token<symbol> LIT_CHAR
%token<symbol> LIT_STRING
%token TOKEN_ERROR

%left OPERATOR_LE OPERATOR_GE OPERATOR_EQ 
%left '<' '>'
%left OPERATOR_AND OPERATOR_OR
%left '+' '-'
%left '*' '/'

%nonassoc IFX
%nonassoc ELSE

%%

program : cmdlist
		;

cmdlist : cmd cmdlist
		|/*empty*/
		;

cmd		: KW_IF expr KW_THEN cmd %prec IFX
		| KW_IF expr KW_THEN expr KW_ELSE cmd
		| KW_READ TK_IDENTIFIER ';'
		| KW_PRINT LIT_STRING ';'
		| func
		| declaration ';'
		| KW_RETURN expr ';'
		| attribution ;
		;
		
attribution	: TK_IDENTIFIER '=' literal
			| TK_IDENTIFIER 'q' TK_IDENTIFIER 'p' '=' literal;
			;
			
declaration	: data_type TK_IDENTIFIER '=' literal
			| data_type TK_IDENTIFIER 'q' size_vec 'p' '=' literal
			| data_type TK_IDENTIFIER 'q' size_vec 'p' ':' init_vector 
			;
			
size_vec	: TK_IDENTIFIER
			| number
			;
			
init_vector	:' ' number
			|init_vector ' ' number 
			;
expr	: LIT_INTEGER		{fprintf(stderr,"  Achei LIT_INTEGER  %d", $1->type); } 
		| LIT_FLOAT
		| TK_IDENTIFIER
		| expr '+' expr
		| expr '-' expr
		| expr '*' expr
		| expr '/' expr
		| expr OPERATOR_LE expr
		| expr OPERATOR_GE expr
		| expr OPERATOR_AND expr
		| expr OPERATOR_OR expr
		| expr OPERATOR_EQ expr
		| expr OPERATOR_NOT expr
		;
number	: LIT_INTEGER
		| LIT_FLOAT	
		;
		
literal : LIT_INTEGER
		| LIT_FLOAT
		| LIT_CHAR
		;
		
func	: data_type TK_IDENTIFIER 'd' param_list 'b' block
		;
		
block	:
		;
data_type	: KW_CHAR
			| KW_INT
			| KW_FLOAT
			; 	
			
param_list	: param
			| param_list ',' param
			| /*empty*/
			;
			
param		: data_type TK_IDENTIFIER
			;
			
list		: item
			| list ',' item
			;
			
item 		:
			;
%%

int yyerror(char *msg)
{
fprintf(stderr, "Syntax Error at line: %d", getLineNumber());
exit(3);
}