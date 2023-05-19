%{
#include <stdio.h>
#include "parser.tab.h"
%}

%option noyywrap

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
[a-zA-Z][a-zA-Z0-9]* { 
  yylval.sval = strdup(yytext);
  return IDENTIFIER; 
}
[0-9]*\.[0-9]+ { return FLOAT; }
[0-9]+      { return INTEGER; }
.           { return ERROR; }
%%

