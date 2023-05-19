%{
#include "test.h"

void yyerror(char *s);
extern int yylex();
extern int yyparse();
extern int yylineno;
extern char* yytext;

%}

%union {
    int ival;
    float fval;
    char *sval;
    int *bval;
}

%token <sval> IDENTIFIER STRING
%token <ival> INTEGER
%token <fval> FLOAT
%token <bval> TRUE FALSE
%token PRINT IF ELSE WHILE FOR DO BREAK CONTINUE RETURN ERROR
%token ASSIGN PLUS MINUS TIMES DIVIDE LPAREN RPAREN SEMICOLON
%token EQUAL NOTEQUAL GREATER GREATEREQUAL LESS LESSEQUAL COMMA LBRACE RBRACE FUNCTION CONST
%token OR AND NOT
%token SWITCH CASE COLON DEFAULT ELIF ENUM NILL POWER MOD UMINUS

%nonassoc UMINUS
%left POWER
%left TIMES DIVIDE MOD
%left PLUS MINUS
%left EQUAL NOTEQUAL GREATER GREATEREQUAL LESS LESSEQUAL
%right ASSIGN
%right NOT
%left OR
%left AND

%start program

%%

program : statement_list { writeSymbolTable(); freeSymbolTable(); }
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
          | function_call SEMICOLON
          | const_declaration
          | switch_statement
          | enum_declaration_list
          ;

assignment_statement : IDENTIFIER SEMICOLON { addSymbolEntry($1, IDENTIFIER, 0); }
                     | IDENTIFIER ASSIGN expression SEMICOLON { addSymbolEntry($1, IDENTIFIER, 1); }
                     | enum_assignment_statement
                     ;

function_declaration : FUNCTION IDENTIFIER LPAREN function_parameters RPAREN LBRACE statement_list RBRACE { addSymbolEntry($2, FUNCTION, 0); }
                     ;

function_parameters : function_parameters COMMA IDENTIFIER
                    | IDENTIFIER
                    | /* empty */
                    ;

function_call : IDENTIFIER LPAREN function_arguments RPAREN
              ;

function_arguments : function_arguments COMMA expression
                   | expression
                   | /* empty */
                   ;


const_declaration : CONST assignment_statement
                  ;

switch_statement : SWITCH LPAREN IDENTIFIER RPAREN LBRACE switch_statement_details RBRACE
                 ;

switch_statement_details : switch_statement_details switch_case
                         | switch_case
                         ;

switch_case   : CASE expression COLON statement_list
              | DEFAULT COLON statement_list
              ;

enum_declaration_list : enum_declaration
                      ;

enum_declaration : ENUM IDENTIFIER LBRACE enum_item_list RBRACE SEMICOLON
                 ;

enum_item_list : enum_item
               | enum_item_list COMMA enum_item
               ;

enum_item : IDENTIFIER
          | IDENTIFIER ASSIGN expression
          ;

enum_assignment_statement : IDENTIFIER IDENTIFIER ASSIGN IDENTIFIER SEMICOLON
                          ;

print_statement : PRINT expression SEMICOLON 
                ;

if_statement : IF LPAREN expression RPAREN LBRACE statement_list RBRACE %prec ELSE
             | IF LPAREN expression RPAREN LBRACE statement_list RBRACE elif_statement_list %prec ELSE
             | IF LPAREN expression RPAREN LBRACE statement_list RBRACE else_statement %prec ELSE
             | IF LPAREN expression RPAREN LBRACE statement_list RBRACE elif_statement_list else_statement %prec ELSE
             ;

elif_statement_list : elif_statement_list elif_statement
                    | elif_statement
                    ;

elif_statement : ELIF LPAREN expression RPAREN LBRACE statement_list RBRACE
               ;

else_statement : ELSE LBRACE statement_list RBRACE
               ;

while_statement : WHILE LPAREN expression RPAREN LBRACE statement_list RBRACE
                | WHILE LPAREN expression RPAREN LBRACE  RBRACE 
                ;

for_statement : FOR LPAREN for_init  expression SEMICOLON for_update RPAREN LBRACE statement_list RBRACE
              | FOR LPAREN for_init  expression SEMICOLON for_update RPAREN LBRACE  RBRACE
              ;

for_init : assignment_statement
         | SEMICOLON
         ;

for_update : assignment_statement
           | SEMICOLON
           ;

do_statement : DO LBRACE statement_list RBRACE WHILE LPAREN expression RPAREN SEMICOLON
             | DO LBRACE  RBRACE WHILE LPAREN expression RPAREN SEMICOLON
             ;

break_statement : BREAK SEMICOLON
                ;

continue_statement : CONTINUE SEMICOLON
                   ;

return_statement : RETURN expression SEMICOLON
                 | RETURN SEMICOLON
                 ;

error_statement : ERROR SEMICOLON
                ;


expression : INTEGER
           | FLOAT
           | TRUE
           | FALSE
           | STRING
           | IDENTIFIER
           | NILL
           | function_call
           | LPAREN expression RPAREN             %prec UMINUS
           | expression PLUS expression           %prec PLUS
           | expression MINUS expression          %prec MINUS
           | expression POWER expression          %prec POWER
           | expression TIMES expression          %prec TIMES
           | expression DIVIDE expression         %prec DIVIDE
           | expression MOD expression            %prec MOD
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
    int res = yyparse();
    if (res != 0) {
        fprintf(stderr, "Parsing failed!\n");
        exit(EXIT_FAILURE);
    }
    printf("Parsing successful!\n");
    return 0;
}