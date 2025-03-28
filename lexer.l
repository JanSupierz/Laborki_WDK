%option noyywrap

%{
%}

%s comment
%x include

%%
"%"              {printf("Begin comment\n"); BEGIN(comment);}

<comment>.*\n   { 
    printf("Found a comment: %s \n", yytext); 
    BEGIN(INITIAL); 
}

[a-z]+              {printf("Found a word: %s \n", yytext);}
"\\include"         {printf("Begin include\n"); BEGIN(include);}

<include>[^ \t\n\{}]+ {    /* got the include file name */
    printf("Nazwa: %s\n", yytext);

    //yyin = fopen( yytext, "r" );

    //if(!yyin)
    //{
    //    perror("Coś poszło nie tak");
    //    return 0;
    //}

    //yypush_buffer_state(yy_create_buffer( yyin, YY_BUF_SIZE ));
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
