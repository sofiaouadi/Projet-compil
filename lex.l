%{
#include "syn.tab.h"
#include "TS.h"
extern YYSTYPE yylval;
extern int nb_ligne;
extern int col;
%}
lettre [a-zA-Z]
chiffre [0-9]
maj[A-Z]
idf {maj}({lettre}|{chiffre}|_[^__])*
cst [1-9][0-9]*|0  
cpt ({lettre})+
com1 ("/")("/")(.)*
com2 ("#")(.)*
com3 ("/*")(.|\n)*("*/")


%%
import {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_import ;}
ISIL {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return mc_isil ;}
io {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_math ;}
lang {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return mc_lang ;}
PDEC {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_dec ;}
Programme {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_prgrm ;}
final {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_final ;}
FOR {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_FOR ;}
ENDFOR {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_ENDFOR ;} 
DO {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_DO ;}
"integer" {yylval.str=strdup(yytext);printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_integer;}
InDebut {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_debut;}
InFin {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_fin;}
"float" {yylval.str=strdup(yytext);printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_float;}
Input {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_Input;}
Write {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_Write;}
If {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_if;}
Else {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_else;}
EndIf {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_endif;}
\"[^"]*\" { yylval.str = strdup(yytext); return chaine; }
{cst} {yylval.entier=atoi(yytext);inserer(yytext,"cst"); return cst;}
{idf}  {yylval.str=strdup(yytext); inserer(yytext,"idf"); return idf;
       if (yyleng <=18) printf (" idf valide ") ;
       else printf ("erreur lexicale : idf trop long") ;
       }	 
{cpt} {yylval.entier=atoi(yytext);inserer(yytext,"cpt"); return cpt;}
{com1} {}
{com2} {}
{com3} {}

\< {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return inf ;}
\> {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return sup ;}
"<=" {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return inf_eg ;}
">=" {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return sup_eg;}
\| {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return et ;}
\. {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return point ;}
\, {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return vg ;}
\; {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return pvg ;}
\= {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return egg ;}
\[ {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return C1 ;}
\] {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return C2 ;} 
\+ {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return plus ;}
\- {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return moins ;}
\* {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return fois ;}
"/" {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return division ;}
\( {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return P1 ;}
\) {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return P2 ;}

[ \t] 
\n {nb_ligne++;col=1;}
. {printf ("erreur lexical sur l'entite %s a la ligne %d a la colonne %d",yytext,nb_ligne,col); return err;}
%%