%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <sys/stat.h>
    #include "symbol_table.h"
    #include "code_generator.h"

    int mkdir(const char *path, mode_t mode);

    void yyerror(char *s);
    extern char *yytext;
    extern int yylex();
    extern int yyparse();
    extern int yylineno;
    extern int yydebug;
    extern int line_no;

    symbol_table_t *symbolTable;
    symbol_table_stack_t *symbolTableStack;
    function_table_t *functionTable;
    int FunctionScope = 0;
%}

%union {
    char*string_value;
}

%token <string_value> TYPE_STRING TYPE_INT TYPE_FLOAT TYPE_BOOL TYPE_VOID
%token <string_value> INTEGER FLOAT TRUE FALSE STRING IDENTIFIER 
%token <string_value> EQUAL NOTEQUAL GREATER GREATEREQUAL LESS LESSEQUAL COMMA ASSIGN
%token <string_value> OR AND NOT
%token <string_value> PLUS MINUS TIMES DIVIDE POWER MOD UMINUS
%token <string_value> NILL
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

var_declaration : DATA_TYPE IDENTIFIER { pushQuad($2, 0); } ASSIGN expression SEMICOLON { addSymbol(symbolTable, functionTable, $2, $1, 0, $5); printSymbolTableStack(symbolTableStack); popQuad(quadsStack[quadsStackTop - 2]); }
                | DATA_TYPE IDENTIFIER SEMICOLON { addSymbol(symbolTable, functionTable, $2, $1, 0, NULL); printSymbolTableStack(symbolTableStack); }
                | enum_assignment_statement
                ;

DATA_TYPE : TYPE_STRING
          | TYPE_INT
          | TYPE_FLOAT
          | TYPE_BOOL
          ;

assignment_statement : IDENTIFIER { pushQuad($1, 0); } ASSIGN expression SEMICOLON { popQuad(quadsStack[quadsStackTop - 2]); updateSymbol(symbolTableStack, $1, $3); printSymbolTableStack(symbolTableStack); }
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

argument : INTEGER      { addCalledArgument(symbolTable,functionTable, FunctionScope, $1, "int"); }
         | FLOAT        { addCalledArgument(symbolTable,functionTable, FunctionScope, $1, "float"); }
         | TRUE         { addCalledArgument(symbolTable,functionTable, FunctionScope, $1, "bool"); }
         | FALSE        { addCalledArgument(symbolTable,functionTable, FunctionScope, $1, "bool"); }
         | STRING       { addCalledArgument(symbolTable,functionTable, FunctionScope, $1, "string"); }
         | IDENTIFIER   { addCalledArgument(symbolTable,functionTable, FunctionScope, $1, "identifier"); }
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

const_declaration : CONST DATA_TYPE IDENTIFIER { pushQuad($3, 0); } ASSIGN expression SEMICOLON { addSymbol(symbolTable, functionTable, $3, $2, 1, $6); printSymbolTableStack(symbolTableStack); popQuad(quadsStack[quadsStackTop - 2]); }
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

if_statement : IF LPAREN expression RPAREN LBRACE { symbolTable=pushSymbolTable(symbolTableStack); addLabel(); JZ(1); } if_statement_list RBRACE { symbolTable=popSymbolTable(symbolTableStack); } elif_statement_list else_statement %prec IF { printLabel(1, -1); popLabels(1); }
             ;

if_statement_list : statement_list
                  | /* empty */
                  ;

elif_statement_list : elif_statement_list elif_statement
                    | elif_statement
                    | /* empty */
                    ;

elif_statement : { JMP(1, -1); printLabel(0, 2); } ELIF LPAREN expression RPAREN LBRACE { symbolTable=pushSymbolTable(symbolTableStack); JZ(0); } if_statement_list RBRACE { symbolTable=popSymbolTable(symbolTableStack); }
               ;

else_statement : { JMP(1, -1); printLabel(0, 2); } ELSE LBRACE { symbolTable=pushSymbolTable(symbolTableStack); } if_statement_list RBRACE { symbolTable=popSymbolTable(symbolTableStack); } %prec ELSE
               | /* empty */
               ;

while_statement : WHILE { printLabel(1, 1); } LPAREN expression RPAREN { JZ(1); } LBRACE { symbolTable=pushSymbolTable(symbolTableStack); } statement_list RBRACE { symbolTable=popSymbolTable(symbolTableStack); JMP(0, 2); printLabel(0, 1); popLabels(2); }
                | WHILE { printLabel(1, 1); } LPAREN expression RPAREN { JZ(1); } LBRACE { symbolTable=pushSymbolTable(symbolTableStack); } RBRACE { symbolTable=popSymbolTable(symbolTableStack); JMP(0, 2); printLabel(0, 1); popLabels(2); }
                ;

for_statement : FOR LPAREN for_init { printLabel(1, 1); } expression SEMICOLON { JZ(1); } for_update RPAREN LBRACE { symbolTable=pushSymbolTable(symbolTableStack); } statement_list RBRACE { symbolTable=popSymbolTable(symbolTableStack); JMP(0, 2); printLabel(0, 1); popLabels(2); }
              | FOR LPAREN for_init { printLabel(1, 1); } expression SEMICOLON { JZ(1); } for_update RPAREN LBRACE { symbolTable=pushSymbolTable(symbolTableStack); } RBRACE { symbolTable=popSymbolTable(symbolTableStack); JMP(0, 2); printLabel(0, 1); popLabels(2); }
              ;

for_init : var_declaration
         | assignment_statement
         | SEMICOLON
         ;

for_update : IDENTIFIER ASSIGN expression { popQuad($1); }
           | /* empty */
           ;

do_statement : DO LBRACE { symbolTable=pushSymbolTable(symbolTableStack); printLabel(1, 1); } statement_list RBRACE { symbolTable=popSymbolTable(symbolTableStack); } WHILE LPAREN expression RPAREN SEMICOLON { addLabel(); JZ(0); JMP(0, 2); printLabel(0, 1); popLabels(2); }
             | DO LBRACE { symbolTable=pushSymbolTable(symbolTableStack); printLabel(1, 1); } RBRACE { symbolTable=popSymbolTable(symbolTableStack); } WHILE LPAREN expression RPAREN SEMICOLON { addLabel(); JZ(0); JMP(0, 2); printLabel(0, 1); popLabels(2); }
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

expression : INTEGER    { pushQuad($1, 1); }
           | FLOAT      { pushQuad($1, 1); }
           | TRUE       { pushQuad($1, 1); }
           | FALSE      { pushQuad($1, 1); }
           | STRING     { pushQuad($1, 1); }
           | NILL
           | function_call
           | LPAREN expression RPAREN             %prec UMINUS  { $$=$2; }
           | IDENTIFIER   { lookupSymbol(symbolTableStack, $1); pushQuad($1, 1); }
           | expression PLUS expression           %prec PLUS    { twoOperandsQuad($2); }
           | expression MINUS expression          %prec MINUS   { twoOperandsQuad($2); }
           | expression POWER expression          %prec POWER   { twoOperandsQuad($2); }
           | expression TIMES expression          %prec TIMES   { twoOperandsQuad($2); }
           | expression DIVIDE expression         %prec DIVIDE  { twoOperandsQuad($2); }
           | expression MOD expression            %prec MOD     { twoOperandsQuad($2); }
           | expression EQUAL expression          %prec EQUAL   { twoOperandsQuad($2); }
           | expression NOTEQUAL expression       %prec EQUAL   { twoOperandsQuad($2); }
           | expression GREATER expression        %prec GREATER { twoOperandsQuad($2); }
           | expression GREATEREQUAL expression   %prec GREATER { twoOperandsQuad($2); }
           | expression LESS expression           %prec LESS    { twoOperandsQuad($2); }
           | expression LESSEQUAL expression      %prec LESS    { twoOperandsQuad($2); }
           | expression OR expression             %prec OR      { twoOperandsQuad($2); }
           | expression AND expression            %prec AND     { twoOperandsQuad($2); }
           | NOT expression                       %prec NOT     { oneOperandQuad($1); }
           | MINUS expression                     %prec UMINUS  { oneOperandQuad($1); }
           ;
%%

void yyerror(char *s) {
    fprintf(stderr, "Syntax error in line %d: %s\n", yylineno, s);
    printf("Syntax error in line %d: %s\n", yylineno, s);
    // exit(EXIT_FAILURE);
}

int main() {
    mkdir("outputs", 0777);

    // make stderr to file outputs/errors.txt
    freopen("outputs/errors.txt", "w", stderr);

    FILE *f = fopen("outputs/symbol_table.txt", "w");
    if (f == NULL)
    {
        printf("Error opening outputs/symbol_table.txt file!\n");
        exit(1);
    }
    fclose(f);

    loopsStack[0] = 0;
    symbolTable = initSymbolTable();
    symbolTableStack = initSymbolTableStack(symbolTable);
    functionTable = initFunctionTable();
    yydebug = 0;
    int res = yyparse();
    if (res != 0) {
        printf("Parsing failed!\n");
        exit(EXIT_FAILURE);
    }
    // printf("Parsing successful!\n");
    unInitalized_variables(symbolTable);
    freeSymbolTable(symbolTable);
    printQuadruples();
    
    return 0;
}
