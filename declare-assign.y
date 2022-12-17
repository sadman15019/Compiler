%{
    #include <stdio.h>
    #include <string.h>
    #include <math.h>
    void yyerror(char *);
    FILE *yyin;
    int yylex(void);
    int cnt=1;//to count variable
    int cnt2=1;//to count array
    int cnt3=1;//to count function
    int temp=1;
    int temp2=1;
    int temp3=1;
    int tempcnt;//to track each variable parameter type and name
    int fcall[100];//to match function call parameters
    int ifx=1;
    int switchx=0;
    int svar=0;
    int c=0;
    struct variable
    {
        char name[100];
        int type;
        int var_con; //to check if it is variable or constant ,0 =var,1=constant
        int is_assigned;
        int ival;
        float fval;
        char cval[1000] ;  
    }var[1000];
    struct array
    {
        char name[100];
        int type;
        int ival[1000];
        float fval[1000];
        int p;  
    }arr[1000];
   struct function
    {
        char name[100];
        int totalparam;
        int rettype;
        int paramtype[1000]; 
    }func[1000];
    void addtype(int t,int x)
    {
       int i;
       for(i=temp;i<cnt;i++)
       {
          var[i].type=x;
          var[i].var_con=t;
       }
       temp=cnt;
    }
    void addtypearr(int x)
    {
       int i;
       for(i=temp;i<cnt;i++)
       {
          arr[i].type=x;
       }
       temp2=cnt2;
    }
    int search(char x[100])
    {
       int i;
       for(i=1;i<cnt;i++)
       {
         if(strcmp(var[i].name,x)==0)
         { 
           return i;
         }
       }
       return 0;
    }
     int searcharr(char x[100])
    {
       int i;
       for(i=1;i<cnt2;i++)
       {
         if(strcmp(arr[i].name,x)==0)
         { 
           return i;
         }
       }
       return 0;
    }
    int searchfunc(char x[100])
    {
       int i;
       for(i=1;i<cnt3;i++)
       {
         if(strcmp(func[i].name,x)==0)
         { 
           return i;
         }
       }
       return 0;
    }
    
%}


%union{
	double floatval;
	char* stringval;
};



%error-verbose
%start program
%token INCLUDE INT FLOAT CHAR VARIABLE ID NUMBER PRINT ASSIGN POW SCAN VAR CONSTANT IF ELSEIF ELSE SWITCH CASE DEFAULT FOR IN WHILE FUNC FUNCRET RET VOID 
%left AND OR
%left GTE GT LTE LT EQ
%left ADD SUB
%left MUL DIV MOD
%left ABS MAX MIN


%type<floatval>range decassignment case expression var_dec cons_dec assignment print scan TYPE INT FLOAT CHAR VARIABLE NUMBER PRINT ASSIGN POW SCAN VAR CONSTANT AND OR GTE GT LTE LT EQ  ADD SUB  MUL DIV MOD IF ELSEIF ELSE
%type<stringval>ID1 ID strexp


%%
program:
      |var_dec program
      |cons_dec program
      |assignment program
      |print program
      |scan program
      |condition program
      |switchcase program
      |forloop program
      |whileloop program
      |function program
      |funccall program
      |increment program
      |decrement program
      ;
var_dec:VAR TYPE ID1 ';' {addtype(0,$2); addtypearr($2); }
       ;
TYPE:INT        {$$=1;  }
     |FLOAT       {$$=2;}
     |CHAR        {$$=3;}
     |VOID        {$$=4;}
     ;
ID1:ID1 ',' ID decassignment {if(search($3)==0)
                  {
                     strcpy(var[cnt].name,$3);
                     var[cnt].is_assigned=1;
                     var[cnt].ival=$4;
                     var[cnt].fval=$4;
                     cnt++;
                  }
                else
                 {
                    printf("variable is already decalared\n");
                 }
                }
    |ID1 ',' ID  {if(search($3)==0)
                  {
                     strcpy(var[cnt].name,$3);
                     var[cnt].is_assigned=0;
                     cnt++;
                  }
                else
                 {
                    printf("variable is already decalared\n");
                 }
                }
    |ID1 ',' ID '['NUMBER']'  {if(searcharr($3)==0)
                  {
                     strcpy(arr[cnt2].name,$3);
                     arr[cnt2].p=(int)$3;
                     cnt2++;
                  }
                else
                 {
                    printf("variable is already decalared\n");
                 }
                }
    |ID decassignment {
                   if(search($1)==0)
                  {
                     strcpy(var[cnt].name,$1);
                     var[cnt].is_assigned=1;
                     var[cnt].ival=$2;
                     var[cnt].fval=$2;
                     cnt++;
                  }
                else
                 {
                    printf("variable is already decalared\n");
                 }
                }
      |ID       {if(search($1)==0)
                  {
                     strcpy(var[cnt].name,$1);
                     var[cnt].is_assigned=0;
                     cnt++;
                  }
                else
                 {
                    printf("variable is already decalared\n");
                 }
                }
      | ID '['NUMBER']'   {if(searcharr($1)==0)
                  {
                     strcpy(arr[cnt2].name,$1);
                     arr[cnt2].p=(int)$3;
                     cnt2++;
                  }
                else
                 {
                    printf("variable is already decalared\n");
                 }
                }
      ;
decassignment:ASSIGN expression  {$$=$2;}
cons_dec:CONSTANT TYPE ID1 ';' {addtype(1,$2); }
       ;
assignment:ID ASSIGN expression ';' {  int y=search($1);
                                       if(y==0)
                                       {
                                          printf("variable is not declared\n");
                                       } 
                                       else
                                       {
                                          if(var[y].var_con==1)
                                          {
                                             if(var[y].is_assigned==0)
                                             {
                                                if(var[y].type==1)
                                                {
                                                   var[y].ival=$3;
                                                }
                                                if(var[y].type==2)
                                                {
                                                 var[y].fval=(float)$3;
                                                }
                                                var[y].is_assigned=1;
                                             }
                                             else
                                             {
                                                printf("constant variable %s already initialized\n",$1);
                                             }
                                          }
                                          else
                                          {
                                           if(var[y].type==1)
                                           {
                                              var[y].ival=$3;
                                           }
                                           if(var[y].type==2)
                                           {
                                                var[y].fval=(float)$3;
                                           }
                                          }
                                       }
                                   }
         |ID ASSIGN strexp ';'     {
                                        int y=search($1);
                                       if(y==0)
                                       {
                                          printf("variable is not declared\n");
                                       } 
                                       else{  
                                          if(var[y].var_con==1)
                                          {
                                             if(var[y].is_assigned==0)
                                             {
                                                strcpy(var[y].cval,$3);  
                                                var[y].is_assigned=1;
                                             }
                                             else
                                             {
                                                printf("constant variable %s already initialized\n",$1);
                                             }
                                          }
                                          else
                                          {
                                                strcpy(var[y].cval,$3); 
                                                var[y].is_assigned=1;
                                          }
                                   }
                                   }
         |ID'['NUMBER']' ASSIGN expression ';'  {  int y=searcharr($1);
                                       if(y==0)
                                       {
                                          printf("variable is not declared\n");
                                       } 
                                       else
                                       {
                                          int x=(int)$3;
                                          if(arr[y].type==1)
                                          {
                                             arr[y].ival[x]=$6;
                                          }
                                          if(arr[y].type==2)
                                          {
                                            arr[y].fval[x]=(float)$6;
                                          }
                                         
                                       }
                                   }
                   ;
strexp:'"'ID '"' {$$=$2;}
expression:
        NUMBER							   {$$=$1;} 
        | ID                     { int y=search($1);
                                       if(y==0)
                                       {
                                          printf("variable %s is not declared\n",$1);
                                       } 
                                       else
                                       {
                                          if(var[y].type==1)
                                          {
                                             $$=var[y].ival;
                                          }
                                          if(var[y].type==2)
                                          {
                                             $$=(float)var[y].fval;
                                          }
                                       }
                                     }
        | expression ADD expression     { $$ = $1 + $3; }
        | expression SUB expression     { $$ = $1 - $3; }
        | expression MUL expression     { $$ = $1 * $3; }
        | expression DIV expression     { $$ = $1 / $3; }
        | expression MOD expression     { $$= fmod($1,$3); }
        | '(' expression ')'            { $$ = $2; }
        | expression GTE expression     { $$ = $1>=$3; }
        | expression GT expression     { $$ = $1>$3; }
        | expression LTE expression     { $$ = $1<=$3; }
        | expression LT expression     { $$ = $1<$3; }
        | expression EQ expression     { $$ = $1==$3; }
        | expression AND expression     { $$ = $1 && $3; }
        | expression OR expression     { $$ = $1 || $3; }   
        |ABS expression             {$$=abs((int)$2);}  
        |MAX '(' expression ',' expression ')'  {int x=(int)$3; int y=(int)$5;
                                                 if(x>=y){$$=x;}
                                                 else  {$$=y;}}
        |MIN '(' expression ',' expression ')'  {int x=(int)$3; int y=(int)$5;
                                                 if(x<y){$$=x;}
                                                 else  {$$=y;}}
        ;
print:PRINT'('ID2')'';'  {}
ID2:ID2 ',' ID           { int y=search($3);  
                           if(y==0)
                           {
                              printf("variable is not declared\n");
                           } 
                           else
                           {
                           if(var[y].type==1)
                           {
                              printf("%d\n",var[y].ival);
                           }
                           if(var[y].type==2)
                           {
                             printf("%f\n",var[y].fval);
                           }
                           if(var[y].type==3)
                           {
                              printf("%s\n",var[y].cval);
                           }
                           }
                        }
   |ID2 ',' ID '[' NUMBER ']'  { int y=searcharr($3);  
                           if(y==0)
                           {
                              printf("variable is not declared\n");
                           } 
                           else
                           {
                           int x=(int)$5;
                           if(arr[y].type==1)
                           {
                              printf("%d\n",arr[y].ival[x]);
                           }
                           if(arr[y].type==2)
                           {
                             printf("%f\n",arr[y].fval[x]);
                           }
                           }
                        }
   |ID                  {   int y=search($1);  
                           if(y==0)
                           {
                              printf("variable is not declared\n");
                           } 
                           else
                           {
                           if(var[y].type==1)
                           {
                              printf("%d\n",var[y].ival);
                           }
                           if(var[y].type==2)
                           {
                             printf("%f\n",var[y].fval);
                           }
                           if(var[y].type==3)
                           {
                              printf("%s\n",var[y].cval);
                           }
                           }
                      }
   |ID'['NUMBER']'     { int y=searcharr($1);  
                           if(y==0)
                           {
                              printf("variable is not declared\n");
                           } 
                           else
                           {
                           int x=(int)$3;
                           if(arr[y].type==1)
                           {
                              printf("%d\n",arr[y].ival[x]);
                           }
                           if(arr[y].type==2)
                           {
                             printf("%f\n",arr[y].fval[x]);
                           }
                           }
                        }

            ;
scan:SCAN '('ID4')'';' {}
         ;
ID4:ID4 ',' ID  {
                           int y=search($3);  
                           if(y==0)
                           {
                              printf("variable is not declared\n");
                           } 
                           else
                           {
                           if(var[y].type==1)
                           {
                              printf("input for %s\n",$3);
                              scanf("%d",&var[y].ival);
                           }
                           if(var[y].type==2)
                           {
                             printf("input for %s\n",$3);
                             scanf("%f",&var[y].fval);
                           }
                           if(var[y].type==3)
                           {
                              printf("input for %s\n",$3);
                              scanf("%s",&var[y].cval);
                           }
                           }
                       }
   |ID                  {
                           int y=search($1);  
                           if(y==0)
                           {
                              printf("variable is not declared\n");
                           } 
                           else
                           {
                           if(var[y].type==1)
                           {
                              printf("input for %s\n",$1);
                              scanf("%d",&var[y].ival);
                           }
                           if(var[y].type==2)
                           {
                             printf("input for %s\n",$1);
                             scanf("%f",&var[y].fval);
                           }
                           if(var[y].type==3)
                           {
                              printf("input for %s\n",$1);
                              scanf("%s",&var[y].cval);
                           }
                           }
                       }
            ;
condition:IF '(' expression ')' {  int a=$3;   if(a!=0){ifx=1;  printf("inside if condition\n");}  else{ifx=0;} } '{' program '}' elseif els
    ;
elseif:
      |ELSEIF '(' expression ')' {  int a=$3;   if(a!=0 && ifx==0){ifx=1;   printf("inside else if condition\n");}  else{ifx=0;} } '{' program '}' 
      ;
els:                        {ifx=1;}
   | ELSE { if(ifx==0){ifx=1;   printf("inside else condition\n");}  else{ifx=0;} } '{' program '}'  {ifx=1;}      
   ;

switchcase:SWITCH ID ':'  {   int y=search($2);  
                           if(y==0)
                           {
                              printf("variable is not declared\n");
                           }
                           else{
                               svar=y;
                           }
                                  
                        } case others 
           ;
case:                      {}
     |CASE expression ':'  {
                           c++;  float a=$2; int y; float z;  
                          if(svar>0 && var[svar].type==1)
                           {
                             y=(int)var[svar].ival;
                             if(y==(int)a && switchx==0){switchx=1;  printf("inside case %d \n",c);} 
                           }
                           if(svar>0 && var[svar].type==2)
                           {
                             z=(float)var[svar].fval;
                             if(z==(float)a && switchx==0){switchx=1;  printf("inside case %d \n",c);}
                           }
                          } '{' program '}' case   
            ;              
others:DEFAULT ':' {if(switchx==0){ printf("inside default\n");}} '{' program '}' {c=0;}
;

forloop:FOR ID IN NUMBER '.' range '{' program '}' {int x=$4; int y=$6; int z=abs(x-y+1); printf("this for loop will run total %d times\n",z);}
range:'.''.''.'NUMBER    {$$=$4;}
     |GTE NUMBER      {$$=$2;}
     |'.'GT NUMBER    {$$=$3+1;}            
     |LTE NUMBER      {$$=$2;} 
     |'.'LT NUMBER    {$$=$3-1;}
     ;
whileloop:WHILE '(' expression ')' {int a=$3; if($3!=0){printf("while loop executed\n");}}
 '{' program '}'
   ;
function:FUNC ID FUNCRET TYPE{if(searchfunc($2)==0)
                  {
                     strcpy(func[cnt3].name,$2);
                     tempcnt=0;
                  }
                 else
                 {
                    printf("function is already decalared\n");
                 }
                func[cnt3].rettype=(int)$4;} '(' funcparam ')' '{' program rretunrn program'}' {func[cnt3].totalparam=tempcnt; tempcnt=0;  cnt3++;}
            ;
funcparam:funcparam ',' TYPE ID { 
                        int x=(int)$3;
                        if(search($4)==0)
                        {
                          strcpy(var[cnt].name,$4);
                          var[cnt].type=x;
                          cnt++;
                          func[cnt3].paramtype[tempcnt]=x;
                          tempcnt++;
                        }
                        else
                        {
                           printf("variable already declared\n");
                        }
                    
                    }
         |TYPE ID   { 
                        int x=(int)$1;
                        if(search($2)==0)
                        {
                          strcpy(var[cnt].name,$2);
                          var[cnt].type=x;
                          cnt++;
                          func[cnt3].paramtype[tempcnt]=x;
                          tempcnt++;
                        }
                        else
                        {
                           printf("variable already declared\n");
                        }
                    
                    }
               ;
rretunrn :RET ID ';'  {int y=search($2);
                        if(y==0)
                        {
                             printf("variable is not declared\n");
                        } 
                        else
                        {
                           if(func[cnt3].rettype==var[y].type)
                           {
                                printf("return type matched\n");
                           }
                           else
                           {
                              printf("return type is not matched\n");
                           }
                        }
                  }
      ;
funccall:ID ASSIGN ID '(' ID3 ')' ';' {
                    int y=searchfunc($3);
                    if(y==0)
                    {
                     printf("function is not declared\n");
                    }
                    else
                    {
                        if(tempcnt<func[y].totalparam)
                        {
                           printf("too few arguments\n");
                        }
                        else
                        {
                           int j=1,i;
                           for(i=0;i<func[y].totalparam;i++)
                           {
                              if(fcall[i]!=func[y].paramtype[i]){j=0;}
                           }
                           if(j==1)
                           {
                              int z=search($1);
                              if(y==0)
                             {
                                 printf("variable is not declared\n");
                             } 
                             else
                             {
                               if(func[y].rettype==var[z].type)
                               {
                                  printf("fucntion called\n");
                               }
                               else
                               {
                                 printf("variable and return type is not matched\n");
                               }
                             }
                           }
                           else
                           {
                              printf("argument type is not matched\n");
                           }
                        }
                    }
                    tempcnt=0;
}
       ;
ID3:ID3 ',' ID {
                   int y=search($3);
                   if(y==0)
                   {
                       printf("variable is not declared\n");
                   } 
                   else
                   {
                      fcall[tempcnt]=var[y].type;
                      tempcnt++;
                   }
               }
   |ID         {
                       int y=search($1);
                        if(y==0)
                        {
                             printf("variable is not declared\n");
                        } 
                        else
                        {
                           fcall[tempcnt]=var[y].type;
                           tempcnt++;
                        }
               }
      ;
increment:ID ADD ADD ';'{
                       
                       int y=search($1);
                        if(y==0)
                        {
                             printf("variable is not declared\n");
                        } 
                        else
                        {
                           if(var[y].type==1)
                           {
                               var[y].ival=var[y].ival+1;
                           }
                           else if(var[y].type==2)
                           {
                              var[y].fval=var[y].fval+1;
                           }
                           else if(var[y].type==3)
                           {
                             printf("cannot increment sting\n");
                           }
                        }
                     }
            ;
decrement:ID SUB SUB ';'  {
                       
                       int y=search($1);
                        if(y==0)
                        {
                             printf("variable is not declared\n");
                        } 
                        else
                        {
                           if(var[y].type==1)
                           {
                               var[y].ival=var[y].ival-1;
                           }
                           else if(var[y].type==2)
                           {
                              var[y].fval=var[y].fval-1;
                           }
                           else if(var[y].type==3)
                           {
                             printf("cannot decrement sting\n");
                           }
                        }
                     }
         ;
%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyin=freopen("test_input.txt", "r",stdin);
    yyparse();
}
