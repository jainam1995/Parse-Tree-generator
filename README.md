# Parse-Tree-generator
This program generates a parse tree for a program. The language used is a subset of c.  
Type the following in terminal :  
`lex rules.lex`  
`yacc -d parserast.y`  
`c++ lex.yy.c y.tab.c`  
`./a.out < test.c`
