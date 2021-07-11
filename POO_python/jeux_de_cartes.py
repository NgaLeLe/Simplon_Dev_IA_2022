from random import randrange

#On initialise toutes les valeurs et couleurs
#que peuvent prendre les cartes

valeurs = [i for i in range(1, 11)]
couleurs = [i for i in range( 1, 5)]

#On choisi les nb de tours que va durée la partie
#et on initialise le score à 0
nbTours = 7
score = 0

#on crée une liste de tuple pour représenter le paquet de cartes
paquet = [(v,c) for v in valeurs for c in couleurs]
main1, main2 = [], []

#partie 2: les joueurs tirent une carte aléatoirement
# la supprime dans paquet et l'ajoute a main du joueur
"""
for tour in range(nbTours) :
    x = paquet[randrange(len(paquet))]
    main1.append(x)
    paquet.remove(x)
    y = paquet[randrange(len(paquet))]
    main2.append(y)
    paquet.remove(y)
"""

class Carte:
    def __init__(self, valeur, couleur):
        self.valeur = valeur
        self.couleur = couleur
    def plusQueGrand(self,card2): #type tube
        return self.valeur > card2.valeur or (self.valeur == card2.valeur and self.couleur > card2.couleur) 

class Partie:
    #méthode constructeur
    def __init__(self, nbCouleurs, nbValeurs, nbTours) :
        #self.nbCouleurs = nbCouleurs
        #self.nbValeurs = nbValeurs
        self.nombreTours = nbTours
        self.score = 0 
        #initialiser la valeur de score à 0
        self.paquet = [Carte for Carte.valeur in range(nbValeurs) for Carte.couleur in range(nbCouleurs)]
    
    def lancer(self) :
        joueur1, joueur2 = self.piocher(self.nombreTours, self.paquet)
        for tour in range(self.nombreTours) :
            self.score += 1 if joueur1[tour].plusQueGrand(joueur2[tour]) else -1
        
    def piocher(nbTours, paquet):
        main1, main2 = [Carte],[Carte]
        for tour in range(nbTours) :
            #valeur alératoir entre 0 et nb d'element dans paquet
            x = paquet[randrange(len(paquet))]
            main1.append()
            paquet.remove(x)
            y = paquet[randrange(len(paquet))]
            main2.append(y)
            paquet.remove(y)
        return main1, main2

"""    
for i in range(nbTours) :
    if main1[i][0] > main2[i][0] or (main1[i][0] == main2[i][0] and main1[i][1] > main2[i][1]):
        score += 1
    else :
        score -= 1
print(score)
print("Vainqueur est :" + ("joueur 1 " if score > 0 else "joueur 2"))
"""
#--- Main ---
print("Depart de jeu: ")
