%option noyywrap

%{
%}

%x comment
%x include

%%

[ \t\r\n]+   { /* Skip empty lines and lines with only whitespace */ }
.{132,}   { printf("Warning: More than 132 characters in one line!\n"); }

"%"     {printf("Begin comment\n"); BEGIN(comment);}
<comment>.* { printf("End comment...\n\n"); BEGIN(INITIAL); }

"\\include"         {printf("Begin include\n"); BEGIN(include);}

<include>"{"    {  }

<include>[^ \t\n{}]+ {    /* got the include file name */
    printf("File: %s\n", yytext);

    yyin = fopen( yytext, "r" );

    if(!yyin)
    {
        perror("File not found!");
        return 0;
    }

    yypush_buffer_state(yy_create_buffer( yyin, YY_BUF_SIZE ));
    BEGIN(INITIAL);
 }

 <include>"}" {
    printf("End include\n");
    BEGIN(INITIAL);
 }

<<EOF>> {
    yypop_buffer_state();
    if ( !YY_CURRENT_BUFFER )
    {
        yyterminate();
    }

    printf("\n");
    BEGIN(include);
 }

%%

int main()
{
    //Open input file
    FILE *fp;
    fp = fopen("p.tex", "r");

    yyin = fp;
    yylex();

    return 0;
}
