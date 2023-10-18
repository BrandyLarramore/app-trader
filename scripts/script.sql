--fields we need:
--  1. name (will join on)
2. price (check currency for app store: everything is USD)
3. review_count
4. rating

-- general selects
select * from play_store_apps where name ilike 'asos';
select * from app_store_apps;

select * from play_store_apps
full outer join app_store_apps using(name)

select distinct p.name,
	(p.rating + a.rating) / 2 as avg_rating,
	cast(replace(p.price, '$', '') as money),
	cast(a.price as money)
from play_store_apps p
full outer join app_store_apps a using(name)
where a.name in (
	select name from play_store_apps)
order by avg_rating desc;

select distinct currency from app_store_apps;
