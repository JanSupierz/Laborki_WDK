%option noyywrap

%{
    int counter = 0;
    int specialCounter = 0;
    int sum = 0;  // Sum of numbers in .itc files
    int inITC = 0; // Flag to check if we're in an .itc file
%}

%x comment
%x include
%s itc
%x word

%%

[ \t\r]+    { /* Skip empty lines and whitespace */ }
.{132,}\n       { printf("Warning: More than 132 characters in one line!\n"); }

"%"             { printf("Begin comment\n"); BEGIN(comment); }
<comment>.*\n   { printf("End comment...\n"); BEGIN(inITC == 1? itc : INITIAL); }

"\\include"     { printf("Begin include\n"); BEGIN(include); }
<include>"{"    { }

<include>[^ \t\n{}]+ {    
    printf("File: %s\n", yytext);
    ++counter;

    /* Determine the file extension */
    char *ext = strrchr(yytext, '.');
    if (ext != NULL) {
        printf("Extension: %s\n", ext);
        if (strcmp(ext, ".itc") == 0) {
            ++specialCounter;
            inITC = 1; // Set flag for .itc file
            sum = 0;   // Reset sum for new .itc file
        }
    }

    yyin = fopen(yytext, "r");
    if (!yyin) {
        perror("File not found!");
        return 0;
    }

    yypush_buffer_state(yy_create_buffer(yyin, YY_BUF_SIZE));

    //Switch based on the flag
    BEGIN(inITC == 1? itc : INITIAL);
}

<include>"}" {
    printf("End include\n");
    BEGIN(INITIAL);
}

<itc>[0-9]+ { /* Handle numbers inside .itc files */
    printf("Number: %s\n", yytext);
    sum += atoi(yytext);
}

<<EOF>> {  /* Handle end of .itc files */

    if(inITC == 1)
    {
        printf("Sum of numbers in .itc file: %d\n", sum);
        inITC = 0;
    }

    yypop_buffer_state();
    if (!YY_CURRENT_BUFFER) {
        yyterminate();
    }

    BEGIN(include);
}

.           { ECHO; BEGIN(word); }
<word>.\n   { ECHO; BEGIN(inITC == 1? itc : INITIAL); }

\n      { }
%%

int main() {
    // Open input file
    FILE *fp;
    fp = fopen("p.tex", "r");

    if (!fp) {
        perror("Cannot open input file!");
        return 1;
    }

    yyin = fp;
    yylex();

    printf("Opened %d files, including %d special ones.\n", counter, specialCounter);

    return 0;
}
