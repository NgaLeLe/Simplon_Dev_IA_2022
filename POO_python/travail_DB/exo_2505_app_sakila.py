#SQL Alchemy 
from sqlalchemy import create_engine
import pandas as pd

#infomation de la connection
info_connection = { 
    'connector': 'pymysql',
    'username' : "nga", 
    'password' : "Simplon123!",
    'host' : "localhost",
    'baseDonnee' : "sakila"}

#creer un engine de connection
def connect_db(connection_info):
    print('Faire une connection !')
    connector = connection_info['connector']
    user = connection_info['username']
    pswd = connection_info['password']
    host = connection_info['host']
    monDB = connection_info['baseDonnee']
    engine = create_engine(f'mysql+{connector}://{user}:{pswd}@{host}/{monDB}')
    return engine

def new_customer(engine):
    #location typé geo, avec une valeur défault
    location_client = "X'0101000000000000000000F03F000000000000F03F'"
    
    #demande à l'utilisateur de saisir les coordonnees du nv client
    print("Insert un nouveau client: ")
    nom_client = str(input("Votre nom: ")).upper()
    prenom_client = str(input("Prenom: ")).upper()
    address_client = str(input("Adresse: "))
    district_client = str(input("District: "))
    codePostal_client = askEnterNumber("Code postale (12345): ") 
    numTelephone_client = askEnterNumber("Numero telephone: ") 
    email_client = str(input('Email: '))
    city_client = str(input("Ville: "))
    pays_client = str(input("Pays: "))

    #appelle methode recuperInsere_Country: recuperer paysID si existe, si non 
    # inserer nv pays et retournd son paysID
    #recupere cityID
    paysID = recuperInsere_Country(pays_client, engine)
    villeID = recuperInsere_City(city_client, paysID, engine)
    
    #ajouter nv address du client
    addressID = new_Address(engine, address_client, district_client, villeID, codePostal_client, numTelephone_client, location_client)
    list_Store = liste_Store_Existe(engine)
    print('Voici liste de store ')
    print(list_Store)
    storeID = int(input('Store id = '))
    print('store ID = ', storeID, type(storeID))
    print('Address id = ', addressID, type(addressID))
    #inserer client
    statement_Insert_client = 'INSERT INTO customer (store_id, first_name,last_name, email, address_id, create_date) VALUES (%d, "%s", "%s", "%s", %d, CURRENT_TIMESTAMP);'
    engine.execute(statement_Insert_client %(storeID, prenom_client, nom_client, email_client, addressID ))
    print("Nv client a ete bien ajoute !")

def askEnterNumber(messageInput):
    """ 
        permet de saisir une chaine de character numerique 
    Args: messageInput est information d'input soit Telephone, soit codePostale 
    """
    try:
        tmpEntree = str(input(messageInput))
        if not tmpEntree.isnumeric():
            raise ValueError(" doit contenir que des chiffre ! Reesayez !")
    except ValueError as e:
        print(e)
        tmpEntree = askEnterNumber(messageInput) 
    return tmpEntree

def recuperInsere_Country(pays_client, engine):
    """ Verifier pays_client saisie est existe dans BD, 
        si Oui, retourne country_id dans DB
        si Non, inserer nv country et recuperer id de nv country
    Args: pays_client : country à verifier
          engine: machine de connection DB
    Retourne: id_country 
    """
    #normer pays sous forme Pays
    pays_client = pays_client[0].upper() + pays_client[1:].lower()
    countryId = ""
    ckPays = pd.read_sql_query('SELECT country_id, country FROM country WHERE upper(country) LIKE upper("%s");' %(pays_client), engine)
    if ckPays.shape[0] > 0 :
        countryId = ckPays['country_id'].loc[0]
    else :
        print('Inserer nv pays: ')
        engine.execute('INSERT INTO country(country) VALUES("%s")' %(pays_client))
        countryId = pd.read_sql_query('SELECT LAST_INSERT_ID()', engine)
    return countryId

def recuperInsere_City(city_client, country_id, engine):
    #normer la ville en CamelCase
    city_client = city_client[0].upper()+city_client[1:].lower()
    
    cityID = 0
    #verifie city saisie est existe dans BD  nom de city et country_id 
    #le resultat est stocké à var ckCity
    ckCity = pd.read_sql_query('SELECT city_id, city FROM city WHERE upper(city) LIKE upper("%s") AND country_id = %d;' %(city_client, country_id), engine)
    #si df n'est pas vide, recupere la 1e valeur du colonne city_id
    if ckCity.shape[0] > 0 :
        cityID = ckCity['city_id'].loc[0]
    else :
        #si non, inserer un nv ville
        print('Inserer nv ville: ')
        #inserer les city_client et sa country_id comme paramètre du requête 
        engine.execute('INSERT INTO city(city, country_id) VALUES("%s", %d);' %(city_client, country_id))
        #recupere  city_id insere dernier
        cityID = pd.read_sql_query('SELECT LAST_INSERT_ID()', engine)
    return cityID
  
def new_Address(engine, pAddress, pDistrict, pCity_id, pCodePostale, pTelephone, pLocation): 
    print("Ajout un nv address !")
    addressID = ""
    
    engine.execute('INSERT INTO .address(address, district, city_id, postal_code, phone, location) VALUES ("%s", "%s", %d, "%s", "%s",ST_GeomFromWKB(%s));' %(pAddress, pDistrict, pCity_id, pCodePostale, pTelephone, pLocation))
    addressID = pd.read_sql_query('SELECT LAST_INSERT_ID();', engine).loc[0]
    
    return addressID

#requete de trouver tous les stores dans DB
def liste_Store_Existe(engine):
    # print(engine.has_table('store'))
    # print(engine.has_table('address'))
    sta_select_store = 'SELECT store_id, a.address_id, a.address FROM store AS s INNER JOIN address AS a ON s.address_id = a.address_id;'
    return pd.read_sql_query(sta_select_store, engine)

def cherche_historique_location(engine, pNom, pPrenom):
    """
        prepare requete dont les paramètres sont pNom et pPrenom du client 
        au fonction de la condition de filtrage
    *** Retourne: dataframe de historiques de la location
    """
    statement = "SELECT first_name, last_name, rental_date, f.film_id AS film_id, title, timediff(if(return_date is null,0, return_date),rental_date)/(24*60*60) as nb_days "
    statement += " FROM customer AS c LEFT JOIN rental AS r ON c.customer_id = r.customer_id "
    statement += " JOIN inventory AS i ON r.inventory_id = i.inventory_id "
    statement += " JOIN film AS f ON i.film_id = f.film_id "
    statement += f" WHERE first_name REGEXP '.*{pNom}.*' OR last_name REGEXP '.*{pPrenom}.*';"
    
    #resultat retourne de requete est stocké à var dfHistorique
    dfHistorique = pd.read_sql_query(statement , engine)
    
    return dfHistorique

def historique_location_client(engine):
    print("Historique de location d'un client")
    pNom = str(input('Saisir un nom de client: ')).upper()
    pPrenom = str(input('Prenom de client: ')).upper()
    df_historique = cherche_historique_location(engine, pNom, pPrenom)
    
    myCols = ['rental_date', 'film_id', 'title', 'nb_days']
    #afficher le resultat
    print("----- HISTORIQUE DE LOCATION -----")
    print("\t Nom : ", df_historique['first_name'].unique())
    print("\t Prenom :", df_historique['last_name'].unique())
    if not df_historique.empty :
        print(df_historique[myCols])
        print("\t Nombre de fois  = ", df_historique.shape[0])
        print("\t Duree moyenne de location (journee) = %.3f" %(df_historique['nb_days'].mean()))
        print("\t Duree minimum = %.3f jours" % (df_historique['nb_days'].min()))
        print("\t Duree maximum = %.3f jours" % (df_historique['nb_days'].max()))
    else :
        print("Pas d'historique de location")
   
###  MAIN  ###


connection = connect_db(info_connection)
# new_customer(connection)

historique_location_client(connection)