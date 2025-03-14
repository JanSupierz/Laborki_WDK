

.PHONY: clean

__start__: compiler
	./compiler

compiler: lex.yy.c  
	gcc lex.yy.c -o compiler

lex.yy.c: lexer.l 
	flex lexer.l 
	
 
clean :
	rm *.c compiler  
	
