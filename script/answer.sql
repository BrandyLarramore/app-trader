--2. Assumptions
--Based on research completed prior to launching App Trader as a company, you can assume the following:
--a. App Trader will purchase apps for 10,000 times the price of the app. For apps that are priced from free up to $1.00, the purchase price is $10,000.
--For example, an app that costs $2.00 will be purchased for $20,000.
-- The cost of an app is not affected by how many app stores it is on. A $1.00 app on the Apple app store will cost the same as a $1.00 app on both stores. 
-- If an app is on both stores, it's purchase price will be calculated based off of the highest app price between the two stores. 
--b. Apps earn $5000 per month, per app store it is on, from in-app advertising and in-app purchases, regardless of the price of the app.
--An app that costs $200,000 will make the same per month as an app that costs $1.00. 
--An app that is on both app stores will make $10,000 per month. 


select
distinct app_store_apps.name,
--did this to eliminate duplicate play store apps
round(avg(play_store_apps.rating),2) as avg_p_rating,
round(avg(app_store_apps.rating),2) as avg_a_rating,
cast(app_store_apps.review_count as integer) as ios_review_integer,
--did this to take this from text to integer
sum(play_store_apps.review_count)/2 as combined_avg_review_count,
--did this to combine all the similar play store review counts
case
			when cast(app_store_apps.price as money) > cast(play_store_apps.price as money)
			 then  cast(app_store_apps.price as money)
			 else  cast(play_store_apps.price as money)
			 end as greater_price
			 --did this to only display the highest app price between the two
from app_store_apps
inner join play_store_apps
using (name)
where play_store_apps.rating > 
	(select avg(play_store_apps.rating) from play_store_apps)
and app_store_apps.rating > (select avg(app_store_apps.rating) from app_store_apps)
--did this to only display above avg apps, in regards to their rating
group by distinct app_store_apps.name, ios_review_integer, greater_price
order by avg_p_rating desc
limit 20;
