
--Average rating for apps on both stores--

SELECT a.name AS a_name, p.name AS p_name,
ROUND((a.rating + p.rating) / 2,2) AS average_rating
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name = p.name
ORDER BY average_rating DESC;


--Looking at which ones are free on both stores--

SELECT DISTINCT a.name AS a_name, p.name AS p_name, a.price AS a_price, p.price AS p_price,
  ROUND((a.rating + p.rating) / 2, 2) AS average_rating
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name = p.name
WHERE (a.price = 0 AND p.price = '0')
   OR (a.price = 0.99 AND p.price = '0.99')
ORDER BY average_rating DESC;




--Trying to figure out what apps to target--
SELECT
    a.name AS app_name,
    a.price AS app_price,
    a.rating AS app_rating,
    a.content_rating AS app_content_rating,
    a.primary_genre AS app_genre,
    CASE
        WHEN a.price <= 1.00 THEN 10000  -- Purchase price
        ELSE 10000  -- Purchase price for apps > $1.00--
    END AS purchase_price,
    CASE
        WHEN a.price <= 1.00 THEN 1000  -- Monthly marketing cost
        ELSE 1000  -- Monthly marketing cost for apps > $1.00--
    END AS marketing_cost,
    CASE
        WHEN a.price <= 1.00 THEN 5000  -- Monthly revenue per app store
        ELSE 5000  -- Monthly revenue per app store for apps > $1.00--
    END AS monthly_revenue_per_store,
    CASE
        WHEN a.price <= 1.00 THEN 10000  -- Monthly revenue for both stores
        ELSE 10000  -- Monthly revenue for both stores for apps > $1.00--
    END AS monthly_revenue_both_stores,
    ROUND((a.rating + p.rating) / 2, 1) AS average_rating,  -- Average rating from both stores--
    CASE
        WHEN ROUND((a.rating + p.rating) / 2, 1) = 0.0 THEN 1  -- Projected lifespan--
        WHEN ROUND((a.rating + p.rating) / 2, 1) = 1.0 THEN 3
        ELSE 9
    END AS projected_lifespan,
    CASE
        WHEN a.price <= 1.00 THEN (10000 - 1000) * 12 / 2  -- Yearly profit per store--
        ELSE (10000 - 1000) * 12 / 2
    END AS yearly_profit_per_store,
    CASE
        WHEN a.price <= 1.00 THEN (10000 - 1000) * 12 / 2 * 2  -- Yearly profit for both stores--
        ELSE (10000 - 1000) * 12 / 2 * 2
    END AS yearly_profit_both_stores
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p ON a.name = p.name
WHERE a.price <= 1.00  -- Criteria for apps that App Trader should target--
ORDER BY yearly_profit_both_stores DESC;



--Practicing simple cte--
WITH iso_cte AS
(SELECT DISTINCT content_rating
FROM app_store_apps
ORDER BY content_rating DESC),

droid_cte AS 
(SELECT DISTINCT content_rating
FROM play_store_apps
ORDER BY content_rating)

SELECT *
FROM iso_cte
FULL JOIN droid_cte
USING (content_rating);



--All apps from both stores priced 0-1--
WITH CombinedApps AS (
    SELECT name, 
           CASE 
               WHEN price = '0' THEN 0.0
               WHEN price = '$0.99' THEN 0.99
           END AS price
    FROM play_store_apps
    WHERE price = '0' OR price = '$0.99'

    UNION

    SELECT name, 
           CASE 
               WHEN price = 0 THEN 0.0
               WHEN price = 0.99 THEN 0.99
           END AS price
    FROM app_store_apps
    WHERE price = 0 OR price = 0.99
)
SELECT name, price
FROM CombinedApps
ORDER BY price ASC;



--FINAL QUERY--

WITH cte AS --Finding the cost of the apps on each store, and which price is higher--
	(SELECT DISTINCT p.name AS app_name,
	ROUND((p.rating+a.rating) /2, 1) AS avg_rating,
	CASE
		WHEN (REPLACE(p.price, '$', '')::MONEY) > CAST(a.price AS MONEY)
		THEN (REPLACE(p.price, '$', '')::MONEY)
		ELSE CAST(a.price AS MONEY)
	END AS higher_price,
	(replace(p.price, '$', '')::MONEY) play_store_price,
	CAST(a.price AS MONEY) app_store_price
FROM play_store_apps AS p
JOIN app_store_apps a 
	 USING(name)),
	 
cte1 AS --Finding the higher price of the two stores--
	(SELECT app_name, avg_rating, higher_price, play_store_price, app_store_price,
		CASE
			WHEN higher_price >1.00::MONEY
			THEN CAST((higher_price::NUMERIC * 10000)AS MONEY)
			ELSE 1000::MONEY
			END AS purchase_price,
		FLOOR((avg_rating/0.5)+1)AS longevity_in_years
	FROM cte),
	
cte2 AS --Finding the gross and net profit--
	(SELECT app_name, avg_rating, higher_price, play_store_price, app_store_price, purchase_price, longevity_in_years,
	(longevity_in_years * 10000)::MONEY AS gross_profit,
	(longevity_in_years * 10000)::MONEY - purchase_price AS net_profit
	FROM cte1
	ORDER BY gross_profit DESC, purchase_price ASC)
SELECT * FROM cte2
ORDER BY net_profit DESC, avg_rating DESC;


