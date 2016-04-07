%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include "iostream"
	#include <vector>
	#include <string>
	#include "sstream"
	#include <map>
	#include <vector>
	#include <string.h>
	int yylex(void);
	void yyerror (char const *s) {
   		fprintf (stderr, "%s\n", s);
 	}
 	using namespace std;
 	extern int	yylex();
 	extern int lnumber;
 	extern char* yytext;
 	extern int yyleng;
 	struct element
 	{
 		string code;
 		vector<element*> v;
 		string id;
 		string typeofdata;
 		
 	};
 	element* root;
 	union deftype
	{
		element* node;
		char* s;
	};
	#define YYSTYPE deftype
 	
%}
%token ADDEQUALS MULEQUALS DIVEQUALS MODEQUALS ANDEQUALS XOREQUALS OREQUALS ANDOPERATOR OROPERATOR 
%token RIGHTOPERATOR LEFTOPERATOR INCOPERATOR DECOPERATOR PTROPERATOR  LEOPERATOR GEOPERATOR EQOPERATOR 
%token IDENTIFIER DATATYPE NEOPERATOR FLOATING_POINT 
%token IF ELSE WHILE FOR DO BREAK 
%token CONTINUE RETURN SUBEQUALS  INTEGER 
%token CHARACTER STRING READ WRITE
 
%%
startstart:				startstatement		{
												root = $1.node;
												root->code = "startstart";
											}

startstatement:  					/*no_production*/		{
																element* temp = new element;
																temp->code="epsilon";
																$$.node = temp;
													}
						|startofdeclaration startstatement {
																element* temp = new element;
																temp->code = "startstatement";
																(temp->v).push_back($1.node);
																(temp->v).push_back($2.node);
																$$.node = temp;
															}
						;
startofdeclaration: 	definationoffunction 				{
																element* temp = new element;
																temp->code = "startofdeclaration";
																(temp->v).push_back($1.node);
																$$.node = temp;
															}
						| declaration					{
																element* temp = new element;
																temp->code = "startofdeclaration";
																(temp->v).push_back($1.node);
																$$.node = temp;	
															}
						;

listofdeclaration: 		declaration 						{
																element* temp = new element;
																temp->code = "listofdeclaration";
																(temp->v).push_back($1.node);
																$$.node = temp;
															}
						| declaration listofdeclaration		{
																element* temp = new element;
																temp->code = "listofdeclaration";
																(temp->v).push_back($1.node);
																(temp->v).push_back($2.node);
																$$.node = temp;
															}
						;

declaration: 			datatype id semicolon                {
																element* temp = new element;
																temp->code = "declaration";
																(temp->v).push_back($1.node);
																(temp->v).push_back($2.node);
																$$.node = temp;
															}	
						;		
definationoffunction:	datatype id leftparenthesis listofarguments rightparenthesis compoundstatements {
																element* temp = new element;
																temp->code = "definationoffunction";
																(temp->v).push_back($1.node);
																(temp->v).push_back($2.node);
																(temp->v).push_back($4.node);
																(temp->v).push_back($6.node);
																$$.node = temp;
															}
						;




compoundstatements:			leftbrace rightbrace 			{
																element* temp = new element;
																temp->code = "compoundstatement";
																$$.node = temp;
																
															}
						| leftbrace listofstatements rightbrace{
													element* temp = new element;
													temp->code = "compoundsatement";
													(temp->v).push_back($2.node);
													$$.node = temp;
														
															}
						;						
listofstatements:				/*no_production*/					{
															element* temp = new element;
															temp->code="epsilon";
															$$.node = temp;	
															}
						|statement listofstatements			{
													element* temp = new element;
													temp->code = "listofstatements";
													(temp->v).push_back($1.node);
													(temp->v).push_back($2.node);
													$$.node = temp;	
												}
						;	
statement:				readstatement     {
													element* temp = new element;
													temp->code = "statement";
													(temp->v).push_back($1.node);
													$$.node = temp;
	

											}
						| writestatement{
													element* temp = new element;
													temp->code = "statement";
													(temp->v).push_back($1.node);
													$$.node = temp;




										}	
						| listofdeclaration {
													element* temp = new element;
													temp->code = "statement";
													(temp->v).push_back($1.node);
													$$.node = temp;
												}
						| compoundstatements	{
													element* temp = new element;
													temp->code = "statement";
													(temp->v).push_back($1.node);
													$$.node = temp;
												}
						| conditionalstatement	{
													element* temp = new element;
													temp->code = "statement";
													(temp->v).push_back($1.node);
													$$.node = temp;
												}
						| iterationstatement	{
													element* temp = new element;
													temp->code = "statement";
													(temp->v).push_back($1.node);
													$$.node = temp;
												}
						| the_expression semicolon {
													element* temp = new element;
													temp->code = "statement";
													(temp->v).push_back($1.node);
													$$.node = temp;
												}
						;					

readstatement :   READ id semicolon{element* temp = new element;
													temp->code = "readstatement";
													(temp->v).push_back($2.node);
													$$.node = temp;}
					|error  {printf(" Wrong read syntax at line  %d\n",lnumber);}
					;
writestatement :   WRITE id semicolon{element* temp = new element;
													temp->code = "writestatement";
													(temp->v).push_back($2.node);
													$$.node = temp;}
					|error  {printf(" Wrong write syntax at line  %d\n",lnumber);}
					;
iterationstatement:			WHILE leftparenthesis the_expression rightparenthesis statement {
													element* temp = new element;
													temp->code = "whilestatement";
													(temp->v).push_back($3.node);
													(temp->v).push_back($5.node);
													$$.node = temp;								
												}
						
						| FOR leftparenthesis the_expression semicolon the_expression semicolon the_expression rightparenthesis statement {
													element* temp = new element;
													temp->code = "forstatement";
													(temp->v).push_back($3.node);
													(temp->v).push_back($5.node);
													(temp->v).push_back($7.node);
													(temp->v).push_back($9.node);
													$$.node = temp;								
												}
						;

conditionalstatement:		IF leftparenthesis the_expression rightparenthesis statement {
													element* temp = new element;
													temp->code = "ifstatement";
													(temp->v).push_back($3.node);
													(temp->v).push_back($5.node);
													$$.node = temp;								
												}
						| IF leftparenthesis the_expression rightparenthesis statement ELSE statement {
													element* temp = new element;
													temp->code = "ifthenelsestatement";
													(temp->v).push_back($3.node);
													(temp->v).push_back($5.node);
													(temp->v).push_back($7.node);
													$$.node = temp;								
												}
						;						
the_expression:			number {
													$$.node = $1.node;
												}
						| id {
													$$.node = $1.node;
												}
						| number operator the_expression {
													element* temp = new element;
													if($2.s == NULL)
														temp->code = "" ;
													else{
														temp->code = string($2.s);
													}
													(temp->v).push_back($1.node);
													(temp->v).push_back($3.node);
													
													$$.node = temp;
												}
						| id operator the_expression {
													element* temp = new element;
													if($2.s == NULL)
														temp->code = "" ;
													else{
														temp->code = string($2.s);
													}
													(temp->v).push_back($1.node);
													(temp->v).push_back($3.node);
													$$.node = temp;
												}
						| id leftparenthesis listofparameters rightparenthesis {
													element* temp = new element;
													temp->code = "calltofunction";
													if($1.s == NULL)
														temp->code = "" ;
													else{
														temp->id = string($1.s);
													}
													$$.node = temp;
												}
						;
listofparameters:				/* no_production */   {
															element* temp = new element;
															temp->code="epsilon";
															$$.node = temp;	
															}
						| id  {$$.node=$1.node;}
						| id comma listofparameters {
													element* temp = new element;
													temp->code="parameters";
													(temp->v).push_back($1.node);
													(temp->v).push_back($3.node);
													$$.node = temp;
												}
						;	
listofarguments:				/* no_production */  {
															element* temp = new element;
															temp->code="epsilon";
															$$.node = temp;	
															}
						| datatype id {
																element* temp = new element;
																temp->code = "arguments";
																(temp->v).push_back($1.node);
																(temp->v).push_back($2.node);
																$$.node = temp;
															}	
						| datatype id comma listofarguments{
																element* temp = new element;
																temp->code = "arguments";
																(temp->v).push_back($1.node);
																(temp->v).push_back($2.node);
																(temp->v).push_back($4.node);
																$$.node = temp;
															}
						;

operator: 				assignmentOPERATOR {$$.s = $1.s;}
						| relationalOPERATOR {$$.s = $1.s;}
						| logicalOPERATOR {$$.s = $1.s;}
						| binaryOPERATOR {$$.s = $1.s;}
						| error			{printf(" operator at line  %d\n",lnumber);}			

						;				
assignmentOPERATOR:		 	'=' {$$.s = strdup("=");}
						| MULEQUALS {$$.s = strdup("*=");}
						| EQOPERATOR {$$.s = strdup("==");}
						| DIVEQUALS {$$.s = strdup("/=");}
						| MODEQUALS {$$.s = strdup("%=");}
						| ADDEQUALS {$$.s = strdup("+=");}
						| SUBEQUALS {$$.s = strdup("-=");}
						| ANDEQUALS {$$.s = strdup("&=");}
						| XOREQUALS {$$.s = strdup("^=");}
						| OREQUALS {$$.s = strdup("|=");}
						;
binaryOPERATOR:				'+' {$$.s = strdup("+");}
						| '-' {$$.s = strdup("-");}
						| '*' {$$.s = strdup("*");}
						| '/' {$$.s = strdup("/");}
						| '%' {$$.s = strdup("%");}
						;
relationalOPERATOR:			'<' {$$.s = strdup("<");}
						| '>' {$$.s = strdup(">");}
						| LEOPERATOR {$$.s = strdup("<=");}
						| GEOPERATOR {$$.s = strdup(">=");}
						;
logicalOPERATOR:				'!' {$$.s = strdup("!");}
						| ANDOPERATOR {$$.s = strdup("&&");}
						| OROPERATOR {$$.s = strdup("||");}
						;

semicolon:					';'
						| error		{printf(" Semicolon is missing at line  %d\n",lnumber);}
						;
datatype:				DATATYPE {
										element* temp = new element;
										temp->code = string(yytext,yyleng);
										temp->id = string(yytext,yyleng);	
										$$.node = temp;
									}
						| error		{printf(" Data type missing at line  %d\n",lnumber);}
						;
id:						IDENTIFIER{
										element* temp = new element;
										temp->code = string(yytext,yyleng);
										temp->id = string(yytext,yyleng);
										$$.node = temp;
									}
						| error		{printf(" Identifier missing at line  %d\n",lnumber);}
						;
integer:				INTEGER    {
										element* temp = new element;
										temp->code = string(yytext,yyleng);
										temp->typeofdata = "int";
										temp->id = string(yytext,yyleng);
										$$.node = temp;
									}
						| error     {printf(" Integer missing at line  %d\n",lnumber);}
						;
number:					INTEGER    {
										element* temp = new element;
										temp->code =  string(yytext,yyleng);										temp->typeofdata = string(yytext,yyleng);
										temp->id = string(yytext,yyleng);
										$$.node = temp;
									}
						| FLOATING_POINT  {
										element* temp = new element;
										temp->code = "float";
										temp->typeofdata = "float";
										temp->id = string(yytext,yyleng);
										$$.node = temp;
									}
						| error		{printf(" Number missing at line  %d\n",lnumber);}
						;
leftparenthesis:		'('
						| error 	{printf(" ( missing at line  %d\n",lnumber);}
						;
rightparenthesis:		')'
						| error 	{printf(" ) missing at line  %d\n",lnumber);}
						;
leftbrace:				'{'
						| error 	{printf(" { missing at line  %d\n",lnumber);}
						;
rightbrace:			'}'
						| error 	{printf(" } missing at line  %d\n",lnumber);}
						;
leftbracket:			'['
						| error 	{printf(" [ missing at line  %d\n",lnumber);}
						;
rightbracket:			']'
						| error 	{printf(" ] missing at line  %d\n",lnumber);}
						;
comma:					','
						| error 	{printf(" , missing at line  %d\n",lnumber);}
						;
%%
void spaceforabstractsyntaxtree(int n)
{
	for(int i=0;i<n;i++) cout<<". . ";
}
void abstractsyntaxtree(element *n,int count)
{
	spaceforabstractsyntaxtree(count);
	if(n==NULL){
		cout<<"NULL";
		return;
	}
	cout <<n->code<<endl;
	for (int i = 0; i < (n->v).size(); ++i)
	{
		abstractsyntaxtree((n->v)[i],count+1);
	}
}
int main(){
	
	yyparse();
	abstractsyntaxtree(root,0);
	//cout<<root->code;
	return 0 ;
}
