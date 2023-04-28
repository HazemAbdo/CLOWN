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

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
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
    NILL = 299,
    UMINUS = 300
  };
#endif
/* Tokens.  */
#define IDENTIFIER 258
#define STRING 259
#define INTEGER 260
#define PRINT 261
#define IF 262
#define ELSE 263
#define WHILE 264
#define FOR 265
#define DO 266
#define BREAK 267
#define CONTINUE 268
#define RETURN 269
#define ERROR 270
#define ASSIGN 271
#define PLUS 272
#define MINUS 273
#define TIMES 274
#define DIVIDE 275
#define LPAREN 276
#define RPAREN 277
#define SEMICOLON 278
#define EQUAL 279
#define NOTEQUAL 280
#define GREATER 281
#define GREATEREQUAL 282
#define LESS 283
#define LESSEQUAL 284
#define COMMA 285
#define LBRACE 286
#define RBRACE 287
#define FUNCTION 288
#define CONST 289
#define OR 290
#define AND 291
#define NOT 292
#define SWITCH 293
#define CASE 294
#define COLON 295
#define DEFAULT 296
#define ELIF 297
#define ENUM 298
#define NILL 299
#define UMINUS 300

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{

    int ival;
    char *sval;


};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
