%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../symbol_table.h"

void yyerror(char *s);
extern int yylex();
extern int yyparse();
extern int yylineno;
extern char* yytext;
extern int yydebug;
symbol_table_t *symbolTable;
symbol_table_stack_t *symbolTableStack;


%}

%union {
    char*string_value;
}

%token <string_value> TYPE_STRING TYPE_INT TYPE_FLOAT TYPE_BOOL TYPE_VOID
%token <string_value> INTEGER FLOAT TRUE FALSE STRING IDENTIFIER 
%token <string_value> EQUAL NOTEQUAL GREATER GREATEREQUAL LESS LESSEQUAL COMMA ASSIGN
%token <string_value> OR AND NOT
%token <string_value> PLUS MINUS TIMES DIVIDE POWER MOD UMINUS
%token  <expression> NILL
%token PRINT IF ELSE WHILE FOR DO BREAK CONTINUE RETURN ERROR SWITCH CASE COLON DEFAULT ELIF ENUM FUNCTION CONST SEMICOLON
%token LPAREN RPAREN LBRACE RBRACE

%type <string_value> DATA_TYPE expression

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

program : statement_list  
        ;

statement_list : statement_list_inner
               ;

statement_list_inner : statement
                     | statement_list statement 
                     ;
statement : var_declaration
        | assignment_statement
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

var_declaration :DATA_TYPE IDENTIFIER ASSIGN expression SEMICOLON   {addSymbol(symbolTable, $2, $1,0, $4);}
                    | DATA_TYPE IDENTIFIER SEMICOLON  {addSymbol(symbolTable, $2, $1,0, NULL);}
                    | enum_assignment_statement
                      ;

DATA_TYPE : TYPE_STRING 
         | TYPE_INT
         | TYPE_FLOAT
         | TYPE_BOOL
         ;

assignment_statement : IDENTIFIER ASSIGN expression SEMICOLON {updateSymbol(symbolTable, $1, $3);}
                     ;

function_declaration : DATA_TYPE FUNCTION IDENTIFIER LPAREN function_parameters RPAREN LBRACE { symbolTable= pushSymbolTable(symbolTableStack); } statement_list  RBRACE { symbolTable=popSymbolTable(symbolTableStack);}
                    | TYPE_VOID FUNCTION IDENTIFIER LPAREN function_parameters RPAREN LBRACE { symbolTable= pushSymbolTable(symbolTableStack); } statement_list  RBRACE { symbolTable=popSymbolTable(symbolTableStack);}
                   ;

function_parameters : function_parameters COMMA DATA_TYPE IDENTIFIER
                    | DATA_TYPE IDENTIFIER
                    | /* empty */
                    ;

function_call : IDENTIFIER LPAREN function_arguments RPAREN
                ;

function_arguments : function_arguments COMMA expression
                   | expression
                   | /* empty */
                   ;


const_declaration: CONST DATA_TYPE IDENTIFIER ASSIGN expression SEMICOLON {addSymbol(symbolTable, $3, $2,1, $5);}
                 ;

switch_statement: SWITCH LPAREN IDENTIFIER RPAREN LBRACE { symbolTable= pushSymbolTable(symbolTableStack); } switch_statement_details  RBRACE { symbolTable=popSymbolTable(symbolTableStack);}
                ;

switch_statement_details: switch_statement_details switch_case
                        | switch_case
                        ;

switch_case: CASE expression COLON statement_list
              | DEFAULT COLON statement_list
              ;

enum_declaration_list : enum_declaration
                      ;

enum_declaration : ENUM IDENTIFIER LBRACE { symbolTable= pushSymbolTable(symbolTableStack); } enum_item_list  RBRACE { symbolTable=popSymbolTable(symbolTableStack);} SEMICOLON
                  ;

enum_item_list : enum_item
               | enum_item_list COMMA enum_item
               ;

enum_item : IDENTIFIER
          | IDENTIFIER ASSIGN expression
          ;

enum_assignment_statement: IDENTIFIER IDENTIFIER ASSIGN IDENTIFIER SEMICOLON
                         ;

print_statement : PRINT expression SEMICOLON 
                ;

if_statement : IF LPAREN expression RPAREN LBRACE { symbolTable= pushSymbolTable(symbolTableStack); } statement_list RBRACE { symbolTable=popSymbolTable(symbolTableStack);  } %prec ELSE
             | IF LPAREN expression RPAREN LBRACE { symbolTable= pushSymbolTable(symbolTableStack); } statement_list RBRACE { symbolTable=popSymbolTable(symbolTableStack);  } elif_statement_list %prec ELSE
             | IF LPAREN expression RPAREN LBRACE { symbolTable= pushSymbolTable(symbolTableStack); } statement_list RBRACE { symbolTable=popSymbolTable(symbolTableStack);  } else_statement %prec ELSE
             | IF LPAREN expression RPAREN LBRACE { symbolTable= pushSymbolTable(symbolTableStack); } statement_list RBRACE { symbolTable=popSymbolTable(symbolTableStack);  } elif_statement_list else_statement %prec ELSE
             
             ;

elif_statement_list : elif_statement_list elif_statement
                    | elif_statement
                    ;

elif_statement : ELIF LPAREN expression RPAREN LBRACE { symbolTable= pushSymbolTable(symbolTableStack); } statement_list  RBRACE { symbolTable=popSymbolTable(symbolTableStack);}
               ;

else_statement : ELSE LBRACE { symbolTable= pushSymbolTable(symbolTableStack); } statement_list  RBRACE { symbolTable=popSymbolTable(symbolTableStack);}
               ;

while_statement : WHILE LPAREN expression RPAREN LBRACE { symbolTable= pushSymbolTable(symbolTableStack); } statement_list RBRACE { symbolTable=popSymbolTable(symbolTableStack);}
                | WHILE LPAREN expression RPAREN LBRACE { symbolTable= pushSymbolTable(symbolTableStack); } RBRACE { symbolTable=popSymbolTable(symbolTableStack);}
                 ;

for_statement : FOR LPAREN for_init  expression SEMICOLON for_update RPAREN LBRACE { symbolTable= pushSymbolTable(symbolTableStack); } statement_list  RBRACE { symbolTable=popSymbolTable(symbolTableStack);}
              | FOR LPAREN for_init  expression SEMICOLON for_update RPAREN LBRACE { symbolTable= pushSymbolTable(symbolTableStack); }   RBRACE { symbolTable=popSymbolTable(symbolTableStack);}
              ;


for_init : var_declaration
         | SEMICOLON
         ;

for_update : for_update_expression
           | SEMICOLON
           ;

for_update_expression: IDENTIFIER ASSIGN expression
                     ;

do_statement : DO LBRACE { symbolTable= pushSymbolTable(symbolTableStack); } statement_list  RBRACE { symbolTable=popSymbolTable(symbolTableStack);} WHILE LPAREN expression RPAREN SEMICOLON
             | DO LBRACE { symbolTable= pushSymbolTable(symbolTableStack); } RBRACE { symbolTable=popSymbolTable(symbolTableStack);} WHILE LPAREN expression RPAREN SEMICOLON
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


expression : INTEGER {$$ = $1;}
           | FLOAT 
           | TRUE 
           | FALSE 
           | STRING 
           | NILL
           | function_call
           | LPAREN expression RPAREN             %prec UMINUS
           | IDENTIFIER   {lookupSymbol(symbolTableStack, $1);}
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
    FILE *fp;
    fp = fopen("symbol_table.csv", "w");
    symbolTable = initSymbolTable();
    symbolTableStack = initSymbolTableStack(symbolTable);
    yydebug = 0;
    int res = yyparse();
    if (res != 0) {
        fprintf(stderr, "Parsing failed!\n");
        exit(EXIT_FAILURE);
    }
    printf("Parsing successful!\n");
    printSymbolTableStack(symbolTableStack);
    unInitalized_variables(symbolTable);
    freeSymbolTable(symbolTable);
    return 0;
}