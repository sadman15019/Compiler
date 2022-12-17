%{
    #include "declare-assign.tab.h"
    #include <stdlib.h>
    void yyerror(char *);
%}

%%
[i][m][p][o][r][t][ \t]*[a-zA-Z]+[;]     {}
"integer"   {return INT ;}
"fraction" {return FLOAT; }
"character" {return CHAR;}
"display" {return PRINT;}
"<-"     {return ASSIGN;}
"$add"        {return ADD;} 
"$sub"        {return SUB;} 
"$mul"        {return MUL;} 
"$div"        {return DIV;} 
"mod"        {return MOD;} 
"and"        {return AND;}
"or"         {return OR;}
"**"         {return POW;} 
">?="        {return GTE;} 
"<?="        {return LTE;} 
"equal"      {return EQ;} 
">?"         {return GT;} 
"<?"         {return LT;} 
"scan"      {return SCAN;}
"cholok"    {return VAR;}
"fixed"     {return CONSTANT;}
"si"         {return IF;}
"sinon si"   {return ELSEIF;}
"sinon"    {return ELSE;}
"check"    {return SWITCH;}
"incase"    {return CASE;}
"others"    {return DEFAULT;}
"loop"      {return FOR;}
"in"         {return IN;} 
"as_long_as"  {return WHILE;} 
"["           {return *yytext;}
"]"           {return *yytext;}
"func"        {return FUNC;}
"->"         {return FUNCRET;}
"range"      {return RET;}
"void"        {return VOID;}
"absolute"   {return ABS;}
"max"         {return MAX;}
"min"         {return MIN;}
[#][#].*[\n]       {}
[a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*     {
                yylval.stringval=strdup(yytext); //cause yylval is overwritten when parser generates next token,we need to copy value instead of using yylval 
                return ID;
            }

[-]?[0-9][0-9]*[.]?[0-9]*    {
                yylval.floatval = atof(yytext);
                return NUMBER;
            }

[,;.(){}:"]        {return *yytext;}

[ \t]   ;       /* skip whitespace */
[\n]   {}
.               yyerror("Unknown character");

%%

int yywrap(void) {
    return 1;
}


