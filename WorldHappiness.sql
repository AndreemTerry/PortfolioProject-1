select *
from worldhappy2017;

-- Grabbing the top 10 happiest countries with ranking and score
select country,happiness_rank, happiness_score 
from worldhappy2017 
where happiness_rank <=10;

-- Lowest happy Countries 
select country,happiness_rank, happiness_score, generosity, freedom
from worldhappy2017
where happiness_rank >140 and country is not null
limit 20;

-- Who has the highest Freedom percentage regardless the rank?

select country, happiness_score, happiness_rank, MAX(freedom) as highest_freedom 
from worldhappy2017
group by country, happiness_score, happiness_rank, freedom
order by 4 DESC;

-- Top 10 happiest by rank, 2016 vs 2017

	SELECT 
    w2017.country,
    w2017.country_id,
    w2017.happiness_rank AS happiness_rank2017,
    w2016.happiness_rank as happiness_rank2016
FROM 
    worldhappy2017 w2017
INNER JOIN 
    worldhappy2016 w2016 ON w2017.country_id = w2016.country_id
	where w2017.happiness_rank is not null
ORDER BY 
    w2017.happiness_rank ASC
LIMIT 10;

-- Shows increase/decrease of happiness score from 2016 to 2017. limit to 50
SELECT 
    w2017.country,
    w2017.country_id,
    (w2017.happiness_score-
    w2016.happiness_score)AS "2016_to_2017_happy_incr/decr"
FROM 
    worldhappy2017 w2017
INNER JOIN 
    worldhappy2016 w2016 ON w2017.country_id = w2016.country_id
	
	limit 50;
-- TOP decrease of happiness score from 2016 to 2017.
	SELECT 
    w2017.country,
    w2017.country_id,
    (w2017.happiness_score-
    w2016.happiness_score)AS "2016_to_2017_happy_incr/decr"
FROM 
    worldhappy2017 w2017

INNER JOIN 
    worldhappy2016 w2016 ON w2017.country_id = w2016.country_id
	where (w2017.happiness_score-
    w2016.happiness_score)<-0.15;
	
-- Counting countries that have a freedom score greater than 0.50

SELECT w2017.country, count(w2017.freedom)as "freedom_over_0.50"
from worldhappy2017 w2017
group by w2017.country, w2017.freedom
having count(w2017.freedom) >0.50
limit 100;
