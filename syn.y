%{
	#include <stdio.h>
    #include <string.h>
 int nb_ligne=1;
 int col=1;
 int i=1;
 int j=1;
 int compt;
 void yyerror(char *msg);
 
int bibliotheque_incluse[2]={0,0};
void verifier_bibliotheque();

 char sauvType[20];
%}
%start S
%union 
{
int entier;
char* str;
float reel;
}
%left '||'
%left '&&'
%left neg
%left sup_eg inf_eg eg non_eg inf sup 
%left '+''-'
%left '*''/'
%token mc_import mc_isil mc_lang mc_math pvg err mc_dec point mc_const mc_prgrm et mc_final egg C1 C2 mc_debut plus moins fois division inf sup inf_eg sup_eg eg non_eg et1 ou neg mc_FOR mc_DO mc_ENDFOR excla mc_Input <str> chaine vg mc_Write mc_if mc_else mc_endif mc_fin
%token <str> mc_integer <str> mc_float <str> idf  
%token<entier> cst_int <reel> cst_reel 
%type <str> type


%%
S: LISTE_BIB NOM_PRGRM mc_dec List_DECLARATION mc_debut Liste_INSTRUCTIONS mc_fin {verifier_bibliotheque();printf("Programme syntaxiquement correcte <3 \n");YYACCEPT;};
 
 
/* --- Instructions --- */
Liste_INSTRUCTIONS: INSTRUCTION Liste_INSTRUCTIONS
             | 
             ;
             
INSTRUCTION: AFFECTATION 
           | Boucle 
           | Ecriture
		   | Lecture
		   | If
           ;


/* --- BIB --- */
LISTE_BIB: BIB LISTE_BIB
          |
          ;
BIB: mc_import NOM_BIB pvg ;

NOM_BIB: mc_isil point mc_lang { bibliotheque_incluse[0] = 1; }
          | mc_isil point mc_math { bibliotheque_incluse[1] = 1; }
          ;	

		  
/* --- NOM PRGRM --- */

NOM_PRGRM: mc_prgrm idf {inserer($2,"Nom");}


/* --- DECLARATION --- */
DECLARATION :  dec_var | dec_const
			 ;
List_DECLARATION: DECLARATION List_DECLARATION
                |
				;
cst: cst_int 
     |cst_reel
	 ;
dec_var: type listeparams pvg 
			| type idf C1 cst_int C2 pvg {insererTypeTableau($2, sauvType, $4);}
			;

dec_const: mc_final type idf egg cst pvg {
	            if(doubleDeclaration($3)==0) {
				                             inserer($3,"cst");
											 insererType($3,"constante");
											}
                else printf("Erreur semantique : DOUBLE DECLARATION de %s a la ligne %d, colonne %d\n", $3,nb_ligne,col); 
				 
				
			
}	
		   ;

listeparams: idf et listeparams {
	            if(doubleDeclaration($1)==0) {
				                             inserer($1,"idf");
											 insererType($1,sauvType);}
                      else printf("Erreur semantique : DOUBLE DECLARATION de %s a la ligne %d, colonne %d\n", $1,nb_ligne,col); }
				
           | idf  {
			    if(doubleDeclaration($1)==0) {
				                              inserer($1,"idf");
											  insererType($1,sauvType);}
                      else printf("Erreur semantique : DOUBLE DECLARATION de %s a la ligne %d, colonne %d\n", $1,nb_ligne,col);}
				 

		   ;
   

type: mc_integer {strcpy(sauvType,$1);}
      | mc_float {strcpy(sauvType,$1);}	  
      ;  
	  

/* ---Affectation --- */

AFFECTATION:  idf aff expression pvg {if (recherche($1)== -1) printf ("Erreur semantique IDF %s NON DECLARE a la ligne %d, colonne %d\n",$1,nb_ligne,col);}
            | idf C1 cst_int C2 aff expression pvg {if (recherche($1)== -1) printf ("Erreur semantique TABLEAU ""%s"" NON DECLARE a la ligne %d, colonne %d \n",$1,nb_ligne,col);}
			;

				
aff: inf moins moins ; /* "<--" */

expression: CST 
           | idf { if (recherche($1)== -1) printf ("Erreur semantique IDF %s NON DECLARE a la ligne %d, colonne %d\n",$1,nb_ligne,col);}
		   | idf C1 cst_int C2
		   | expression op_arith idf { if (recherche($3)== -1) printf ("Erreur semantique IDF %s NON DECLARE a la ligne %d, colonne %d\n",$3,nb_ligne,col);}			 
		   | expression division idf{ if (recherche($3)== -1) printf ("Erreur semantique IDF %s NON DECLARE a la ligne %d, colonne %d\n",$3,nb_ligne,col);}			   
		   | expression op_arith CST 			  
		   | expression division  cst_reel 			  
		   | expression division  cst_int  {if ($3==0) 
               printf ("Erreur semantique DIVISION PAR 0 a la ligne %d, colonne %d\n",nb_ligne,col); }
		   
CST: cst_int  
   | cst_reel
			
;
	  
op_arith: plus    // Si les opérateurs retournent des chaînes
        | moins 
        | fois  
     
        ;

/* ---Boucle --- */	

Boucle: mc_FOR '(' init pvg cond pvg incr ')'  mc_DO Liste_INSTRUCTIONS mc_ENDFOR
     
      ;

			
	 
init: idf aff cst {if (recherche($1)== -1) printf ("Erreur semantique IDF %s NON DECLARE a la ligne %d, colonne %d\n",$1,nb_ligne,col);};
cond: idf op_comp idf {if ((recherche($1)== -1) ||(recherche($3)== -1)) printf ("Erreur semantique idf %s non declare a la ligne %d, colonne %d\n",$1,nb_ligne,col);}
      | idf op_comp cst  {if (recherche($1)== -1) printf ("Erreur semantique idf %s non declare a la ligne %d, colonne %d\n",$1,nb_ligne,col);}
	 
	  ;
incr: idf plus plus  {if (recherche($1)== -1) printf ("Erreur semantique IDF %s NON DECLARE a la ligne %d, colonne %d\n",$1,nb_ligne,col);};
op_comp: inf 
        | inf_eg 
		| sup 
		| sup_eg
		| eg
		| non_eg 
        ;
		
/* ---Idfs --- */
idf_Lecture: idf vg idf_Lecture {i++;}
           |idf           
;

idf_Ecriture: idf vg idf_Ecriture  {j++; if (recherche($1)== -1) printf ("Erreur semantique idf %s non declare a la ligne %d, colonne %d\n",$1,nb_ligne,col);}
           |idf  {if (recherche($1)== -1) printf ("Erreur semantique IDF %s NON DECLARE a la ligne %d,colonne %d\n",$1,nb_ligne,col);}

/* ---Lecture --- */
Lecture: mc_Input '(' chaine vg idf_Lecture ')' pvg {printf (" nbr IDF : %d\n", i) ;
                                            compt = pourcentage_type($3);
                                            if (comparer(compt, i) == -1)
											{printf ("Erreur semantique NOMBRE D'IDF LECTURE a la ligne : %d, colonne : %d\n",nb_ligne, col);}
										    }
        ;

/* ---Ecriture --- */
Ecriture: mc_Write '(' chaine vg idf_Ecriture')' pvg {printf (" nbr IDF : %d\n", j) ;
                                            compt = pourcentage_type($3);
                                            if (comparer(compt, j) == -1)
											{printf ("Erreur semantique NOMBRE D'IDF ECRITURE a la ligne : %d, colonne %d\n",nb_ligne,col);}}
		;

/* ---IF--- */
If: mc_if '(' Liste_conditions ')' mc_DO Liste_INSTRUCTIONS mc_else Liste_INSTRUCTIONS mc_endif
;

Liste_conditions: Liste_conditions op_logique condition 
                | condition
				;
condition:  cst op_comp idf {if (recherche($3)== -1) printf ("Erreur semantique IDF %s NON DECLARE a la ligne %d, colonne %d\n",$3,nb_ligne,col);};
           |cst op_comp cst
           |idf op_comp cst {if (recherche($1)== -1) printf ("Erreur semantique IDF %s NON DECLARE a la ligne %d, colonne %d\n",$1,nb_ligne,col);};
		   |idf op_comp idf {if ((recherche($1)== -1) || (recherche($1)== -1)) printf ("Erreur semantique IDF %s NON DECLARE a la ligne %d, colonne %d\n",$1,nb_ligne,col);};
	     ;		

op_logique: ou
          | et1	
          | neg		  
		  ;
 

%%
void yyerror(char *msg) {
    printf("ATTENTION : Erreur syntaxique %s, a la ligne %d, colonne %d\n", msg, nb_ligne,col);
}

void verifier_bibliotheque(){
        if (bibliotheque_incluse[0] == 0){
           printf("ERREUR semantique: bibliotheque ISIL.lang abscente. \n");
		}
        if (bibliotheque_incluse[1] == 0) {
           printf("ERREUR semantique: bibliotheque ISIL.io abscente. \n");
		}
	}

main ()
{
yyparse();
afficher();
}
yywrap(){
}
