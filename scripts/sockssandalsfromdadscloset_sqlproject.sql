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


