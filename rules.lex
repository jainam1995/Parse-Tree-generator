%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "y.tab.h"
	int lnumber=1;
	void countline();
	
%}
%option noyywrap
%s HASH



bcomments	"/*"((("*"[^/])?)|[^*])*"*/"
lcomments		"//".*

string			\"([^\"]|\\.)*\"

preprocessing			("#include"[ \t]+.*)|("#define"[ \t]+.*)
letter 	[a-zA-Z]
digit [0-9]
characters			\'([^\']|\\.)?\'
whitespace [ \t\v\f]
digits {digit}+
number {digits}("."{digits})?(E("+"|"-")?{digits})?

notallowed {`~\#$_?@':}

datatypes ("double"|"char"|"const"|"auto"|"float"|"signed"|"int"|"long"|"short"|"unsigned"|"static"|"bool")

identifier {letter}({letter}|{digit})*

%%


"do"									{return DO;}
"for"									{return FOR;}
"if"									{return IF;}
"continue"								{return CONTINUE;}
"break"									{return BREAK;}
"else"									{return ELSE;}
"while"									{return WHILE;}
"return"								{return RETURN;}
"read"									{return READ;}
"write"									{return WRITE;}
{lcomments} 							{}
{bcomments}  						{}
{preprocessing}								{}
{string}			 					{return STRING;}
{characters}			 					{return CHARACTER;}
{datatypes}									{;return DATATYPE;}
{digits}								{return INTEGER;}
{number}								{return FLOATING_POINT;}
{identifier}									{return IDENTIFIER;}
"+="									{return(ADDEQUALS); }
"-="									{return(SUBEQUALS); }
"*="									{return(MULEQUALS); }
"/="									{return(DIVEQUALS); }
"%="									{return(MODEQUALS); }
"&&"									{return(ANDOPERATOR); }
"||"									{return(OROPERATOR); }
"<="									{return(LEOPERATOR); }
"|="									{return(OREQUALS); }
">>"									{return(RIGHTOPERATOR); }
"<<"									{return(LEFTOPERATOR); }
"++"									{return(INCOPERATOR); }
"&="									{return(ANDEQUALS); }
"^="									{return(XOREQUALS); }
"--"									{return(DECOPERATOR); }
"->"									{return(PTROPERATOR); }

">="									{return(GEOPERATOR); }
"=="									{return(EQOPERATOR); }
"!="									{return(NEOPERATOR); }
";"										{return(';'); }
("{"|"<%")								{return('{'); }
("}"|"%>")								{return('}'); }
","										{return(','); }
":"										{return(':'); }
"="										{return('='); }
"("										{return('('); }
")"										{return(')'); }
("["|"<:")								{return('['); }

"."										{return('.'); }
"<"										{return('<'); }
">"										{return('>'); }
"&"										{return('&'); }
"!"										{return('!'); }
("]"|":>")								{return(']'); }
"~"										{return('~'); }
"-"										{return('-'); }
"+"										{return('+'); }
"*"										{return('*'); }
"/"										{return('/'); }
"%"										{return('%'); }

"^"										{return('^'); }
"|"										{return('|'); }
"?"										{return('?'); }
\n										{lnumber++;}
{whitespace}									{}
.										{}





%%

void countline()
{
	int i;
	for(i=0; i<yyleng; i++)
	{
		if(*(yytext+i)=='\n') lnumber++;
	}
}
