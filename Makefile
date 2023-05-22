LEXER_INPUT ?= simple.lex
PARSER_INPUT ?= simple.y
LEXER_OUTPUT ?= lex
PARSER_OUTPUT ?= parser
BIN_OUTPUT ?= clown

INPUT_FILE ?= code.clown

all: lex parse build

parse: $(PARSER_INPUT)
	bison -l $(PARSER_INPUT) -b build/$(PARSER_OUTPUT)

lex: $(LEXER_INPUT)
	flex -l  -obuild/$(LEXER_OUTPUT).yy.c $(LEXER_INPUT)

build: build/$(LEXER_OUTPUT).yy.c build/$(PARSER_OUTPUT).tab.c
	gcc -o parser -DYYDEBUG build/$(PARSER_OUTPUT).tab.c build/$(LEXER_OUTPUT).yy.c -I. -lfl -o build/$(BIN_OUTPUT)

run: build $(INPUT_FILE)
	build/$(BIN_OUTPUT) < $(INPUT_FILE)

clean:
	rm -rf build/$(LEXER_OUTPUT).yy.c build/$(PARSER_OUTPUT).tab.* build/$(PARSER_OUTPUT).output $(BIN_OUTPUT)