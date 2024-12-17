%{
#include "syn.tab.h"
#include "TS.h"
extern YYSTYPE yylval;
extern int nb_ligne;
extern int col;
extern int TailleTab;
%}
lettre [a-zA-Z]
chiffre [0-9]
maj[A-Z]
idf {maj}({lettre}|{chiffre}|_[^__])*
Entier [0-9]+
Reel [0-9]+\.[0-9]+
Entier_signe [\(][-+][0-9]+[\)]
Reel_signe [\(][-+][0-9]+\.[0-9]+[\)]
com1 ("/")("/")(.)*
com2 ("#")(.)*
com3 ("/*")(.|\n[^"*/"])*("*/")


%%
import {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_import ;}
ISIL {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return mc_isil ;}
io {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_math ;}
lang {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return mc_lang ;}
PDEC {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_dec ;}
Programme {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_prgrm ;}
final {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_final ;}
FOR {printf("ligne %d: %s reconnue \n",nb_ligne,yytext); col=col+yyleng; return mc_FOR;}
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
{idf}  {yylval.str=strdup(yytext);  return idf;
       if (yyleng <=18) printf (" idf valide ") ;
       else printf ("WARNING: ligne %d, colonne %d : idf trop long !\n", nb_ligne,col) ;}
{com1} {}
{com2} {}
{com3} {compterLigne(yytext);}
{Entier} {
    if (atoi(yytext) > 32767) {
        printf("WARNING: ligne %d, colonne %d : nombre trop grand !\n", nb_ligne,col);
    } else {
        yylval.entier= atoi(yytext);
        return cst_int;
    }
}
{Reel} {
   
        yylval.str=strdup(yytext);
        return cst_reel;
}
{Entier_signe} {
    if (atoi(yytext) > 32767 || atoi(yytext) < -32768) {
        printf("WARNING: ligne %d , colonne %d : nombre trop grand !\n", nb_ligne,col);
    } else {
        yylval.reel= atof(yytext);
        return cst_int;
    }
}
{Reel_signe} {
  
        yylval.reel=atof(yytext);
        return cst_reel;
}
"<" {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return inf ;}
">" {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return sup ;}
"==" {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return eg ;}
"!=" {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return non_eg ;}
"<=" {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return inf_eg ;}
">=" {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return sup_eg;}
\| {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return et ;}
"." {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return point ;}
\, {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return vg ;}
\; {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return pvg ;}
\= {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return egg ;}
\[ {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return C1 ;}
\] {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return C2 ;} 
\+ {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return plus ;}
\- {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return moins ;}
\* {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return fois ;}
"/" {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return division ;}
"||" {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return ou ;}
"&&" {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return et1 ;}
"!" {printf("ligne %d: %s reconnue\n",nb_ligne,yytext); col=col+yyleng; return neg ;}

[()] {return yytext[0];} 
\"[^\"]*\" { yylval.str = strdup(yytext); pourcentage_type(yytext); return chaine; } //chaine de caractere


[ \t] 
\n {col=1;nb_ligne++;} //reinitialiser la colonne et incrementer la ligne
. {printf ("ATTENTION : erreur lexical sur l'entite %s a la ligne %d a la colonne %d\n",yytext,nb_ligne,col); return err;}
%%

