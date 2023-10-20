
--AVERAGE RATING FOR APPS ON BOTH STORES--

SELECT ios.name AS iosname, android.name AS droidname,
ROUND((ios.rating + android.rating) / 2,2) AS average_rating
FROM app_store_apps AS ios
INNER JOIN play_store_apps AS android
ON ios.name = android.name
ORDER BY average_rating DESC;


--Looking at which ones are free on both stores--

SELECT DISTINCT ios.name AS iosname, droid.name AS droidname, ios.price AS ios_price, droid.price AS droid_price,
  ROUND((ios.rating + droid.rating) / 2, 2) AS average_rating
FROM app_store_apps AS ios
INNER JOIN play_store_apps AS droid
ON ios.name = droid.nameWHERE (ios.price = 0 AND droid.price = '0')
   OR (ios.price = 0.99 AND droid.price = '0.99')
ORDER BY average_rating DESC;
		
		
ORDER BY average_rating DESC;



find net profit and gross profit



SELECT name, average_rating
FROM app_store_apps AS ios











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





