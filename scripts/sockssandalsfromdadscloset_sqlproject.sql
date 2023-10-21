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
with cte as (
	SELECT DISTINCT p.name as app_name,
	ROUND((a.rating + p.rating)/2,1) AS avg_rating,
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

WITH iso_cte AS
(SELECT DISTINCT content_rating
FROM app_store_apps
ORDER BY CONTENT_RATING DESC),
droid_cte AS
(SELECT DISTINCT content_rating
FROM play_store_apps
 ORDER BY content_rating DESC),
SELECT *
from iso_cte
FULL JOIN droid_cte
USING (content_rating)



SELECT DISTINCT CONTENT_RATING
from app_store_apps
order by content_rating
   
	
with cte as (	
	SELECT DISTINCT p.name as app_name,
	ROUND((a.rating + p.rating)/2,1) AS avg_rating,
CASE WHEN cast(replace(p.price, '$', '') as money) > cast(a.price as money)
		then cast(replace(p.price, '$', '') as money)
		else  cast(a.price as money)
	end as higher_price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING (name)),	
-- 2ND PART OF QUERY--
cte0 as(
	SELECT
    app_name,
	avg_rating,
	higher_price,
	play_store_price,
	app_store_price,
CASE WHEN higher_price > 1.00::money
then (higher_price::numeric * 10000)::money 
	ELSE 1000::money 
END AS purchase_price,
floor((avg_rating/.5)+1) as longevity_in_years
FROM ),