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
		 play_store_apps.name,
		round((app_store_apps.rating + play_store_apps.rating)/2,2) as combined_avg_rating, 
		app_store_apps.review_count,
		sum(play_store_apps.review_count)
from app_store_apps 
--7197
inner join play_store_apps
--553
using (name)
where app_store_apps.rating >= 4.0
	and play_store_apps.rating>=4.0
group by distinct app_store_apps.name,
		 play_store_apps.name,
		 combined_avg_rating, 
		app_store_apps.review_count
order by sum(play_store_apps.review_count) desc;
--248 rows


case
			when app_store_apps.price > play_store_apps.price
			 then  app_store_apps.price
			 else  play_store_apps.price
			 end as greater_price