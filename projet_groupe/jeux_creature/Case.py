class Case:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __str__(self):
        return "case: " + str(self.x) + ',' + str(self.y)

    def adjacentes(self, jeu):
        #print('appel adjacentes')
        list_cage = []
        for c in jeu.listesDesCases:
            # self != c and abs(c.x-self.x)<2 and abs(c.y-self.y)<2
            if (c.x == self.x-1 or c.x == self.x+1 or c.y == self.y-1 or c.y == self.y+1) :
                list_cage.append(c)
        return list_cage
    
