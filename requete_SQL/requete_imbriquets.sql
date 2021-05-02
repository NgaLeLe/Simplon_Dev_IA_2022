use sakila;

# Affichez les titres des films ayant pour catégorie 'action', 
# sauf ceux qui ne sont plus présents en inventaire
SELECT title 
FROM film AS f
JOIN film_category AS fc ON f.film_id = fc.film_id
JOIN category AS c ON c.category_id = fc.category_id
WHERE name = 'Action'
AND title NOT IN (
	SELECT DISTINCT title 
	FROM film AS f
	JOIN inventory as i ON f.film_id = i.film_id  ) ;

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
	FROM (
		SELECT count(fc.actor_id) as nb_film
		FROM film AS f1
		JOIN film_actor AS fc1 ON f1.film_id = fc1.film_id
		GROUP BY f1.film_id  ) 
   );

#4. Afficher les acteurs ayant joué uniquement dans des films d’actions (Utiliser EXISTS).
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

#appeller une procedure stocké
CALL prod_Anciennete('Mary', 'Smith', @anciennete);

#afficher le resultat
SELECT @anciennete

CALL `sakila`.`rewards_report`(<{IN min_monthly_purchases TINYINT UNSIGNED}>, <{IN min_dollar_amount_purchased DECIMAL(10,2)}>, <{OUT count_rewardees INT}>);
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `rewards_report`(
    IN min_monthly_purchases TINYINT UNSIGNED
    , IN min_dollar_amount_purchased DECIMAL(10,2)
    , OUT count_rewardees INT
)
    READS SQL DATA
    COMMENT 'Provides a customizable report on best customers'
proc: BEGIN

    DECLARE last_month_start DATE;
    DECLARE last_month_end DATE;

    
    IF min_monthly_purchases = 0 THEN
        SELECT 'Minimum monthly purchases parameter must be > 0';
        LEAVE proc;
    END IF;
    IF min_dollar_amount_purchased = 0.00 THEN
        SELECT 'Minimum monthly dollar amount purchased parameter must be > $0.00';
        LEAVE proc;
    END IF;

    
    SET last_month_start = DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH);
    SET last_month_start = STR_TO_DATE(CONCAT(YEAR(last_month_start),'-',MONTH(last_month_start),'-01'),'%Y-%m-%d');
    SET last_month_end = LAST_DAY(last_month_start);

    
    CREATE TEMPORARY TABLE tmpCustomer (customer_id SMALLINT UNSIGNED NOT NULL PRIMARY KEY);

    
    INSERT INTO tmpCustomer (customer_id)
    SELECT p.customer_id
    FROM payment AS p
    WHERE DATE(p.payment_date) BETWEEN last_month_start AND last_month_end
    GROUP BY customer_id
    HAVING SUM(p.amount) > min_dollar_amount_purchased
    AND COUNT(customer_id) > min_monthly_purchases;

    
    SELECT COUNT(*) FROM tmpCustomer INTO count_rewardees;

    
    SELECT c.*
    FROM tmpCustomer AS t
    INNER JOIN customer AS c ON t.customer_id = c.customer_id;

    
    DROP TABLE tmpCustomer;
END$$
DELIMITER ;

