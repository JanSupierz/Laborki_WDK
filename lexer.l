%option noyywrap

%{
%}

%x include
%s too_many_chars

%%

\include         BEGIN(include);
[a-z]+          ECHO;
[^a-z\n]*\n?    ECHO;

<include>[ \t]*     /* eat the whitespace */
<include>[^ \t\n]+ {    /* got the include file name */
    printf("Nazwa: %s: ", yytext);
    return 0;

    yyin = fopen( yytext, "r" );

    if(!yyin)
    {
        perror("Coś poszło nie tak");
        return 0;
    }

    yypush_buffer_state(yy_create_buffer( yyin, YY_BUF_SIZE ));
    BEGIN(INITIAL);
 }

<<EOF>> {
    yypop_buffer_state();
    if ( !YY_CURRENT_BUFFER )
    {
        yyterminate();
    }
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
