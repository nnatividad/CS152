parser: miniL.lex
	bison -v -d --file-prefix=y miniL.y
	flex miniL.lex
	g++ -o my_compiler -x c++ y.tab.c lex.yy.c -lfl

clean:
	rm -f lex.yy.c y.tab.* y.output *.o my_compiler *.mil