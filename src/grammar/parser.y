%{

extern "C" {

    int yyparse(void);

    int yylex(void);

    int yywrap(void) {
        return 1;
    }

    void yyerror(char* error) {
    }

}

%}

%union {

}

%%

start : {  }

%%
