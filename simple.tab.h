/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_SIMPLE_TAB_H_INCLUDED
# define YY_YY_SIMPLE_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TYPE_STRING = 258,
    TYPE_INT = 259,
    TYPE_FLOAT = 260,
    TYPE_BOOL = 261,
    TYPE_VOID = 262,
    INTEGER = 263,
    FLOAT = 264,
    TRUE = 265,
    FALSE = 266,
    STRING = 267,
    IDENTIFIER = 268,
    EQUAL = 269,
    NOTEQUAL = 270,
    GREATER = 271,
    GREATEREQUAL = 272,
    LESS = 273,
    LESSEQUAL = 274,
    COMMA = 275,
    ASSIGN = 276,
    OR = 277,
    AND = 278,
    NOT = 279,
    PLUS = 280,
    MINUS = 281,
    TIMES = 282,
    DIVIDE = 283,
    POWER = 284,
    MOD = 285,
    UMINUS = 286,
    NILL = 287,
    PRINT = 288,
    IF = 289,
    ELSE = 290,
    WHILE = 291,
    FOR = 292,
    DO = 293,
    BREAK = 294,
    CONTINUE = 295,
    RETURN = 296,
    ERROR = 297,
    SWITCH = 298,
    CASE = 299,
    COLON = 300,
    DEFAULT = 301,
    ELIF = 302,
    ENUM = 303,
    FUNCTION = 304,
    CONST = 305,
    SEMICOLON = 306,
    LPAREN = 307,
    RPAREN = 308,
    LBRACE = 309,
    RBRACE = 310
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{

    char*string_value;


};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SIMPLE_TAB_H_INCLUDED  */
