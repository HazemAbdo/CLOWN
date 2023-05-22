%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"

void yyerror(char *s);
extern int yylex();
extern int yyparse();
extern int yylineno;
extern char* yytext;
extern int yydebug;
symbol_table_t *symbolTable;
symbol_table_stack_t *symbolTableStack;
function_table_t *functionTable;
int FunctionScope=0;
%}

%union {
    char*string_value;
}

%token <string_value> TYPE_STRING TYPE_INT TYPE_FLOAT TYPE_BOOL TYPE_VOID
%token <string_value> INTEGER FLOAT TRUE FALSE STRING IDENTIFIER 
%token <string_value> EQUAL NOTEQUAL GREATER GREATEREQUAL LESS LESSEQUAL COMMA ASSIGN
%token <string_value> OR AND NOT
%token <string_value> PLUS MINUS TIMES DIVIDE POWER MOD UMINUS
%token <expression> NILL
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

var_declaration : DATA_TYPE IDENTIFIER ASSIGN expression SEMICOLON { addSymbol(symbolTable, functionTable, $2, $1, 0, $4); printSymbolTableStack(symbolTableStack); }
                | DATA_TYPE IDENTIFIER SEMICOLON { addSymbol(symbolTable, functionTable, $2, $1, 0, NULL); printSymbolTableStack(symbolTableStack); }
                | enum_assignment_statement
                ;

DATA_TYPE : TYPE_STRING
          | TYPE_INT
          | TYPE_FLOAT
          | TYPE_BOOL
          ;

assignment_statement : IDENTIFIER ASSIGN expression SEMICOLON { updateSymbol(symbolTable, $1, $3); printSymbolTableStack(symbolTableStack); }
                     ;

function_declaration : DATA_TYPE FUNCTION IDENTIFIER LPAREN { addFunction(functionTable, $3, $1); symbolTable=pushSymbolTable(symbolTableStack); } function_parameters RPAREN LBRACE statement_list RBRACE { printSymbolTableStack(symbolTableStack); symbolTable=popSymbolTable(symbolTableStack); }
                     | TYPE_VOID FUNCTION IDENTIFIER LPAREN { addFunction(functionTable, $3, $1); symbolTable=pushSymbolTable(symbolTableStack); } function_parameters RPAREN LBRACE statement_list RBRACE { printSymbolTableStack(symbolTableStack); symbolTable=popSymbolTable(symbolTableStack); }
                     ;

function_parameters : function_parameters COMMA DATA_TYPE IDENTIFIER { addSymbol(symbolTable, functionTable, $4, $3,0, NULL); addArgument(functionTable, $4, $3); }
                    | DATA_TYPE IDENTIFIER { addSymbol(symbolTable, functionTable, $2, $1, 0, NULL); addArgument(functionTable, $2, $1); }
                    | /* empty */
                    ;

function_call : IDENTIFIER { FunctionScope = getFunctionScope(functionTable, $1); } LPAREN function_arguments RPAREN { checkArguments(functionTable, FunctionScope); } 
              ;

function_arguments : function_arguments COMMA argument 
                   | argument 
                   | /* empty */
                   ;

argument : INTEGER { addCalledArgument(symbolTable,functionTable, FunctionScope, $1, "int"); }
         | FLOAT { addCalledArgument(symbolTable,functionTable, FunctionScope, $1, "float"); }
         | TRUE { addCalledArgument(symbolTable,functionTable, FunctionScope, $1, "bool"); }
         | FALSE { addCalledArgument(symbolTable,functionTable, FunctionScope, $1, "bool"); }
         | STRING { addCalledArgument(symbolTable,functionTable, FunctionScope, $1, "string"); }
         | IDENTIFIER { addCalledArgument(symbolTable,functionTable, FunctionScope, $1, "identifier"); }
         | argument PLUS argument 
         | argument MINUS argument 
         | argument TIMES argument 
         | argument DIVIDE argument 
         | argument POWER argument 
         | argument MOD argument 
         | argument EQUAL argument 
         | argument NOTEQUAL argument 
         | argument GREATER argument 
         | argument GREATEREQUAL argument 
         | argument LESS argument 
         | argument LESSEQUAL argument 
         | NOT argument 
         | argument OR argument 
         | argument AND argument 
         | MINUS argument 
         | function_call 
         | NILL 
         ;

const_declaration : CONST DATA_TYPE IDENTIFIER ASSIGN expression SEMICOLON { addSymbol(symbolTable, functionTable, $3, $2, 1, $5); printSymbolTableStack(symbolTableStack); }
                  ;

switch_statement : SWITCH LPAREN IDENTIFIER RPAREN LBRACE { symbolTable=pushSymbolTable(symbolTableStack); } switch_statement_details RBRACE { symbolTable=popSymbolTable(symbolTableStack); }
                 ;

switch_statement_details : switch_statement_details switch_case
                         | switch_case
                         ;

switch_case : CASE expression COLON statement_list
            | DEFAULT COLON statement_list
            ;

enum_declaration_list : enum_declaration
                      ;

enum_declaration : ENUM IDENTIFIER LBRACE { symbolTable=pushSymbolTable(symbolTableStack); } enum_item_list RBRACE { symbolTable=popSymbolTable(symbolTableStack); } SEMICOLON
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
if_statement : IF LPAREN expression RPAREN LBRACE { symbolTable=pushSymbolTable(symbolTableStack); } statement_list RBRACE { symbolTable=popSymbolTable(symbolTableStack); } elif_statement_list else_statement %prec IF
             ;

elif_statement_list : elif_statement_list elif_statement
                    | elif_statement
                    | /* empty */
                    ;

elif_statement : ELIF LPAREN expression RPAREN LBRACE { symbolTable=pushSymbolTable(symbolTableStack); } statement_list RBRACE { symbolTable=popSymbolTable(symbolTableStack); }
               ;

else_statement : ELSE LBRACE { symbolTable=pushSymbolTable(symbolTableStack); } statement_list RBRACE { symbolTable=popSymbolTable(symbolTableStack); } %prec ELSE
               | /* empty */
               ;

while_statement : WHILE LPAREN expression RPAREN LBRACE { symbolTable=pushSymbolTable(symbolTableStack); } statement_list RBRACE { symbolTable=popSymbolTable(symbolTableStack); }
                | WHILE LPAREN expression RPAREN LBRACE { symbolTable=pushSymbolTable(symbolTableStack); } RBRACE { symbolTable=popSymbolTable(symbolTableStack); }
                ;

for_statement : FOR LPAREN for_init expression SEMICOLON for_update RPAREN LBRACE { symbolTable=pushSymbolTable(symbolTableStack); } statement_list RBRACE { symbolTable=popSymbolTable(symbolTableStack); }
              | FOR LPAREN for_init expression SEMICOLON for_update RPAREN LBRACE { symbolTable=pushSymbolTable(symbolTableStack); } RBRACE { symbolTable=popSymbolTable(symbolTableStack); }
              ;

for_init : var_declaration
         | SEMICOLON
         ;

for_update : for_update_expression
           | SEMICOLON
           ;

for_update_expression : IDENTIFIER ASSIGN expression
                      ;

do_statement : DO LBRACE { symbolTable=pushSymbolTable(symbolTableStack); } statement_list RBRACE { symbolTable=popSymbolTable(symbolTableStack); } WHILE LPAREN expression RPAREN SEMICOLON
             | DO LBRACE { symbolTable=pushSymbolTable(symbolTableStack); } RBRACE { symbolTable=popSymbolTable(symbolTableStack); } WHILE LPAREN expression RPAREN SEMICOLON
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


expression : INTEGER { $$ = $1; }
           | FLOAT 
           | TRUE 
           | FALSE 
           | STRING 
           | NILL
           | function_call
           | LPAREN expression RPAREN             %prec UMINUS
           | IDENTIFIER   { lookupSymbol(symbolTableStack, $1); }
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
    // exit(EXIT_FAILURE);
}

int main() {

    // make stderr to file outputs/errors.txt
    freopen("outputs/errors.txt", "w", stderr);

    FILE *fp;
    fp = fopen("outputs/symbol_table.txt", "w");
    symbolTable = initSymbolTable();
    symbolTableStack = initSymbolTableStack(symbolTable);
    functionTable = initFunctionTable();
    yydebug = 0;
    int res = yyparse();
    if (res != 0) {
        fprintf(stderr, "Parsing failed!\n");
        exit(EXIT_FAILURE);
    }
    printf("Parsing successful!\n");
    unInitalized_variables(symbolTable);
    freeSymbolTable(symbolTable);
    return 0;
}