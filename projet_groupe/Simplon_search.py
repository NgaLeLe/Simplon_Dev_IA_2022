# Proposer une fonction almost(mot, s)qui trouve dans un texte s toute 
# les occurrence d’un mot dont une lettre a pu éventuellement être enlevée.
# Exemple: si motvaut «alphonse», une réponse acceptable vaut est «alponse»
import re

def almost(mot, s) :
    result = []
    #nettoye le phrase de source
    tmp_norm = re.sub(r'[\\s.,!?;]', '', s)
    s_en_list = tmp_norm.split()
    if mot in s_en_list:
        result.append(mot)
    for i in range(len(mot)):
        motif="\s"+mot[:i]+mot[i+1:]+"\s"
        print(motif)
        result+=re.findall(r"'"+motif+"'",s_en_list)
        print(result)
        
    return result

def pluslarge(mot, s) :
    #traiter le phrase de recherche: remplace ,. par une espace
    z = " "+re.sub("[,.]"," ",s)+" "
    
    #créer motif/regex de chercher
    #cas 1: une lettre en plus à la fin
    # ( ) chercher les mots mais enlever les espaces devant et après du mot
    motif =  "\s"+mot+"[^\s]?\s"
    found = re.findall(motif, z)
    #
    for i in range(len(mot)) :
        #cas2: une lettre remplacé
        # motif_2 = "\s"+mot[:i]+"[^"+mot[i]+"]?"+mot[i+1:]+"\s"
        motif = "\s"+mot[:i]+"[^"+mot[i]+"]?"
        motif += mot[i+1:]+"\s"
        found += re.findall(motif, " "+z)
        print("motif cas 2 = ", motif)
        print(found)
        #cas3: une lettre de plus
        # motif_3 = "\s"+mot[:i]+"[^\s]"+mot[i:]+"\s"
        motif += "\s"+mot[:i]+"[^\s]"+mot[i:]+"\s"
        found += re.findall(motif, " "+z)
        print("motif cas 3 = ", motif)
        print(found)
    return found
        
#recherche plusieur mot en param p
def score(p,s) :
    score = 0
    s = s.replace(",", "")
    s = s.replace(".", "")
    p = p.replace(".", "")
    p = p.replace(",", "")

    p_liste = p.split()
    for word in p_liste:
        list_found = pluslarge(word, s)
        for w in list_found:
            if word == w  :
                score += 5
            else :
                score += 1
    return score

def score2(p, s) :
    sc = 0
    p_net = " "+re.sub("[,.","",p)+" "
    s_net = " "+re.sub("[,.","",s)
    p_en_mot = p_net.split()
    for mot in p_en_mot :
        for word in pluslarge(mot,s_net):
            sc += 5 if word in p_net else 1
    for y in range(len(p_en_mot)-1) :
        if " " + mot[y] + " " + mot[y+1] + " " in s_net :
            sc += 20 
    return sc

#phrase = "Le petit bonhomme en mousse" 
#search = "Ce superbe matelas en mousse naturelle"
s= "Les etrois tris, lys trois gros, les troisx roi."
m= "trois"
print(score(m,s))
