
--AVERAGE RATING FOR APPS ON BOTH STORES--

SELECT ios.name AS iosname, android.name AS droidname,
ROUND((ios.rating + android.rating) / 2,2) AS average_rating
FROM app_store_apps AS ios
INNER JOIN play_store_apps AS android
ON ios.name = android.name
ORDER BY average_rating DESC;


--Looking at which ones are free on both stores--

SELECT ios.name AS iosname, android.name AS droidname, ios.price AS ios_price, android.price AS droid_price,
  ROUND((ios.rating + android.rating) / 2,2) AS average_rating
FROM app_store_apps AS ios
INNER JOIN play_store_apps AS android
ON ios.name = android.name
WHERE CAST(ios.price = 0 AND CAST= 0
GROUP BY ios.name, android.name, ios.price, android.price
ORDER BY average_rating DESC;
