-- 1. Total episodes and total pitches
select count(distinct episode_number) as Total_episodes, 
count(distinct pitch_number) as Total_pitches
from shark_tank_india ;

-- 2. What is the distribution of deal sucess rates across episodes
select episode_number, sum(deal) as sucess_deals, count(pitch_number) as total_deals,
round((sum(deal)/count(pitch_number)),2)
from shark_tank_india 
group by 1
order by 1;

-- 3.What is the avg total investment by the sharks in companies, and how does this vary across episodes?
