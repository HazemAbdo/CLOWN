%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(char *s);
extern int yylex();
extern int yyparse();
extern int yylineno;
extern char* yytext;

%}

%union {
    int ival;
    char *sval;
}

%token <sval> IDENTIFIER STRING
%token <ival> INTEGER
%token PRINT IF ELSE WHILE FOR DO BREAK CONTINUE RETURN ERROR
%token ASSIGN PLUS MINUS TIMES DIVIDE LPAREN RPAREN SEMICOLON
%token EQUAL NOTEQUAL GREATER GREATEREQUAL LESS LESSEQUAL COMMA LBRACE RBRACE FUNCTION CONST
%token OR AND NOT
%token SWITCH CASE COLON DEFAULT

%left PLUS MINUS
%left TIMES DIVIDE
%left EQUAL NOTEQUAL GREATER GREATEREQUAL LESS LESSEQUAL
%right ASSIGN
%left OR
%left AND
%right NOT
%nonassoc UMINUS


%start program

%%

program : statement_list
        ;

statement_list : statement
               | statement_list statement 
               ;

statement : assignment_statement
          | print_statement
          | if_statement
          | while_statement
          | for_statement
          | do_statement
          | break_statement
          | continue_statement
          | return_statement
          | error_statement
          | function_declaration
          | function_call
          | const_declaration
          | switch_statement
         ;

assignment_statement : IDENTIFIER ASSIGN expression SEMICOLON
                    | IDENTIFIER ASSIGN function_call
                      ;

function_declaration : FUNCTION IDENTIFIER LPAREN function_parameters RPAREN LBRACE statement_list RBRACE
                   ;

function_parameters : function_parameters COMMA IDENTIFIER
                    | IDENTIFIER
                    ;

function_call : IDENTIFIER LPAREN function_arguments RPAREN SEMICOLON
                ;

function_arguments : function_arguments COMMA expression
                   | expression
                   ;


const_declaration: CONST assignment_statement
                 ;

switch_statement: SWITCH LPAREN IDENTIFIER RPAREN LBRACE switch_statement_details RBRACE
                ;

switch_statement_details: switch_statement_details switch_case
                        | switch_case
                        ;

switch_case: CASE expression COLON statement_list
              | DEFAULT COLON statement_list
              ;

print_statement : PRINT expression SEMICOLON 
                ;

if_statement : IF LPAREN expression RPAREN LBRACE statement_list RBRACE %prec ELSE
             | IF LPAREN expression RPAREN LBRACE statement_list RBRACE ELSE LBRACE statement_list RBRACE
             ;

while_statement : WHILE LPAREN expression RPAREN LBRACE statement_list RBRACE
                 ;

for_statement : FOR LPAREN for_init  expression SEMICOLON for_update RPAREN LBRACE statement_list RBRACE
              ;

for_init : assignment_statement
         | SEMICOLON
         ;

for_update : assignment_statement
           | SEMICOLON
           ;

do_statement : DO LBRACE statement_list RBRACE WHILE LPAREN expression RPAREN SEMICOLON
             ;

break_statement : BREAK SEMICOLON
                ;

continue_statement : CONTINUE SEMICOLON
                   ;

return_statement : RETURN expression SEMICOLON
                 ;

error_statement : ERROR SEMICOLON
                ;

expression : INTEGER
           | STRING
           | IDENTIFIER
           | LPAREN expression RPAREN             %prec UMINUS
           | expression PLUS expression           %prec PLUS
           | expression MINUS expression          %prec MINUS
           | expression TIMES expression          %prec TIMES
           | expression DIVIDE expression         %prec DIVIDE
           | expression EQUAL expression          %prec EQUAL
           | expression NOTEQUAL expression       %prec EQUAL
           | expression GREATER expression        %prec GREATER
           | expression GREATEREQUAL expression   %prec GREATER
           | expression LESS expression           %prec LESS
           | expression LESSEQUAL expression      %prec LESS
           | NOT expression                       %prec NOT  
           | expression OR expression             %prec OR
           | expression AND expression            %prec AND
           | MINUS expression                     %prec UMINUS
           ;
%%

void yyerror(char *s) {
    fprintf(stderr, "Syntax error in line %d: %s\n", yylineno, s);
    exit(EXIT_FAILURE);
}

int main() {

    

    // yyparse returns 0 if parsing was successful 
    int res = yyparse();
    if (res != 0) {
        fprintf(stderr, "Parsing failed!\n");
        exit(EXIT_FAILURE);
    }
    printf("Parsing successful!\n");
    return 0;
}