LEXER_INPUT ?= clown.l
PARSER_INPUT ?= clown.y
LEXER_OUTPUT ?= lex
PARSER_OUTPUT ?= parser
BIN_OUTPUT ?= clown

INPUT_FILE ?= inputs/code.clown

all: lex parse build

parse: src/$(PARSER_INPUT)
	bison -l -d -v src/$(PARSER_INPUT) -b build/$(PARSER_OUTPUT)

lex: src/$(LEXER_INPUT)
	flex -l -obuild/$(LEXER_OUTPUT).yy.c src/$(LEXER_INPUT)

build: build/$(LEXER_OUTPUT).yy.c build/$(PARSER_OUTPUT).tab.c
	gcc -o parser -DYYDEBUG build/$(PARSER_OUTPUT).tab.c build/$(LEXER_OUTPUT).yy.c -I./src -lfl -o build/$(BIN_OUTPUT)

run: build $(INPUT_FILE)
	build/$(BIN_OUTPUT) < $(INPUT_FILE)

clean:
	rm -rf build/$(LEXER_OUTPUT).yy.c build/$(PARSER_OUTPUT).tab.* build/$(PARSER_OUTPUT).output $(BIN_OUTPUT)