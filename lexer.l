%option noyywrap

%{
%}

NUMBER [0-9]+

TYPE 			(float)|(string)|(bool)|(int)
VARIABLE 		[a-zA-Z]+[0-9]?
ARITHMETIC_OPERATOR 	[\+\-\*/]
RELATIONAL_OPERATOR 	[=<>(<=)(=>)]
SEMICOLON 		;
SPACES			" "+
OTHER 			.
VALUE 				({NUMBER}f)|({NUMBER}\.{NUMBER}f)|(\.{NUMBER}f)|{NUMBER}|(true)|(false)|(\"[a-zA-Z0-9]+\")

%%
{TYPE} 				{printf("Type: %s\n", yytext);}
{VARIABLE} 			{printf("Variable name: %s\n", yytext);}
{ARITHMETIC_OPERATOR} 	{printf("Arithmetic operator: %s\n", yytext);}
{RELATIONAL_OPERATOR} 	{printf("Relational operator: %s\n", yytext);}
{SEMICOLON} 			{printf("Semicolon: %s\n", yytext);}
{VALUE} 				{printf("Value: %s\n", yytext);}
{SPACES}			{}
{OTHER} 			{printf("NOT RECOGNIZED: %s\n", yytext);}
%%

int main()
{
    //Open input file
    FILE *fp;
    fp = fopen("text.txt", "r");

    yyin = fp;
    yylex();

    return 0;
}
