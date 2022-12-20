%{

#include "Table_des_symboles.h"
#include "Attribute.h"
#include "PCode.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
  
extern int yylex();
extern int yyparse();

int nbParams = 0;
int is_in_main = 0;
 
void yyerror (char* s) {
  printf ("%s\n",s);
  }
		

%}

%union { 
	struct ATTRIBUTE * att;
}

%token <att> NUM
%token TINT
%token <att> ID
%token AO AF PO PF PV VIR
%token RETURN VOID EQ
%token <att> IF ELSE WHILE

%token <att> AND OR NOT DIFF EQUAL SUP INF SUPEQ INFEQ
%token PLUS MOINS STAR DIV
%token DOT ARR

%left OR                       // higher priority on ||
%left AND                      // higher priority on &&
%left DIFF SUPEQ INFEQ EQUAL SUP INF       // higher priority on comparison
%left PLUS MOINS               // higher priority on + - 
%left STAR DIV                 // higher priority on * /
%left DOT ARR                  // higher priority on . and -> 
%nonassoc UNA                  // highest priority on unary operator
%nonassoc ELSE


%start prog  

// liste de tous les non terminaux dont vous voulez manipuler l'attribut
%type <att> exp  typename type while if else app arglist args
         

%%

prog : func_list               {}
;

func_list : func_list fun      {}
| fun                          {}
;


// I. Functions

fun : fun_type fun_head fun_body        {}
;

fun_type: type                 {
   //  if ($1->type_val == INT)
   // printf("int ");
 }
;

fun_head : ID PO PF{
  if ($<att>0->type_val == INT && strcmp($1->name, "main") == 0){
    is_in_main = 1;
    printf("int %s()", $1->name);  
  }else{    
    $1->nbParams = 0;
    is_in_main = 0;
    set_symbol_value($1->name, $1, current_depth);
    printf("void %s_pcode()", $1->name);
  }
 } // erreur si profondeur diff zero

| ID PO params PF              {
  printf("void %s_pcode()", $1->name);
  is_in_main = 0;
  $1->nbParams = nbParams;
  set_symbol_value($1->name, $1, current_depth);
  nbParams = 0;
 }
;

params: type ID vir params     {
  nbParams++;
  $2->offset = -nbParams;
  set_symbol_value($2->name, $2, current_depth);
 }

| type ID                      {
  nbParams++;
  $2->offset = -nbParams;
  set_symbol_value($2->name, $2, current_depth);
 }

vlist: vlist vir ID            {printf("    LOADI(0);\n");
   $3->offset = new_offset(current_depth);
   $3->depth = current_depth;
   set_symbol_value($3->name, $3, current_depth);
 }
| ID                           {printf("    LOADI(0);\n");
   $1->offset = new_offset(current_depth);
   $1->depth = current_depth;
   set_symbol_value($1->name, $1, current_depth);
  }
;


vir : VIR                      {}
;

fun_body : fun_ao block fun_af         {}
;

fun_ao : AO                    {printf("{\n");}

fun_af : AF                    {printf("}\n");}
// Block
block:
decl_list inst_list            {}
;

// I. Declarations

decl_list : decl_list decl     {}
|                              {}
;

decl: var_decl pv              {}
;

var_decl : type vlist          {}
;

type
  : typename                     {$$ = $1;}
;

typename
: TINT                          {$$ = new_attribute(); $$->type_val = INT;}
| VOID                          {$$ = new_attribute(); $$->type_val = TVOID;}
;

// II. Intructions

inst_list: inst inst_list   {}
| inst                      {}
;

pv : PV                      {printf("    print_stack();\n\n");}
;
 
inst:
exp pv                        {}
| ao block af                 {}
| aff pv                      {}
| ret pv                      {}
| cond                        {}
| loop                        {}
| pv                          {}
;

// Accolades pour gerer l'entrée et la sortie d'un sous-bloc

ao : AO                       {
  printf("    ENTER_BLOCK(0);\n");
  current_depth++;
}
;

af : AF                       {
  reset_symbols(current_depth);
  printf("    EXIT_BLOCK(0);\n");
  current_depth--;
}
;


// II.1 Affectations

aff : ID EQ exp               {
  attribute id = get_nearest_symbol($1, current_depth);
  char * mp_position = get_mp_position(current_depth - id->depth);  
  printf("    STORE(%s + %i);\n", mp_position, id->offset);
   }
;


// II.2 Return
ret : RETURN exp              {
  if (is_in_main == 1){
    printf("    STORE(mp);\n    EXIT_MAIN;\n"); 
  } else {
    printf("    return;\n");
  }
}
| RETURN PO PF                {printf("    return;\n");}
;

// II.3. Conditionelles
//           N.B. ces rêgles génèrent un conflit déclage reduction
//           qui est résolu comme on le souhaite par un décalage (shift)
//           avec ELSE en entrée (voir y.output)

cond :
if bool_cond inst_cond elsop       {}
;

// la regle avec else vient avant celle avec vide pour induire une resolution
// adequate du conflit shift / reduce avec ELSE en entrée

elsop : else inst             {printf("  FIN_%i:\n    NOP;\n", $<att>-2->if_label);} 
|                             {printf("  COND_%i:\n", $<att>-2->if_label);}
;

bool_cond : PO exp PF         {printf("    IFN(COND_%i);\n", $<att>0->if_label);} 
;

inst_cond: inst               {}

if : IF                       {
  $$ = new_attribute();
  $$->if_label = new_if();

}
;

 else : ELSE                   {printf("    GOTO(FIN_%i);\n  COND_%i:\n", $<att>-2->if_label, $<att>-2->if_label);}
;

// II.4. Iterations

loop : while while_cond inst  {
  printf("    GOTO(LOOP_%i);\n  END_%i:\n", $1->while_label, $1->while_label);
			}
;

while_cond : PO exp PF        {printf("    IFN(END_%i);\n", $<att>0->while_label);}

while : WHILE                 {
  $$ = new_attribute();
  $$->while_label = new_while();  
  printf("  LOOP_%i:\n", $$->while_label);
}
;


// II.3 Expressions
exp
// II.3.1 Exp. arithmetiques
  : MOINS exp %prec UNA         {printf("    LOADI(-1);\n    MULTI;\n");}
         // -x + y lue comme (- x) + y  et pas - (x + y)
| exp PLUS exp                {printf("    ADDI;\n");}

| exp MOINS exp               {printf("    SUBI;\n");}
| exp STAR exp                {printf("    MULTI;\n");}
| exp DIV exp                 {printf("    DIVI;\n");}
| PO exp PF                   {}
| ID                          {
  attribute id = get_nearest_symbol($1, current_depth);
  char * mp_position = get_mp_position(current_depth - id->depth);
  if (id->offset < 0)
    printf("    LOAD(%s -1 %i);\n", mp_position, id->offset);
  else
    printf("    LOAD(%s + %i);\n", mp_position, id->offset);
  }
| app                         {printf("    EXIT_BLOCK(%d);\n", $1->nbParams);}
| NUM                         {printf("    LOADI(%i);\n", $1->int_val);}


// II.3.2. Booléens

| NOT exp %prec UNA           {printf("    NO\n    print_stack();\n\n");}
| exp INF exp                 {printf("    LT;\n    print_stack();\n\n");}
| exp INFEQ exp               {printf("    LEQ;\n    print_stack();\n\n");}
| exp SUP exp                 {printf("    GT;\n    print_stack();\n\n");}
| exp SUPEQ exp               {printf("    GEQ;\n    print_stack();\n\n");}
| exp EQUAL exp               {printf("    EQU;\n    print_stack();\n\n");}
| exp DIFF exp                {printf("    DIF;\n    print_stack();\n\n");}
| exp AND exp                 {printf("    ET;\n    print_stack();\n\n");}
| exp OR exp                  {printf("    OU;\n    print_stack();\n\n");}

;

// II.4 Applications de fonctions

app : ID PO args PF           {
  attribute id = get_nearest_symbol($1, current_depth);
  if (id->nbParams != $3->nbParams){
    fprintf(stderr,"Error : Wrong argument number for function %s_pcode\n",id->name);
    exit(-1);
  }
  $$ = id;
  printf("    ENTER_BLOCK(%d);\n", id->nbParams);
  printf("    %s_pcode();\n", id->name);
}
;

args :  arglist               {$$=$1;}
|                             {$$=new_attribute(); $$->nbParams=0;}
;

arglist : exp VIR arglist     {
  $$ = $3;
  $$->nbParams++;
    }
| exp                         {
  $$ = new_attribute();
  $$->nbParams = 1;
  }
;



%% 
int main (int argc, char* argv[]) {

  stdin= fopen(argv[1], "r");
  stdout= fopen(argv[2], "w");

printf ("//Compiling MyC source code into PCode (Version 2021) !\n\n");
printf ("#include \"PCode.h\"\n\n");
return yyparse ();
 
} 

