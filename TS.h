#include <stdio.h>
#include <string.h>

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

void insererType(char entite[], char type[])
{

int posEntite=recherche(entite);
if (posEntite!=-1)
{ 

strcpy(ts[posEntite].TypeEntite,type);

//printf("lentite est %s, sont type est %s %d\n",ts[CpTabSym].NomEntite,ts[CpTabSym].TypeEntite,CpTabSym);

}
}




////Les routines semantiques

int doubleDeclaration (char entite[])
{
int posEntite=recherche(entite);

//printf ("\nposi %d\n",posEntite);
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
        CpTS++;
    } else {
        // Si l'entite est deja dans la table et que c'est un tableau, on met a jour le type
        if (strcmp(ts[posEntite].TypeEntite, type) != 0) {
            // Si c'est une variable et non un tableau, on met a jour le type
            strcpy(ts[posEntite].CodeEntite, "Tableau");
			strcpy(ts[posEntite].TypeEntite, type);
			
			
        } else {
            // Si c'est deja un tableau, on ignore et ne faisons rien
            printf("Erreur semantique: L'entite '%s' est deja un tableau dans la ligne .\n", nom);
        }
    }
}
