SELECT * 
FROM customer;

#1. Afficher tout les emprunt ayant été réalisé en 2006. Le mois doit être écrit en toute lettre et le résultat doit s’afficher dans une seul colONne.alter
SELECT concat(rental_id, ' - ', date_format(rental_date,"%b"), ' - ', title)
FROM rental AS r JOIN inventory AS i ON r.inventory_id = i.inventORy_id
      JOIN film AS f ON i.film_id = f.film_id
WHERE year(rental_date) = 2006 
    OR year(RETURN_DATE)=2006;

# 2. Afficher la colONne qui dONne la durée de locatiON des films en jour.
SELECT  rental_id, datediff(return_date, rental_date) as duree_location
FROM rental
WHERE rental_date is not null;

# 3. Afficher les emprunts réalisés avant 1h du matin en 2005. Afficher la date dans un fORmat lisible.
SELECT rental_id, date_fORmat(rental_date,"%h:%m %c-%b-%y ") 
FROM rental
WHERE year(rental_date) = 2005
    and hour(rental_date) < 1; 

# 4. Afficher les emprunts réalisé entre le mois d’avril et le moi de mai. La liste doit être trié du plus ancien au plus récent.
SELECT * FROM rental
WHERE mONth(rental_date) in (4,5) and year(rental_date) = 2005
ORder by rental_date;

# 5.Lister les film dONt le nom ne commence pAS par le «Le».
SELECT film_id, title, release_year, length, rating
FROM film
WHERE title  not like 'LE%' 
   and title not like 'Le%';

# 6.Lister les films ayant la mentiON «PG-13» ou «NC-17». Ajouter une colONne qui affichera «oui» si «NC-17» et «nON» SinON.
SELECT film_id, title, dedescription, release_year, length, if(rating = 'NC-17','Oui','NON') AS NC_17 
FROM film
WHERE rating = 'NC-17' 
   OR  rating = 'PG-13';

# 7.Fournir la liste des catégORie qui commence par un ‘A’ ou un ‘C’. (Utiliser LEFT).
SELECT DISTINCT c.category_id, name
FROM category AS c LEFT JOIN film_category AS fc ON c.category_id = fc.category_id;

# 8.Lister les trois premiers caractères des noms des catégORie
SELECT LEFT(name,3) AS L3Name
FROM category;

# 9.Lister les premiers acteurs en remplaçant dans leur prenomles E par des A.
SELECT actor_id, first_name, concat(replace(left(first_name, 1), 'E', 'A'), right(first_name, length(first_name)-1)) AS prenom
FROM actor
WHERE first_name like 'E%'
LIMIT 5;

#JOINTURES
#1.Lister les 10 premiers films ainsi que leur langues.
select film_id, title, name
from film as f left join language as l on f.language_id = l.language_id
LIMIT 10;

#2.Afficher les film dans les quel à joué «JENNIFER DAVIS» sortie en 2006.
SELECT f.film_id, title
FROM film as f join film_actor as fa on f.film_id = fa.film_id 
	join actor as a on fa.actor_id = a.actor_id
WHERE first_name like 'JENNIFER' 
   and last_name like 'DAVIS'
   and release_year = 2006;
   
#3.Afficher le noms des client ayant emprunté «ALABAMA DEVIL».
SELECT c.first_name, c.last_name
FROM customer as c JOIN rental as r on c.customer_id = r.customer_id
	join inventory as i on r.inventory_id = i.inventory_id 
    join film as f on i.film_id = f.film_id
WHERE title = 'ALABAMA DEVIL';

#4.Afficher les films louer par des personne habitant à «Woodridge». Vérifié s’il y a des films qui n’ont jamais été emprunté.
SELECT f.film_id, title
FROM film as f join inventory as i on f.film_id = i.film_id
	join rental as r on r.inventory_id = i.inventory_id 
    join customer as c on c.customer_id = r.customer_id
	join address as a on  c.address_id = a.address_id
    join city as ct on a.city_id = ct.city_id
WHERE city = 'Woodridge';

#5.Quel sont les 10 films dont la durée d’emprunt à été la plus courte ?
SELECT f.film_id, title, datediff(return_date,rental_date) as duration_loc
FROM film as f join inventory as i on f.film_id = i.film_id
	join rental as r on i.inventory_id = r.inventory_id
WHERE return_date is not null
ORDER BY datediff(return_date,rental_date)
LIMIT 10;

#6.Lister les films de la catégorie «Action» ordonnés par ordre alphabétique.
SELECT f.film_id, title, description, rating, length
FROM film as f join film_category as fc on f.film_id = fc.film_id
	join category as c on fc.category_id = c.category_id
WHERE c.name = 'Action'
ORDER BY title;

#7.Quel sont les films dont la duré d’emprunt à été inférieur à 2 jour ?
SELECT distinct f.film_id, title, description, rating, length
FROM film as f join inventory as i on f.film_id = i.film_id
	join rental as r on i.inventory_id = r.inventory_id
WHERE return_date is not null 
	and datediff(return_date,rental_date) < 2;
    
#AGGREATION - fichier 18
#1. Afficher le nombre de films dans les quels à joué l'acteur «JOHNNY LOLLOBRIGIDA», regroupé par catégorie.
SELECT c.category_id, name, count(f.film_id) as Qty_films
FROM category as c join film_category as fc on c.category_id = fc.category_id
	join film as f on fc.film_id = f.film_id
    join film_actor as fa on f.film_id = fc.film_id
    join actor as a on fa.actor_id = a.actor_id
WHERE a.first_name = 'JOHNNY' 
	and a.last_name = 'LOLLOBRIGIDA'
GROUP BY c.category_id, name;

#2. Ecrire la requête qui affiche les catégories dans les quels «JOHNNY LOLLOBRIGIDA» totalise plus de 3 films.
SELECT c.category_id, name, count(f.film_id) as Qty_films
FROM category as c join film_category as fc on c.category_id = fc.category_id
	join film as f on fc.film_id = f.film_id
    join film_actor as fa on f.film_id = fc.film_id
    join actor as a on fa.actor_id = a.actor_id
WHERE a.first_name = 'JOHNNY' 
	and a.last_name = 'LOLLOBRIGIDA'
GROUP BY c.category_id, name
HAVING count(f.film_id) > 2000;

#3. Afficher la durée moyenne d'emprunt des films par acteurs.
SELECT  a.actor_id, a.first_name, a.last_name, avg(datediff(if(isnull(return_date), 0, return_date),rental_date)) as moyen_day_loction
FROM film as f join film_actor as fa on f.film_id = fa.film_id
	join actor as a on fa.actor_id = a.actor_id
    join inventory as i on f.film_id = i.film_id
    join rental as r on i.inventory_id = r.inventory_id
GROUP BY a.actor_id, a.first_name, a.last_name;

#4. L'argent total dépensé au vidéos club par chaque clients, classé par ordre décroissant.
SELECT a.address as 'club', first_name, last_name, sum(p.amount) as 'total'
FROM customer as c join payment as p on c.customer_id = p.customer_id
	join store as s on c.store_id = s.store_id
    join address as a on a.address_id = s.address_id
GROUP BY a.address, first_name, last_name
order by sum(p.amount);

