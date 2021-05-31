use sakila;

#1- Afficher les 10 locations les plus longues (nom/prenom client, film, video club, durée)
SELECT first_name, last_name, a.address as 'club', title, timediff(if(return_date is null,0, return_date),rental_date)/(24*60*60) as duree
FROM customer as c join rental as r on c.customer_id = r.customer_id
	join inventory as i on  r.inventory_id = i.inventory_id
    join film as f on i.film_id = f.film_id
    join store on c.store_id = store.store_id
    join address as a on store.address_id = a.address_id
ORDER BY timediff(if(return_date is null,0, return_date),rental_date) DESC
LIMIT 10;

# 2- Afficher les 10 meilleurs clients actifs par montant dépensé (nom/prénom client, montant dépensé)
SELECT first_name, last_name, sum(amount) as 'total_depense'
FROM customer join payment on customer.customer_id = payment.customer_id
GROUP BY  first_name, last_name
ORDER BY sum(amount) DESC
LIMIT 10;

# 3- Afficher la durée moyenne de location par film triée de manière descendante
SELECT avg(timediff(return_date,rental_date))/(24*60*60) as 'average_days', f.film_id, title
FROM film as f join inventory as i on f.film_id = i.film_id
	join rental as r on i.inventory_id = r.inventory_id
GROUP BY f.film_id, title
ORDER BY avg(timediff(return_date,rental_date))/(24*60*60) DESC ;
#sol2
SELECT round(avg(datediff(return_date,rental_date)),2) as 'average_days', f.film_id, title
FROM film as f join inventory as i on f.film_id = i.film_id
	join rental as r on i.inventory_id = r.inventory_id
GROUP BY f.film_id, title
ORDER BY round(avg(datediff(return_date,rental_date)),2) DESC ;
#NE PAS utilise alias de colonne d'aggreation dans ORDER BY, si non ne marche pas

#CHeck list de film n'ai personne joué ou 
#Sol 1
SELECT *
FROM film
WHERE film_id not IN (
	SELECT distinct film_id
    FROM film_actor) ;
SELECT *
#Sol 2
FROM film left join (
	SELECT distinct film_id
    FROM film_actor) as fa on film.film_id =  fa.film_id
WHERE fa.film_id is null;
# list d'actor ne joue aucun films
SELECT *
FROM actor
WHERE actor_id not IN (
	SELECT distinct actor_id
    FROM film_actor) ;

# 4- Afficher tous les films n'ayant jamais été empruntés
SELECT film.film_id, title, description
FROM film
WHERE film.film_id NOT IN (
	SELECT distinct film_id
    FROM inventory as i join rental as r on i.inventory_id = r.inventory_id);
    
SELECT f.film_id, title, description
FROM film as f left join (
	SELECT distinct film_id
    FROM inventory as i join rental as r on i.inventory_id = r.inventory_id) as a on f.film_id = a.film_id 
WHERE a.film_id is null;

SELECT f.film_id, title, description
FROM film as f 
WHERE NOT EXISTS (
	SELECT *
    FROM inventory as i join rental as r on i.inventory_id = r.inventory_id
    WHERE f.film_id = film_id) ; 

# 5- Afficher le nombre d'employés (staff) par video club
SELECT st.store_id, a.address, count(*)
FROM store as st join address as a on st.address_id = a.address_id
	join staff as s on st.manager_staff_id = s.staff_id 
GROUP BY st.store_id, a.address;

# 6- Afficher les 10 villes avec le plus de video clubs
SELECT ct.city_id, ct.city, count(s.store_id) as Qty_club 
FROM city as ct join address as a on ct.city_id = a.city_id
	 join store as s on a.address_id = s.address_id
GROUP BY ct.city_id, ct.city
ORDER BY Qty_club DESC
LIMIT 10;

# 7- Afficher le film le plus long dans lequel joue Johnny Lollobrigida
SELECT f.film_id, title, length 
FROM film as f
WHERE f.film_id IN (
	SELECT DISTINCT film_id
    FROM film_actor as fa join actor as a on fa.actor_id = a.actor_id
    WHERE first_name = upper('Johnny') 
		and last_name = upper('Lollobrigida') )
ORDER BY length DESC 
LIMIT 1;

SELECT f.film_id, title, length 
FROM film as f
WHERE EXISTS (
	SELECT DISTINCT film_id
    FROM film_actor as fa join actor as a on fa.actor_id = a.actor_id
    WHERE first_name = upper('Johnny') 
		and last_name = upper('Lollobrigida') 
        and f.film_id = film_id)
ORDER BY length DESC 
LIMIT 1;

# 8- Afficher le temps moyen de location du film 'Academy dinosaur'
SELECT f.film_id, title, round(avg(datediff(if(return_date is null,0, return_date),rental_date)), 2) as 'average_days' 
FROM film as f join inventory as i on f.film_id = i.film_id
	join rental as r on i.inventory_id = r.inventory_id
WHERE title = 'Academy dinosaur'
GROUP BY f.film_id, title ;

# 9- Afficher les films avec plus de deux exemplaires en inventaire (store id, titre du film, nombre d'exemplaires)

SELECT i.store_id, title, count(i.inventory_id) as 'nb_exemplaires'
FROM  inventory as i 
	join film as f on f.film_id = i.film_id
GROUP BY i.store_id, title
HAVING nb_exemplaires > 2;

# 10- Lister les films contenant 'din' dans le titre
SELECT *
FROM film
WHERE title like '%din%' ; 

# 11- Lister les 5 films les plus empruntés
SELECT count(r.rental_id) as 'qty_location', f.film_id, title
FROM film as f join inventory as i on f.film_id = i.film_id
	join rental as r on i.inventory_id = r.inventory_id
GROUP BY film_id, title
ORDER BY count(r.rental_id) DESC
LIMIT 5 ;

# 12- Lister les films sortis en 2003, 2005 et 2006
SELECT film_id, title, release_year
FROM film
WHERE release_year IN (2003, 2005, 2006);

# 13- Afficher les films ayant été empruntés mais n'ayant pas encore été restitués, triés par date d'emprunt.
# Afficher seulement les 10 premiers.
SELECT f.film_id, title, rental_date
FROM film as f inner join inventory as i on f.film_id = i.film_id
	inner join rental as r on i.inventory_id = r.inventory_id
WHERE return_date is null
ORDER BY rental_date
LIMIT 10;

# 14- Afficher les films d'action durant plus de 2h
SELECT f.film_id, title, length
FROM film as f join film_category as cf on f.film_id = cf.film_id
	join category as c on cf.category_id = c.category_id
WHERE name = 'action' 
	and length > 120;
    
# 15- Afficher tous les utilisateurs ayant emprunté des films avec la mention NC-17
SELECT distinct c.*
FROM customer as c join rental as r on c.customer_id = r.customer_id
	join inventory as i on r.inventory_id = i.inventory_id
 WHERE i.film_id IN 
		( SELECT film_id
			FROM film
			WHERE rating = 'NC-17') ;

# 16- Afficher les films d'animation dont la langue originale est l'anglais
SELECT f.film_id, title, length, language_id
FROM film as f inner join film_category as cf on f.film_id = cf.film_id
	inner join category as c on cf.category_id = c.category_id
WHERE name = 'Animation' 
	and language_id = (
		SELECT language_id
        FROM language
        WHERE upper(name) = 'ENGLISH');
     
#original_language_id is NULL, emply
SELECT f.film_id, title, length, original_language_id
FROM film as f join film_category as cf on f.film_id = cf.film_id
	join category as c on cf.category_id = c.category_id
WHERE name = 'Animation' 
	and original_language_id = (
		SELECT language_id
        FROM language
        WHERE upper(name) = 'ENGLISH');

# 17- Afficher les films dans lesquels une actrice nommée Jennifer a joué (bonus: en même temps qu'un acteur nommé Johnny)
SELECT f.film_id, title, length 
FROM film as f
WHERE EXISTS (
	SELECT DISTINCT film_id
    FROM film_actor as fa join actor as a on fa.actor_id = a.actor_id
    WHERE first_name = upper('Johnny') 
		 and f.film_id = film_id)
	and EXISTS (
		SELECT DISTINCT film_id
		FROM film_actor as fa join actor as a on fa.actor_id = a.actor_id
		WHERE first_name = upper('Jennifer') 
			 and f.film_id = film_id)
;

#Sol2
SELECT f.film_id, title, length 
FROM film as f
WHERE f.film_id in (
	SELECT film_id
    FROM film_actor as fa join actor as a on fa.actor_id = a.actor_id
    WHERE first_name = upper('Johnny') )
AND f.film_id in (
    SELECT film_id
		FROM film_actor as fa join actor as a on fa.actor_id = a.actor_id
		WHERE first_name = upper('Jennifer') );

# 18- Quelles sont les 3 catégories les plus empruntées?
SELECT c.category_id, name, count(r.rental_id) as 'Qty_location'
FROM category as c join film_category as fc on c.category_id = fc.category_id
	 join film as f on fc.film_id = f.film_id
     join inventory as i on f.film_id = i.film_id
     join rental as r on i.inventory_id = r.inventory_id
GROUP BY c.category_id, name
ORDER BY count(r.rental_id) DESC
LIMIT 3;
#sol count(*) -> MAIS moins de performance
SELECT c.category_id, name, count(*) as 'Qty_location'
FROM category as c join film_category as fc on c.category_id = fc.category_id
	 join film as f on fc.film_id = f.film_id
     join inventory as i on f.film_id = i.film_id
     join rental as r on i.inventory_id = r.inventory_id
GROUP BY c.category_id, name
ORDER BY count(*) DESC
LIMIT 3;

# 19- Quelles sont les 10 villes où on a fait le plus de locations?
#par ville résident du client
SELECT city, count(*) as 'Nombre de location'
FROM city as c join address as a on c.city_id = a.city_id
	join customer as cu on a.address_id = cu.address_id
    join rental as r on cu.customer_id = r.customer_id
GROUP BY city 
ORDER BY count(*) DESC 
LIMIT 10;

#par city de store
SELECT city, count(rental_id) as 'Nombre de location'
FROM city as c join address as a on c.city_id = a.city_id
	join store as s on a.address_id = s.address_id
    join inventory as i on s.store_id = i.store_id
    join rental as r on i.inventory_id = r.inventory_id
GROUP BY city 
ORDER BY count(rental_id) DESC 
LIMIT 10;

# 20- Lister les acteurs ayant joué dans au moins 1 film
SELECT a.actor_id, first_name, last_name, count(fa.film_id) as 'nb_film_joue'
FROM actor as a join film_actor as fa on a.actor_id = fa.actor_id
GROUP BY a.actor_id, first_name, last_name 
HAVING count(fa.film_id) > 30;


