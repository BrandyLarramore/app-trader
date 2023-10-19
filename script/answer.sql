--2. Assumptions
--Based on research completed prior to launching App Trader as a company, you can assume the following:
--a. App Trader will purchase apps for 10,000 times the price of the app. For apps that are priced from free up to $1.00, the purchase price is $10,000.
--For example, an app that costs $2.00 will be purchased for $20,000.
-- The cost of an app is not affected by how many app stores it is on. A $1.00 app on the Apple app store will cost the same as a $1.00 app on both stores. 
-- If an app is on both stores, it's purchase price will be calculated based off of the highest app price between the two stores. 
--b. Apps earn $5000 per month, per app store it is on, from in-app advertising and in-app purchases, regardless of the price of the app.
--An app that costs $200,000 will make the same per month as an app that costs $1.00. 
--An app that is on both app stores will make $10,000 per month. 

SELECT
DISTINCT app_store_apps.name,
--did this to eliminate duplicate play store apps
app_store_apps.primary_genre,
CASE 
	WHEN play_store_apps.rating > app_store_apps.rating
	THEN play_store_apps.rating
	ELSE app_store_apps.rating
	END AS greater_rating,
--did this to only display the highest app rating between the two
CAST
	(app_store_apps.review_count AS integer) AS ios_review_integer,
--did this to take this from text to integer
SUM(play_store_apps.review_count) AS android_review_count,
--did this to combine all the similar play store review counts
CASE
			WHEN CAST(app_store_apps.price AS money) > CAST(play_store_apps.price AS money)
			 THEN CAST(app_store_apps.price AS money)
			 ELSE CAST(play_store_apps.price AS money)
			 END AS greater_price
			 --did this to only display the highest app price between the two
FROM app_store_apps
INNER JOIN play_store_apps
USING (name)
WHERE play_store_apps.rating> (SELECT round(AVG(rating), 2)+.01
FROM play_store_apps)
--figured the avg 
	AND app_store_apps.rating>(SELECT round(AVG(rating), 2)+.01
FROM app_store_apps) 
--figured the avg
	AND play_store_apps.review_count>10000
	AND CAST
	(app_store_apps.review_count AS integer)>10000
GROUP BY DISTINCT app_store_apps.name, app_store_apps.primary_genre, greater_rating, ios_review_integer, greater_price
ORDER BY greater_rating DESC
LIMIT 10;
