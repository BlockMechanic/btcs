
CFLAGS=-O2

GEN=parser.tab.c parser.tab.h lex.yy.c oplookup.c oplookup.o script.o oplookup.h
FORBIN=script.o parser.tab.c lex.yy.c oplookup.o op.o
DEPS=oplookup.h script.h misc.h Makefile op.h

PREFIX ?= /usr/local
BIN=btcs


all: $(BIN)

oplookup.c oplookup.h: opcodes mph-opcodes
	@./mph-opcodes opcodes

parser.tab.c parser.tab.h:	parser.y
	bison -d parser.y

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

install: $(BIN)
	mkdir -p $(PREFIX)/bin
	cp $(BIN) $(PREFIX)/bin

$(BIN): $(GEN) $(DEPS) $(FORBIN)
	$(CC) $(CFLAGS) -o $@ $(FORBIN)

clean:
	rm -f $(GEN)