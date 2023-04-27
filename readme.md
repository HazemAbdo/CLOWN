# Run The code (Ubuntu)

```
flex -l -d simple.lex
bison -l -d -v simple.y
gcc -o parser simple.tab.c simple.tab.h lex.yy.c -lfl
./parser < code.clown
```

sample code.clown

```
switch(x){
    case 1:
        print("x is 1");
        break;
    case 2:
        print("x is 2");
        break;
    default:
        print("x is neither 1 nor 2");
        break;
}

if(x == 1){
    y = 10;
    print("x is 1");
}else{
    print("x is neither 1 nor 2");
}


for(i = 0; i < 10; i=i+1;){
    print(i);
}
```

expected output

```
--(end of buffer or a NUL)
--accepting rule at line 81 ("switch")
--accepting rule at line 74 ("(")
--accepting rule at line 88 ("x")
--accepting rule at line 75 (")")
--accepting rule at line 76 ("{")
--accepting rule at line 86 ("
")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 82 ("case")
--accepting rule at line 86 (" ")
--accepting rule at line 89 ("1")
--accepting rule at line 84 (":")
--accepting rule at line 86 ("
")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 51 ("print")
--accepting rule at line 74 ("(")
--accepting rule at line 87 (""x is 1"")
--accepting rule at line 75 (")")
--accepting rule at line 78 (";")
--accepting rule at line 86 ("
")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 57 ("break")
--accepting rule at line 78 (";")
--accepting rule at line 86 ("
")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 82 ("case")
--accepting rule at line 86 (" ")
--accepting rule at line 89 ("2")
--accepting rule at line 84 (":")
--accepting rule at line 86 ("
")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 51 ("print")
--accepting rule at line 74 ("(")
--accepting rule at line 87 (""x is 2"")
--accepting rule at line 75 (")")
--accepting rule at line 78 (";")
--accepting rule at line 86 ("
")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 57 ("break")
--accepting rule at line 78 (";")
--accepting rule at line 86 ("
")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 83 ("default")
--accepting rule at line 84 (":")
--accepting rule at line 86 ("
")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 51 ("print")
--accepting rule at line 74 ("(")
--accepting rule at line 87 (""x is neither 1 nor 2"")
--accepting rule at line 75 (")")
--accepting rule at line 78 (";")
--accepting rule at line 86 ("
")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 57 ("break")
--accepting rule at line 78 (";")
--accepting rule at line 86 ("
")
--accepting rule at line 77 ("}")
--accepting rule at line 86 ("
")
--accepting rule at line 86 ("
")
--accepting rule at line 52 ("if")
--accepting rule at line 74 ("(")
--accepting rule at line 88 ("x")
--accepting rule at line 86 (" ")
--accepting rule at line 61 ("==")
--accepting rule at line 86 (" ")
--accepting rule at line 89 ("1")
--accepting rule at line 75 (")")
--accepting rule at line 76 ("{")
--accepting rule at line 86 ("
")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 88 ("y")
--accepting rule at line 86 (" ")
--accepting rule at line 60 ("=")
--accepting rule at line 86 (" ")
--accepting rule at line 89 ("10")
--accepting rule at line 78 (";")
--accepting rule at line 86 ("
")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 51 ("print")
--accepting rule at line 74 ("(")
--accepting rule at line 87 (""x is 1"")
--accepting rule at line 75 (")")
--accepting rule at line 78 (";")
--accepting rule at line 86 ("
")
--accepting rule at line 77 ("}")
--accepting rule at line 53 ("else")
--accepting rule at line 76 ("{")
--accepting rule at line 86 ("
")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 51 ("print")
--accepting rule at line 74 ("(")
--accepting rule at line 87 (""x is neither 1 nor 2"")
--accepting rule at line 75 (")")
--accepting rule at line 78 (";")
--accepting rule at line 86 ("
")
--accepting rule at line 77 ("}")
--accepting rule at line 86 ("
")
--accepting rule at line 86 ("
")
--accepting rule at line 86 ("
")
--accepting rule at line 55 ("for")
--accepting rule at line 74 ("(")
--accepting rule at line 88 ("i")
--accepting rule at line 86 (" ")
--accepting rule at line 60 ("=")
--accepting rule at line 86 (" ")
--accepting rule at line 89 ("0")
--accepting rule at line 78 (";")
--accepting rule at line 86 (" ")
--accepting rule at line 88 ("i")
--accepting rule at line 86 (" ")
--accepting rule at line 65 ("<")
--accepting rule at line 86 (" ")
--accepting rule at line 89 ("10")
--accepting rule at line 78 (";")
--accepting rule at line 86 (" ")
--accepting rule at line 88 ("i")
--accepting rule at line 60 ("=")
--accepting rule at line 88 ("i")
--accepting rule at line 67 ("+")
--accepting rule at line 89 ("1")
--accepting rule at line 78 (";")
--accepting rule at line 75 (")")
--accepting rule at line 76 ("{")
--accepting rule at line 86 ("
")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 86 (" ")
--accepting rule at line 51 ("print")
--accepting rule at line 74 ("(")
--accepting rule at line 88 ("i")
--accepting rule at line 75 (")")
--accepting rule at line 78 (";")
--accepting rule at line 86 ("
")
--accepting rule at line 77 ("}")
--(end of buffer or a NUL)
--EOF (start condition 0)
Parsing successful!
```

## Language Grammar

```
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
```

## Syntax Examples

### Assignment

```
x = 1;
```

### Print

```
print("Hello World!");
```

### If

```
if (x == 1) {
    print("x is 1");
}else {
    print("x is neither 1 nor 2");
}
```

### While

```
while (x < 10) {
    print(x);
    x = x + 1;
}
```

### For

```
for (i = 0; i < 10; i = i + 1;) {
    print(i);
}
```

### Do

```
do {
    print(i);
    i = i + 1;
} while (i < 10);
```

### Break

```
while (x < 10) {
    print(x);
    x = x + 1;
    if (x == 5) {
        break;
    }
}
```

### Continue

```
while (x < 10) {
    print(x);
    x = x + 1;
    if (x == 5) {
        continue;
    }
}
```

### Return

```
function foo(a) {
    return 1;
}
```
