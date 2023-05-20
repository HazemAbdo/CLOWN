%{
#include <stdio.h>
#include "simple.tab.h"
%}

%%

"int"         {yylval.string_value="int";  return TYPE_INT; }
"float"       { yylval.string_value="float";  return TYPE_FLOAT; }
"string"      { yylval.string_value="string";  return TYPE_STRING; }
"bool"        { yylval.string_value="bool";  return TYPE_BOOL; }
"void"        { yylval.string_value="void";  return TYPE_VOID; }

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
"="         {yylval.string_value="="; return ASSIGN; }
"=="        { yylval.string_value="=="; return EQUAL; }
"!="        { yylval.string_value="!="; return NOTEQUAL; }
">"         { yylval.string_value=">"; return GREATER; }
">="        { yylval.string_value=">="; return GREATEREQUAL; }
"<"         { yylval.string_value="<"; return LESS; }
"<="        { yylval.string_value="<="; return LESSEQUAL; }
"+"         { yylval.string_value="+"; return PLUS; }
"-"         { yylval.string_value="-"; return MINUS; }
"*"         { yylval.string_value="*"; return TIMES; }
"/"         { yylval.string_value="/"; return DIVIDE; }
"^"         { yylval.string_value="^"; return POWER; }
"%"         { yylval.string_value="%"; return MOD; }
"||"        { yylval.string_value="||"; return OR; }
"&&"        { yylval.string_value="&&"; return AND; }
"!"         { yylval.string_value="!"; return NOT; }
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
"NULL"     {yylval.string_value="NULL"; return NILL;}
"true"     {yylval.string_value="true"; return TRUE;}
"false"    {yylval.string_value="false"; return FALSE;}
":"         {return COLON;}
","         { return COMMA; }
[ \t\n]     ; /* ignore whitespace */
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/] ; /* ignore comments */
\"[^"]*\"   { yylval.string_value=strdup(yytext); return STRING; }
[a-zA-Z][a-zA-Z0-9]* { yylval.string_value=strdup(yytext); return IDENTIFIER; }
[0-9]*\.[0-9]+ { yylval.string_value=strdup(yytext); return FLOAT; }
[0-9]+      { yylval.string_value=strdup(yytext); return INTEGER; }
.           { return ERROR; }
%%

