variable [a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*

%{
	/* C files -- headers, declaration, variable */
    
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    int x,i;
	
%}

%%
"cholok"([ \t\n]+)("integer"|"fraction"|"character")([ \t\n]+)[a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*([ \t\n]*)([,][a-zA-Z]+[0-9]*)*[.] {printf("this is a variable\n");}
"fixed"([ \t\n]+)("integer"|"fraction"|"character")([ \t\n]+)[a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*([ \t\n]*)[.] {printf("this is a constant variable\n");}
"func"([ \t\n]+)[a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*([ \t\n]*)[-][>]("integer"|"fraction"|"character"|"blank")"["("integer"|"fraction"|"character")([ \t\n]+)[a-zA-Z]+[0-9]*([,]("integer"|"fraction"|"character")([ \t\n]+)[a-zA-Z]+[0-9]*)*"]"[\n]*[{][\n]*[}]  {printf("this is a function\n");}
"loop"([ \t\n]+)[a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*([ \t\n]+)[i][n]([ \t\n]+)[0-9]*[.][.]([.][.]|[<][?]|[>][?])[0-9]*[{][}]  {printf("this is a for loop\n");}
"as_long_as"[(](([0-9]*)|(([a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*|[0-9]*)([<][?]|[>][?]|[<][?][=]|[>][?][=]|[equal])([a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*|[0-9]*)))(([ \t\n]+)(([a][n][d])|([o][r]))([ \t\n]+)(([0-9]*)|(([a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*|[0-9]*)([<][?]|[>][?]|[<][?][=]|[>][?][=]|[equal])([a-zA-Z]+[0-9]*|[0-9]*))))*[)][{][}]     {printf("this is a while loop\n");}
"si"[(](([0-9]*)|(([a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*|[0-9]*)([<][?]|[>][?]|[<][?][=]|[>][?][=]|[equal])([a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*|[0-9]*)))(([ \t\n]+)(([a][n][d])|([o][r]))([ \t\n]+)(([0-9]*)|(([a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*|[0-9]*)([<][?]|[>][?]|[<][?][=]|[>][?][=]|[equal])([a-zA-Z]+[0-9]*|[0-9]*))))*[)][{][}][\n]*("sinon si"[(](([0-9]*)|(([a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*|[0-9]*)([<][?]|[>][?]|[<][?][=]|[>][?][=]|[equal])([a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*|[0-9]*)))(([ \t\n]+)(([a][n][d])|([o][r]))([ \t\n]+)(([0-9]*)|(([a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*|[0-9]*)([<][?]|[>][?]|[<][?][=]|[>][?][=]|[equal])([a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*|[0-9]*))))*[)][{][}])*[\n]*("sinon"[{][}])*    {printf("this is an if else ladder\n");}
"check"[ \t\n]*[a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*[ \t\n]*[:][\n]*[ \t\n]*("incase"[ \t\n]*[0-9]*[ \t\n]*[:][\n]*[ \t\n]*(.)*[\n]*[ \t\n]*)+[\n]*[ \t\n]*"others"[ \t\n]*[:][\n]*[ \t\n]*(.)* {printf("this is switch case ladder");}
"scan"[(][a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)([,][a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*)*[)][ \t\n]*[.]    {printf("enter a value from user\n");}
"display"[(][a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)([,][a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*)*[)][ \t\n]*[.]    {printf("show the value of variable\n");}
"import"([ \t\n]+)[a-z]*[.][h]  {printf("header file added\n");}
[a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)[ \t\n]*[<][-][ \t\n]*(([a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*))|[0-9]*)[ \t\n]*(("$add"|"$sub"|"$mul"|"$div"|"**")[ \t\n]*(([a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*))|[0-9]*)[ \t\n]*)*[ \t\n]*[.]  {printf("assigning a value with or without arithmetic operation");}
[a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)[ \t\n]*[<][-][ \t\n]*"absolute"[(](([a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*))|[0-9]*)[ \t\n]*(("$add"|"$sub"|"$mul"|"$div"|"**")[ \t\n]*(([a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*))|[0-9]*)[ \t\n]*)*[ \t\n]*[)][ \t\n]*[.]  {printf("result is absolute value of this arithmetic operation");}
[a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)[ \t\n]*("$add$add"|"$sub$sub")[ \t\n]*[.]   {printf("incrementing/decrementing a variable");}
"##".*   {x=strlen(yytext)-3; printf("singleline comment.the comment is:") ; for(i=2;i<=x;i++){ printf("%c",yytext[i]); } }
"#!"(.*|[\n]*)*"!#"  {x=strlen(yytext)-3; printf("multiline comment.the comment is:") ; for(i=2;i<=x;i++){ printf("%c",yytext[i]); } }
"collection"[ \t\n]+[a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*[{][\n]*([ \t\n]*(("cholok"([ \t\n]+)("integer"|"fraction"|"character")[ \t\n]+[a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*([ \t\n]*)([,][a-zA-Z]+[0-9]*)*[.][\n]*)*)|("func"([ \t\n]+)[a-zA-Z]([a-zA-Z]*|[_]*|[0-9]*)*([ \t\n]*)[-][>]("integer"|"fraction"|"character"|"blank")"["("integer"|"fraction"|"character")([ \t\n]+)[a-zA-Z]+[0-9]*([,]("integer"|"fraction"|"character")([ \t\n]+)[a-zA-Z]+[0-9]*)*"]"[\n]*[{][\n]*[}][\n]*))*[\n]*[}]   {printf("declaration of a class");}

"cholok"     {printf("starting of a variable\n");}
"absolute"     {printf("result is an absolute value\n");}
"integer"    {printf("this is integer variable\n");}
"fraction"   {printf("this is float variable\n");}
"character"  {printf("this is char variable\n");}
"blank"      {printf("this is void\n");}
"scan"	     {printf("this is user scan\n");}
"display"    {printf("show output\n");}
"fixed"      {printf("this is constant variable\n");}
"si"	     {printf("conditional statement\n");}
"sinon si"   {printf("else if statement\n");}
"import"     {printf("#include\n");}
"sinon"      {printf("this is else statement\n");}
"func"       {printf("begining of a function\n");}
"range"      {printf("function return\n");}
"getlost"    {printf("break statement\n");}
"goto_first" {printf("continue statement\n");}
"loop"       {printf("for loop\n");}
"as_long_as" {printf("while loop\n");} 
"check"      {printf("switch case\n");} 
"incase"     {printf("case ladder in a switch\n");} 
"others"     {printf("default in switch case\n");} 
","          {printf("comma to seperate variables\n");} 
"$add"        {printf("addition\n");} 
"$sub"        {printf("subtraction\n");} 
"$mul"        {printf("multiplication\n");} 
"$div"        {printf("division\n");} 
"mod"        {printf("modulus\n");} 
"and"        {printf("logical and\n");}
"or"         {printf("logical or\n");}
"**"         {printf("power\n");} 
">?="        {printf("greater than or equal\n");} 
"<?="        {printf("less than or equal\n");} 
"equal"      {printf("equal check\n");} 
">?"         {printf("greater than\n");} 
"<?"         {printf("less than\n");} 
"<-"         {printf("assignment\n");}
"("          {printf("opening paranthesis\n");}
")"          {printf("closing paranthesis\n");}
"{"          {printf("scope starting for loop or condition\n");}
"}"          {printf("scope ending for loop or condition\n");}
"["          {printf("parameter block starting in function\n");}
"]"          {printf("parameter block ending in function\n");}
"->"         {printf("function return type\n");}
%%
int yywrap()
{
 return 1;
}
int main()
{
	yyin = freopen( "input.txt", "r",stdin );
        yyout=freopen("output.txt","w",stdout);
	yylex();
	return 0;
}