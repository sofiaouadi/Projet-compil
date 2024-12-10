%{
	#include <stdio.h>
    #include <string.h>
 int nb_ligne=1;
 int col=1;
 void yyerror(char *msg);
 char sauvType[20];
%}
%start S
%union 
{
int entier;
char* str;
}
%left '+''-'
%left '*''/'
%token mc_import mc_isil mc_lang mc_math pvg err mc_dec point mc_const mc_prgrm et mc_final egg C1 C2 mc_debut plus moins fois division inf sup mc_FOR P1 P2 mc_DO mc_ENDFOR excla cpt mc_Input chaine vg mc_Write mc_if mc_else mc_endif mc_fin
%token inf_eg sup_eg
%token <str> mc_integer mc_float idf  
%token <entier> cst

%type <entier> If condition

%%
S: LISTE_BIB NOM_PRGRM mc_dec DECLARATION mc_debut INSTRUCTIONS mc_fin{printf("Programme syntaxiquement correcte -\n");YYACCEPT;};
 
 
/* --- Instructions --- */
INSTRUCTIONS: AFFECTATION Boucle Lecture Ecriture If ;

/* --- BIB --- */
LISTE_BIB: BIB LISTE_BIB
          |
          ;
BIB: mc_import NOM_BIB pvg;

NOM_BIB: mc_isil point mc_lang 
          | mc_isil point mc_math
          ;	
		  
/* --- NOM PRGRM --- */

NOM_PRGRM: mc_prgrm idf ;


/* --- DECLARATION --- */
DECLARATION :  dec_var dec_const DECLARATION 
			 | 
			 ;

dec_var: type listeparams pvg  
			| type idf C1 cst C2 pvg {insererTypeTableau($2, sauvType, $4);
        }

			|
			;

dec_const: mc_final type idf egg cst pvg {
	            if(doubleDeclaration($3)==0) insererType($3,"constante");
                      else printf("erreur semantique : double declaration de %s a la ligne %d \n", $3,nb_ligne); }
		   |
		   ;

listeparams: idf et listeparams {
	            if(doubleDeclaration($1)==0) insererType($1,sauvType);
                      else printf("erreur semantique : double declaration de %s a la ligne %d \n", $1,nb_ligne); }
           | idf  {
			    if(doubleDeclaration($1)==0) insererType($1,sauvType);
                      else printf("erreur semantique : double declaration de %s a la ligne %d \n", $1,nb_ligne);}

		   ;
   

type: mc_integer {strcpy(sauvType,$1);}
      | mc_float {strcpy(sauvType,$1);}	  
      ;  
	  

/* ---Affectation --- */

AFFECTATION:  idf aff expression pvg AFFECTATION
            | tab aff expression pvg AFFECTATION
            |
			;
tab: idf C1 cst C2 ;
aff: inf moins moins ; /* "<--" */

expression: elem expression_rec
            |
            ;
			

expression_rec: op_arith elem expression_rec 
		    |
			;
elem: idf 
      |cst   // Récupérer la valeur de `cst`
	  ;
	  
op_arith: plus    // Si les opérateurs retournent des chaînes
        | moins 
        | fois  
        | division 
        ;

/* ---Boucle --- */	

Boucle: mc_FOR P1 init pvg cond pvg incr P2 mc_DO AFFECTATION mc_ENDFOR
;
init: cpt aff cst ;
cond: cpt op_comp idf
      | cpt op_comp cst 
	 
	  ;
incr: cpt plus plus ;
op_comp: inf | inf egg | sup | sup egg| egg egg| excla egg 
;

/* ---Lecture --- */
Lecture: mc_Input P1 chaine vg idf P2 pvg ;

/* ---Ecriture --- */
Ecriture: mc_Write P1 chaine vg idf P2 pvg ;
 
/*---If----*/
If: mc_if P1 condition P2 mc_DO mc_Write P1 chaine P2 pvg mc_else mc_Write P1 chaine P2 pvg mc_endif
;
condition:cst op_comp1 cst
	     ;
op_comp1: inf | sup | egg | sup_eg | inf_eg
;

%%
void yyerror(char *msg) {
    printf("Erreur syntaxique %s, a la ligne %d\n", msg, nb_ligne);
}
main ()
{
yyparse();
afficher();
}
yywrap(){
}
