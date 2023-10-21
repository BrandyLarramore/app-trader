--fields we need:
--  1. name (will join on)
-- 2. price (check currency for app store: everything is USD)
-- 3. review_count
-- 4. rating

-- random queries selects
select distinct content_rating from app_store_apps;
-- play store has 9659 unique names, and 10840 total rows (1181 duplicates)
select name, count(name) from app_store_apps
group by name
having count(name) > 1;
-- app store has 7197 rows and 7195 distinct names (2 dups: "VR Roller Coaster", "Mannequin Challenge")

select * from play_store_apps
full outer join app_store_apps using(name)

select  price, floor(price) * 10000
from app_store_apps;

--final query
with cte as (
	select distinct p.name as app_name,
	round((p.rating + a.rating) / 2, 1) as avg_rating,
	round(avg(p.review_count) + avg(a.review_count::integer)) as review_counts,
	case
		when cast(replace(p.price, '$', '') as money) > cast(a.price as money)
		then cast(replace(p.price, '$', '') as money)
		else  cast(a.price as money)
	end as higher_price,
	cast(replace(p.price, '$', '') as money) play_store_price,
	cast(a.price as money) app_store_price,
	a.primary_genre as apple_genre,
	p.genres as android_genre
from play_store_apps p
join app_store_apps a using(name)
group by app_name, avg_rating, higher_price, play_store_price, app_store_price, apple_genre, android_genre
),
cte0 as(
	select app_name, avg_rating, higher_price, review_counts, play_store_price, app_store_price, case 
			when higher_price > 1.00::money
			then (higher_price::numeric * 10000)::money
			else 10000::money
		end as purchase_price,
		android_genre, apple_genre,
	floor((avg_rating / 0.5) + 1) as longevity_in_years
	from cte
)

	select app_name,
		avg_rating,
		review_counts,
		higher_price,				-- app price that is used to calculate purchase price
		play_store_price,
		app_store_price,
		purchase_price,		-- price to purchase advertising rights
		longevity_in_years,
		(longevity_in_years * 10000)::money as gross_profit,
		(longevity_in_years * 10000)::money - purchase_price as net_profit,
		android_genre,
		apple_genre
		from cte0
	-- order by gross_profit desc, purchase_price asc

order by net_profit desc, avg_rating desc, review_counts desc;
	 
	 --
select distinct currency from app_store_apps;
