%{
#include <stdio.h>
// Define the token codes as integer constants
 enum yytokentype
  {
    IDENTIFIER = 258,
    STRING = 259,
    INTEGER = 260,
    FLOAT = 261,
    TRUE = 262,
    FALSE = 263,
    PRINT = 264,
    IF = 265,
    ELSE = 266,
    WHILE = 267,
    FOR = 268,
    DO = 269,
    BREAK = 270,
    CONTINUE = 271,
    RETURN = 272,
    ERROR = 273,
    ASSIGN = 274,
    PLUS = 275,
    MINUS = 276,
    TIMES = 277,
    DIVIDE = 278,
    LPAREN = 279,
    RPAREN = 280,
    SEMICOLON = 281,
    EQUAL = 282,
    NOTEQUAL = 283,
    GREATER = 284,
    GREATEREQUAL = 285,
    LESS = 286,
    LESSEQUAL = 287,
    COMMA = 288,
    LBRACE = 289,
    RBRACE = 290,
    FUNCTION = 291,
    CONST = 292,
    OR = 293,
    AND = 294,
    NOT = 295,
    SWITCH = 296,
    CASE = 297,
    COLON = 298,
    DEFAULT = 299,
    ELIF = 300,
    ENUM = 301,
    NILL = 302,
    POWER = 303,
    MOD = 304,
    UMINUS = 305
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
"^"         { return POWER; }
"%"        { return MOD; }
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
"true"     {return TRUE;}
"false"    {return FALSE;}
":"         {return COLON;}
","         { return COMMA; }
[ \t\n]     ; /* ignore whitespace */
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/] ; /* ignore comments */
\"[^"]*\"   { return STRING; }
[a-zA-Z][a-zA-Z0-9]* { return IDENTIFIER; }
[0-9]*\.[0-9]+ { return FLOAT; }
[0-9]+      { return INTEGER; }
.           { return ERROR; }
%%

