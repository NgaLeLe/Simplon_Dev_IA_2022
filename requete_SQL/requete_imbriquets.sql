# Affichez les titres des films ayant pour catégorie 'action', 
# sauf ceux qui ne sont plus présents en inventaire
use sakila;
SELECT title 
FROM film AS f
JOIN film_category AS fc ON f.film_id = fc.film_id
JOIN category AS c ON c.category_id = fc.category_id
WHERE name = 'Action'
AND title NOT IN (
SELECT DISTINCT title 
FROM film AS f
JOIN inventory as i ON f.film_id = i.film_id ) ;

#1. Avec une requête imbriquée sélectionner tout les acteurs ayant joués dans les films 
# ou a joué «MCCONAUGHEY CARY».
SELECT DISTINCT a1.*
FROM actor AS a1
JOIN film_actor AS fa1 ON a1.actor_id = fa1.actor_id
WHERE concat(upper(a1.first_name), ' ', upper(a1.last_name)) != 'CARY MCCONAUGHEY'
AND fa1.film_id IN (
	SELECT film_id
	FROM actor AS a
	JOIN film_actor AS fa ON a.actor_id = fa.actor_id
	WHERE concat(upper(first_name), ' ', upper(last_name)) = 'CARY MCCONAUGHEY');

#2. Afficher tout les acteurs n’ayant pas joués dans les films ou a joué «MCCONAUGHEY CARY»
SELECT DISTINCT a1.*
FROM actor AS a1
JOIN film_actor AS fa1 ON a1.actor_id = fa1.actor_id
WHERE concat(upper(a1.first_name), ' ', upper(a1.last_name)) != 'CARY MCCONAUGHEY'
AND fa1.film_id NOT IN (
	SELECT film_id
	FROM actor AS a
	JOIN film_actor AS fa ON a.actor_id = fa.actor_id
	WHERE concat(upper(first_name), ' ', upper(last_name)) = 'CARY MCCONAUGHEY');

#3. Afficher Uniquement le nom du film qui contient le plus d'acteur 
# et le nombre d'acteurs associé sans utiliser LIMIT (2 niveaux de sous requêtes)
SELECT f.film_id, title, count(f.film_id) as nb_actor
FROM film AS f
JOIN film_actor AS fc ON f.film_id = fc.film_id
GROUP BY f.film_id
HAVING nb_actor = (
	SELECT max(ls.nb_film)
	FROM (SELECT count(fc.actor_id) as nb_film
		FROM film AS f
		JOIN film_actor AS fc ON f.film_id = fc.film_id
		GROUP BY f.film_id) AS ls
   );

#3. Afficher les acteurs ayant joué uniquement dans des films d’actions (Utiliser EXISTS).
SELECT DISTINCT a.actor_id, first_name,last_name
FROM actor AS a
WHERE NOT EXISTS (
	SELECT *
	FROM film AS f2
	JOIN film_category AS fc ON f2.film_id = fc.film_id
	JOIN category AS c ON c.category_id = fc.category_id
    JOIN film_actor as fa ON fa.film_id = f2.film_id
	WHERE name != 'Action'
	AND a.actor_id = fa.actor_id);

