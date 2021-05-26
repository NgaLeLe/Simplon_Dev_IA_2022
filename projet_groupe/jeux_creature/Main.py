from Case import Case
from Creature import Creature
from Jeu import Jeu
from random import choice

def affiche_plateau(plateau, jeu):
    for i in plateau:
        listCreature =  jeu.listesDesCreatures
        print(' . ')

max = 7
#creer plateau du jeu
print("creer plateau")
plateau = []
for x in range(max):
    for y in range(max):
        c = Case(x,y)
        plateau.append(c)

#creer 2 creatures
pokemon = Creature('Pokemon', Case(0,0))
picachu = Creature('Picachu', Case(max-1, max-1))


jeu1 = Jeu(plateau,[pokemon,picachu], pokemon)

while jeu1.tour > 0 :
    print(jeu1)
    choisiCible = jeu1.actif.choisirCible(jeu1)
    jeu1.deplacer(jeu1.actif, choisiCible)

