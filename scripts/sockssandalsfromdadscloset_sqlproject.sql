SELECT *
FROM app_store_apps
SELECT *
FROM play_store_apps


SELECT a.name,
	a.content_rating,
	a.price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING (name)
ORDER BY a.price DESC;

-- Average Rating For Apps in Both Stores --
SELECT DISTINCT a.name,
	((a.rating + p.rating)/2) AS avg_rating
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING (name)
ORDER BY avg_rating DESC;

-- Average rating for apps in both store + the apps with the highest price --
SELECT DISTINCT a.name,
	((a.rating + p.rating)/2) AS avg_rating,
CASE WHEN cast(replace(p.price, '$', '') as money) > cast(a.price as money)
		then cast(replace(p.price, '$', '') as money)
		else  cast(a.price as money)
	end as higher_price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING (name)
ORDER BY higher_price ASC,
avg_rating DESC
LIMIT 10;
	
-- For every half point that an app gains in rating, its projected lifespan increases by one year. In other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years.	
	
	
--Need a case statement for the price, subquery for multiple conditions for the WHERE ---