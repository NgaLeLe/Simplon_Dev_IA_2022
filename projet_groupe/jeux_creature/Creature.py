from random import choice
class Creature:
    def __init__(self, nom, position):
        self.nom = nom
        self.position = position
    
    def __str__(self):
        return self.nom + " est sur " + str(self.position)

    def choisirCible(self,jeu):
        #print('Choisir Cible')
        listeCasePotentiel = self.position.adjacentes(jeu)
        listeCaseOccupee = []
        for pos in listeCasePotentiel :
            if jeu.estOccupee(pos) :
                listeCaseOccupee.append(pos)
        if len(listeCaseOccupee) > 0 :
            return choice(listeCaseOccupee)
        else :
            return choice(listeCasePotentiel)
        
