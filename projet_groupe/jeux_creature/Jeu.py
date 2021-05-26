

class Jeu:
    def __init__(self, listesDesCases, listeDesCreatures, actif):
        self.listesDesCases = listesDesCases
        self.listesDesCreatures = listeDesCreatures
        self.tour = 1
        self.actif = actif
    
    def __str__(self):
        tmp = "--- TOUR " + str(self.tour) + " ---\n"
        for p in self.listesDesCreatures :
            tmp += str(p) + " - "
        tmp += "\nActif : " + str(self.actif.nom)
        return tmp
    
    def estOccupee(self, case):
        for element in self.listesDesCreatures :
            return element.position.x == case.x and element.position.y == case.y 
            #  si il trouve un creature dont le case est egal la case de verifier
            #  return any(b.position == case for b in self.listesDesCreatures)

    def deplacer(self,creature,case):
        print('Deplacer par ', creature.nom)
        adjacents_creature = case.adjacentes(self)
        # print("list d'adjacente = ",len( adjacents_creature))
        if creature.position in adjacents_creature :
            if self.estOccupee(case):
                print(creature.nom, ' deplace à ', case)
                #creature.position = case
                print(creature.nom, ' est vainqueur')
                self.tour = 0
        else :
            self.tour += 1
            for c in self.listesDesCreatures :
                if c != self.actif :
                    self.actif = c
        creature.position = case
    