%{

#include "parser.hpp"

extern "C" {

    int yylex(void);
    int yyparse(void);
    int yylex(void);
}

%}

%%

.* { ; }

%%
