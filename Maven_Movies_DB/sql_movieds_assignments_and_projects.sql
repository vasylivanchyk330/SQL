USE mavenmovies;
SELECT * FROM rental;
/*
CONTENT:
	1. ASSIGNMENTS 1. (Basics)
    2. PROJECT 1
    3. ASSIGNMENTS 2. (Analyzing Multiple Tables with Joins)
    4. PROJECT 2
*/ 

#=================================================================
####################### 1. ASSIGNMENTS 1 ######################

SELECT first_name, last_name, email
FROM customer;

SELECT DISTINCT
	rental_duration
FROM film;

SELECT *
FROM payment
WHERE customer_id < 101;

SELECT *
FROM payment
WHERE customer_id < 101
AND amount >= 5
AND payment_date > '2006-01-01';

SELECT *
FROM payment
WHERE customer_id IN (42, 53, 60, 75)
OR amount > 5;

SELECT title, special_features
FROM film
WHERE special_features LIKE '%Behind the Scene%';

SELECT rating, COUNT(film_id) as cnt
FROM film
GROUP BY rating;

SELECT rental_duration, COUNT(title) as films_with_this_rental_duration
FROM film
GROUP BY rental_duration;

SELECT 
	replacement_cost,
	COUNT(title) as number_of_films, 
	ROUND(AVG(rental_rate),2) as average_rental,
    MIN(rental_rate) as cheapest_rental,
	MAX(rental_rate) as most_expensive_rental
FROM film
GROUP BY replacement_cost;

SELECT 
	customer_id, 
    COUNT(rental_id) as number_of_rentals
FROM rental
GROUP BY customer_id
HAVING COUNT(rental_id) < 15;

SELECT 
	title,
    length,
    rental_rate
FROM film
ORDER BY length DESC;

SELECT 
	first_name,
    last_name,
    CASE 
		WHEN store_id="1" and active="1" THEN "store 1 active"
        WHEN store_id="1" and active="0" THEN "store 1 inactive"
        WHEN store_id="2" and active="1" THEN "store 2 active"
        WHEN store_id="2" and active="0" THEN "store 2 inactive"
        ELSE "check logic!!!"
	END AS store_and_status
FROM customer;

SELECT 
	*
FROM staff;

SELECT
	store_id,
    COUNT(CASE WHEN active="1" THEN customer_id ELSE NULL END) AS active,
    COUNT(CASE WHEN active="0" THEN customer_id ELSE NULL END) AS inactive
FROM customer
GROUP BY store_id;



#================================================================================
####################### 2. PROJECT 1 ######################
/*
1.	We will need a list of all staff members, including their first and last names, 
email addresses, and the store identification number where they work. 
*/ 
SELECT 
	staff_id,
    first_name,
    last_name,
    email,
    store_id
FROM staff;


/*
2.	We will need separate counts of inventory items held at each of your two stores. 
*/ 
SELECT 
	store_id,
	COUNT(inventory_id) AS counts_of_inventory
FROM inventory
GROUP BY store_id;


/*
3.	We will need a count of active customers for each of your stores. Separately, please. 
*/
SELECT 
	store_id,
	COUNT(CASE WHEN active="1" THEN customer_id ELSE NULL END) AS active_customers
FROM customer
GROUP BY store_id;


/*
4.	In order to assess the liability of a data breach, we will need you to provide a count 
of all customer email addresses stored in the database. 
*/
SELECT 
	COUNT(email) AS email_count
FROM customer;


/*
5.	We are interested in how diverse your film offering is as a means of understanding how likely 
you are to keep customers engaged in the future. Please provide a count of unique film titles 
you have in inventory at each store and then provide a count of the unique categories of films you provide. 
*/
SELECT 
	store_id,
	COUNT(DISTINCT film_id) AS unique_films
FROM inventory
GROUP BY store_id;

SELECT 
	COUNT(DISTINCT name) AS unique_categories
FROM category;


/*
6.	We would like to understand the replacement cost of your films. 
Please provide the replacement cost for the film that is least expensive to replace, 
the most expensive to replace, and the average of all films you carry. ``	
*/
SELECT 
	MAX(replacement_cost) AS film_most_expensive_to_replace,
    MIN(replacement_cost) AS film_least_expensive_to_replace,
    AVG(replacement_cost) as avg_to_replace
FROM film;


/*
7.	We are interested in having you put payment monitoring systems and maximum payment 
processing restrictions in place in order to minimize the future risk of fraud by your staff. 
Please provide the average payment you process, as well as the maximum payment you have processed.
*/

SELECT 
	MAX(amount) AS max_payment,
    AVG(amount) AS avg_payment
FROM payment;



/*
8.	We would like to better understand what your customer base looks like. 
Please provide a list of all customer identification values, with a count of rentals 
they have made all-time, with your highest volume customers at the top of the list.
*/
SELECT 
	DISTINCT customer_id,
    COUNT(rental_id) as rental_count
FROM rental
GROUP BY customer_id
ORDER BY rental_count DESC;



#===================================================================================
################## 3. ASSAGNMENTS 2 ######################

#INNER JOIN
SELECT 
	i.store_id,
    i.inventory_id,
	f.title,
    f.description
FROM film as f
	INNER JOIN inventory as i
		ON f.film_id=i.film_id;

# LEFT JOIN
SELECT
	f.title,
    COUNT(fa.actor_id) AS number_of_actors
FROM film as f
	LEFT JOIN film_actor as fa
		ON f.film_id=fa.film_id
GROUP BY f.title;

#"Bridging" Tables
SELECT
	a.first_name,
    a.last_name,
    f.title
FROM film as f
	INNER JOIN film_actor as fa
		ON f.film_id=fa.film_id
    INNER JOIN actor as a
		ON fa.actor_id=a.actor_id
ORDER BY a.last_name;

# Multi-Condition Joins
SELECT
	DISTINCT f.title,
    f.description
FROM film as f
	INNER JOIN inventory as i
		ON f.film_id=i.film_id
        AND store_id='2';
        

# UNION
SELECT
	"advisor" as type,
	ad.first_name,
    ad.last_name
FROM advisor AS ad
UNION
SELECT
	"staff" as type,
	st.first_name,
    st.last_name
FROM staff as st;


#===================================================================================
################## 4. PROJECT 2 ######################
/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 
SELECT 
	stf.first_name,
    stf.last_name,
    str.store_id,
    ad.address,
    ad.address2,
    ad.district,
    ct.city,
    cntr.country
FROM staff as stf
	INNER JOIN store as str
		ON stf.store_id=str.store_id
	INNER JOIN address as ad
		ON str.address_id=ad.address_id
	INNER JOIN city as ct
		ON ad.city_id=ct.city_id
	INNER JOIN country as cntr
		ON ct.country_id=cntr.country_id
;

	
/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/
SELECT
	i.store_id,
	i.inventory_id,
    f.title,
    f.rating,
    f.rental_rate,
    f.replacement_cost
FROM film as f
	LEFT JOIN inventory as i
		ON f.film_id=i.film_id
;


/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/
SELECT
	i.store_id,
    f.rating,
    COUNT(i.inventory_id) as inventory_items 
FROM film as f
	LEFT JOIN inventory as i
		ON f.film_id=i.film_id
GROUP BY i.store_id, f.rating
;



/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 
SELECT
	i.store_id,
    COUNT(f.title) as film_amount,
    c.name as category,
    AVG(f.replacement_cost) as avg_replacement_cost,
    SUM(f.replacement_cost) as total_replacement_cost
FROM inventory as i
	LEFT JOIN film as f
		ON i.film_id=f.film_id
	LEFT JOIN film_category as fc
		ON f.film_id=fc.film_id
	INNER JOIN category as c
		ON fc.category_id=c.category_id
GROUP BY i.store_id, c.name
;


/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/
SELECT
	cus.first_name,
    cus.last_name,
    cus.store_id, 
    cus.active,
    ad.address,
    ad.address2,
    ad.district,
    ct.city,
    cntr.country
FROM customer as cus
	LEFT JOIN address as ad
		ON cus.address_id=ad.address_id
	LEFT JOIN city as ct
		ON ad.city_id=ct.city_id
	LEFT JOIN country as cntr
		ON ct.country_id=cntr.country_id
ORDER BY cus.last_name
;


/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/
SELECT
	cus.first_name,
    cus.last_name,
    cus.store_id,
    COUNT(r.rental_id) as total_rentals,
    SUM(pay.amount) as payment_total
FROM customer as cus
	RIGHT JOIN rental as r
		ON cus.customer_id=r.customer_id
	LEFT JOIN payment as pay
		ON r.rental_id=pay.rental_id
GROUP BY cus.first_name, cus.last_name
ORDER BY payment_total DESC;


/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/
SELECT
	"advisor" as type,
	ad.first_name,
    ad.last_name,
    NULL as company
FROM advisor AS ad
UNION
SELECT
	"investor" as type,
	i.first_name,
    i.last_name,
    i.company_name as company
FROM investor as i;


/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/
#found on stackoverflow
DELIMITER $$
	CREATE FUNCTION wordcount(str TEXT)
            RETURNS INT
            DETERMINISTIC
            SQL SECURITY INVOKER
            NO SQL
       BEGIN
         DECLARE wordCnt, idx, maxIdx INT DEFAULT 0;
         DECLARE currChar, prevChar BOOL DEFAULT 0;
         SET maxIdx=char_length(str);
         WHILE idx < maxIdx DO
             SET currChar=SUBSTRING(str, idx, 1) RLIKE '[[:alnum:]]';
             IF NOT prevChar AND currChar THEN
                 SET wordCnt=wordCnt+1;
             END IF;
             SET prevChar=currChar;
             SET idx=idx+1;
         END WHILE;
         RETURN wordCnt;
       END
     $$
DELIMITER ;

SELECT 
	CASE
		WHEN wordcount(aa.awards)="3" THEN "3 awards"
        WHEN wordcount(aa.awards)="2" THEN "2 awards"
        WHEN wordcount(aa.awards)="1" THEN "1 award"
		ELSE "error! check the logic!"
	END AS number_awords,
	AVG(CASE WHEN aa.actor_id IS NULL THEN 0 ELSE 1 END) AS percentage	
FROM actor_award as aa
GROUP BY number_awords;
