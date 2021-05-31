use sakila;

#1. vérifier que Vietnam est présenté dans DB, table country
SELECT country_id
FROM country
WHERE country = 'Vietnam';

SELECT *
FROM city
WHERE country_id = (
	SELECT country_id
	FROM country
	WHERE country = 'Vietnam');
#verifie que city Hue est dans la table city
SELECT *
FROM city
WHERE city = 'Hue' AND country_id = (
	SELECT country_id
	FROM country
	WHERE country = 'Vietnam');
INSERT INTO `sakila`.`city`
(
`city`,
`country_id`,
`last_update`)
VALUES
(
'Hue',
country_id = 105, now()
);

#Insére un film avec au moins 2 acteur/actrice
INSERT INTO `sakila`.`film` (`title`, `description`, `release_year`, `language_id`, `original_language_id`, `special_features` )
VALUES ('Les Enfants du temps',
'Jeune lycéen, Hodaka fuit son île pour rejoindre Tokyo. Sans argent ni emploi, il tente de survivre dans la jungle urbaine et trouve un poste dans une revue dédiée au paranormal',
2019, 1, 3, 'Trailers,Commentaries');

INSERT INTO `sakila`.`actor` (`first_name`, `last_name`)
VALUES ('Karato', 'Dairo'),
	('Nana', 'Nori'),
    ('Chieko', 'Baisho');
SELECT * from actor;
INSERT INTO `sakila`.`film_actor` (`actor_id`, `film_id` )
VALUES 
	(201,1001),
	(202,1001),
	(203,1001);


SELECT * from film_actor where film_id = 1001;

use sakila;

select * from city 
where country_id = 34
 ;
 
 select * from address order by address_id desc limit 1
 ;

SELECT 
    store_id, a.address_id, address
FROM
    store AS s
        INNER JOIN
    address AS a ON s.address_id = a.address_id;
SELECT store_id, a.address_id, address FROM store AS s INNER JOIN address AS a ON s.address_id = a.address_id;
select * from address order by address_id desc limit 6;
select * from customer order by customer_id desc limit 6;

SELECT first_name, last_name, rental_date, f.film_id, title, timediff(if(return_date is null,0, return_date),rental_date)/(24*60*60)  as nb_days
FROM customer AS c LEFT JOIN rental AS r ON c.customer_id = r.customer_id
JOIN inventory AS i ON r.inventory_id = i.inventory_id
JOIN film AS f ON i.film_id = f.film_id
WHERE first_name REGEXP '.*yan.*' OR last_name REGEXP '.*yan.*';