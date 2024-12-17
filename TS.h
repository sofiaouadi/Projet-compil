#include <stdio.h>
#include <string.h>
#include <stdlib.h>
extern int nb_ligne;
extern int TailleTab;

typedef struct
{
char NomEntite[20];
char CodeEntite[20];
char TypeEntite[20];
} TypeTS;

//initiation d'un tableau qui va contenir les elements de la table de symbole
TypeTS ts[100]; 

// un compteur global pour la table de symbole
int CpTS = 0;


//une fonctione recherche: pour chercher est ce que l'entite existe ou non deja dans la table de symbole.
// i: l'entite existe deja dans la table de symbole, et sa position est i, -1: l'entite n'existe pas dans la table de symbole.

int recherche(char entite[])
{
  int i = 0;
  while (i < CpTS)
  {
    if (strcmp(entite, ts[i].NomEntite) == 0)
        return i;
    i++;
  }

  return -1;
}

//une fontion qui va inserer les entites de programme dans la table de symbole
void inserer(char entite[], char code[])
{
  if (recherche(entite) == -1)
  {
    strcpy(ts[CpTS].NomEntite, entite);
    strcpy(ts[CpTS].CodeEntite, code);
    CpTS++;
  }
}

//une fonction pour afficher la table de symbole
void afficher ()
{
printf("\n/***************Table des symboles ******************/\n");
printf("________________________________________________\n");
printf("\t| NomEntite |  CodeEntite  |  TypeEntite   \n");
printf("________________________________________________\n");
int i=0;
while(i<CpTS)
{

printf("\t|%10s |%12s  |%12s   |\n",ts[i].NomEntite,ts[i].CodeEntite,ts[i].TypeEntite);

i++;
}
}


// fonction qui change le type d'une entite une fois qu'elle va etre reconu dans la syntaxe 

void insererType(char entite[], char type[]){

int posEntite=recherche(entite);
if (posEntite!=-1){ 

strcpy(ts[posEntite].TypeEntite,type);

//printf("lentite est %s, sont type est %s %d\n",ts[CpTabSym].NomEntite,ts[CpTabSym].TypeEntite,CpTabSym);

}
}




////Les routines semantiques

int doubleDeclaration (char entite[])
{
int posEntite=recherche(entite);

if (strcmp(ts[posEntite].TypeEntite,"")==0) return 0;  // j'ai pas trouve le type associe a l'entite dans le table de symbole et donc elle est pas encore declaree
else return 1; /* le type de l'entite existe deja dans la TS et donc c'est une double declaration */
}



void insererTypeTableau(char* nom, char* type, int taille) {
    int posEntite = recherche(nom);
    if (posEntite == -1) {
        // L'entite n'existe pas, on l'ajoute
        strcpy(ts[CpTS].NomEntite, nom);
        strcpy(ts[CpTS].CodeEntite, "Tableau");
		sprintf(ts[CpTS].TypeEntite, "%s[%d]", type, taille);
		TailleTab = taille;
        CpTS++;
		
   
			
			
        } else {
            // Si c'est deja un tableau, erreur
            printf("Erreur semantique: L'entite '%s' est deja un tableau dans la ligne .\n", nom);
        }
    }


void compterLigne(const char* texte) {
    const char* p = texte;
    while (*p) {
        if (*p == '\n') {
            nb_ligne++;
        }
        p++;
    }
}



#include <stdbool.h>

int pourcentage_type(const char* texte) {
    const char* p = texte; 
    bool b;
	int compt=0;
    while (*p) {
        if (*p == '%') {
			b = true;
			compt++;
            p++;
            if ((*p != 'd') && (*p != 'f')) {
            printf ("Erreur semantique : caractere '%c' invalide apres '%%' a la ligne %d.\n", *p, nb_ligne );
            }
        }
        p++;
    }
    if (b == false ) { 
    printf ("Erreur semantique : aucun format '%%' a la ligne %d.\n", nb_ligne);
    }
	else return compt;
}

int comparer(int compt,int compteur_idf){
 if (compt != compteur_idf)
	 {return -1;}
}
int comparer2(int compt,int compteur_idf){
 if (compt  > compteur_idf)
	 {return -1;}
}


int est_reel(const char *constante) {
    int point_trouve = 0;
	int i;

    for ( i = 0; constante[i] != '\0'; i++) {
        if (constante[i] == '.')
            point_trouve = 1; 
        }
		
	if (point_trouve = 1) return 1;
	else return 0;
  
}

const char* returnType(char entite[]) { 
    int posEntite=recherche(entite);
if (strcmp(ts[posEntite].TypeEntite,"")==1) return ts[posEntite].TypeEntite ;
}

const char* getType(char entite[]) {
    int posEntite = recherche(entite);
    if (posEntite != -1) {
        return ts[posEntite].TypeEntite; // Retourne le type de l'entité si elle existe
    } else {
        printf("Erreur semantique : L'entite '%s' n'existe pas dans la Table des Symboles a la ligne %d.\n", entite, nb_ligne);
        return NULL; // Retourne NULL si l'entité n'existe pas
    }
}



#include <string.h>

int comparerChaines(const char* str1, const char* str2) {
    // Utilise strcmp pour comparer les deux chaînes
    if (strcmp(str1, str2) == 0) {
        return 0;  // Les chaînes sont identiques
    } else {
        return 1;  // Les chaînes sont différentes
    }
}

void verifierSiConstante(char* entite) {
    int posEntite = recherche(entite);
    if (posEntite != -1) {
        if (strcmp(ts[posEntite].CodeEntite, "cst") == 0) {
            printf("Erreur semantique : L'instruction arithmetique ne peut pas etre effectuee sur la constante '%s' a la ligne %d.\n", 
                   entite, nb_ligne);
        }
    }
}

