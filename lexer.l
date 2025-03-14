/*** Definition Section has one variable
which can be accessed inside yylex() 
and main() ***/
%{
int count = 0;
%}

DIGIT [0-9]

/*** Rule Section has three rules, first rule 
matches with capital letters, second rule
matches with any character except newline and 
third rule does not take input after the enter***/
%%
"int" 			{printf("Type integer\n");}
[a-zA-Z]+{DIGIT}+? {printf("Variable name: %s\n", yytext);}
"="				{printf("Equals sign\n");}
[0-9]+			{printf("Variable value: %s\n", yytext);}
"+"				{printf("Plus sign\n");}
";"				ECHO;
%%

/*** Code Section prints the number of
capital letter present in the given input***/
int yywrap(){}
int main(){

// Explanation:
// yywrap() - wraps the above rule section
/* yyin - takes the file pointer 
		which contains the input*/
/* yylex() - this is the main flex function
		which runs the Rule Section*/
// yytext is the text in the buffer

// Uncomment the lines below 
// to take input from file
// FILE *fp;
// char filename[50];
// printf("Enter the filename: \n");
// scanf("%s",filename);
// fp = fopen(filename,"r");
// yyin = fp;

yylex();
printf("\nNumber of Capital letters "
	"in the given input - %d\n", count);

return 0;
}
