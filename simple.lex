%{
#include <stdio.h>

// Define the token codes as integer constants
 enum yytokentype
  {
    IDENTIFIER = 258,
    STRING = 259,
    INTEGER = 260,
    PRINT = 261,
    IF = 262,
    ELSE = 263,
    WHILE = 264,
    FOR = 265,
    DO = 266,
    BREAK = 267,
    CONTINUE = 268,
    RETURN = 269,
    ERROR = 270,
    ASSIGN = 271,
    PLUS = 272,
    MINUS = 273,
    TIMES = 274,
    DIVIDE = 275,
    LPAREN = 276,
    RPAREN = 277,
    SEMICOLON = 278,
    EQUAL = 279,
    NOTEQUAL = 280,
    GREATER = 281,
    GREATEREQUAL = 282,
    LESS = 283,
    LESSEQUAL = 284,
    COMMA = 285,
    LBRACE = 286,
    RBRACE = 287,
    FUNCTION = 288,
    CONST = 289,
    OR = 290,
    AND = 291,
    NOT = 292,
    SWITCH = 293,
    CASE = 294,
    COLON = 295,
    DEFAULT = 296,
    ELIF = 297,
    ENUM = 298,
    NILL  = 299,
    UMINUS = 300
  };
%}

%%
"print"     { return PRINT; }
"if"        { return IF; }
"else"      { return ELSE; }
"elif"      { return ELIF; }
"while"     { return WHILE; }
"for"       { return FOR; }
"do"        { return DO; }
"break"     { return BREAK; }
"continue"  { return CONTINUE; }
"return"    { return RETURN; }
"="         { return ASSIGN; }
"=="        { return EQUAL; }
"!="        { return NOTEQUAL; }
">"         { return GREATER; }
">="        { return GREATEREQUAL; }
"<"         { return LESS; }
"<="        { return LESSEQUAL; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return TIMES; }
"/"         { return DIVIDE; }
"||"        { return OR; }
"&&"        { return AND; }
"!"         { return NOT; }
"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
";"         { return SEMICOLON; }
"function"  { return FUNCTION; }
"const"     {return CONST;}
"switch"    {return SWITCH;}
"case"      {return CASE;}
"default"   {return DEFAULT;}
"enum"     {return ENUM;}
"NULL"     {return NILL;}
":"         {return COLON;}
","         { return COMMA; }
[ \t\n]     ; /* ignore whitespace */
\"[^"]*\"   { return STRING; }
[a-zA-Z][a-zA-Z0-9]* { return IDENTIFIER; }
[0-9]+      { return INTEGER; }
.           { return ERROR; }
%%

