
--AVERAGE RATING FOR APPS ON BOTH STORES--

SELECT ios.name AS iosname, android.name AS droidname,
ROUND((ios.rating + android.rating) / 2,2) AS average_rating
FROM app_store_apps AS ios
INNER JOIN play_store_apps AS android
ON ios.name = android.name
ORDER BY average_rating DESC;


--Looking at which ones are free on both stores--

SELECT ios.name AS iosname, android.name AS droidname, ios.price AS ios_price, android.price, CASE WHEN ios.price > android.price
THEN ios.price 
ELSE android.price
END AS higer_price
AS droid_price,
  ROUND((ios.rating + android.rating) / 2, 2) AS average_rating
FROM app_store_apps AS ios
INNER JOIN play_store_apps AS android
ON ios.name = android.name
WHERE ios.price = 0 AND android.price = '0'
ORDER BY average_rating DESC;


--case code?--
case
		when cast(replace(p.price, '$', '') as money) > cast(a.price as money)
		then cast(replace(p.price, '$', '') as money)
		else  cast(a.price as money)
	end as higher_price,

