create table netflix_titles(
"show_id" varchar(50),
"type" varchar(500),
"title" varchar(500),
"director" varchar(500),
"casts" varchar(1000),
"country" varchar(500),
"date_added" varchar(500),
"release_year" int8,
"rating" varchar(500),
"duration" varchar(500),
"listed_in" varchar(500)
);

copy netflix_titles(
show_id,
type,
title,
director,
casts,
country,
date_added,
release_year,
rating,
duration,
listed_in,

)
from 'D:\netflix_titles.csv' csv header;
copy netflix_titles
(
show_id,
type,
title,
director,
casts,
country,
date_added,
release_year,
rating,
duration,
listed_in
)
from 'D:\netflix_titles.csv' csv header;

SELECT * FROM netflix_titles;

SELECT COUNT(*) AS TOTAL_CONTENT FROM NETFLIX_TITLES;

SELECT DISTINCT TYPE FROM NETFLIX_TITLES;

--> 1. Count the number of Movies vs TV shows
SELECT TYPE, COUNT(*) AS total_content FROM NETFLIX_TITLES GROUP BY type;

--> 2. Find the most common rating for movies and TV shows

SELECT * 
FROM (
   SELECT  
      type, 
      rating, 
      COUNT(*) AS count,
      RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
   FROM netflix_titles  
   GROUP BY type, rating
) AS t1
WHERE ranking = 1;


--> 3. List all movies released in a specific year (e.g., 2020)
SELECT * FROM netflix_titles
WHERE type = 'Movie'
      AND
      release_year = '2020'


--> 4. Find the top 5 countries with the most content on Netflix

SELECT  UNNEST(STRING_TO_ARRAY(country, ',') )AS new_country, 
      COUNT(show_id) as total_content
FROM netflix_titles
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

SELECT 
      UNNEST(STRING_TO_ARRAY(country, ',') )AS new_country 
FROM netflix_titles


--> 5. Identify the longest movie

SELECT * FROM netflix_titles
WHERE 
     type = 'Movie'
	 AND
	 duration =(SELECT MAX(duration) FROM netflix_titles)


-- >6. Find content added in the last 5 years

SELECT *
FROM netflix_titles
WHERE 
     TO_DATE(date_added, 'Month DD, YY') >= CURRENT_DATE - INTERVAL '5 YEARS'

	 
--> 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT *
FROM netflix_titles
WHERE director like '%Rajiv Chilaka%'



--> 8. List all TV shows with more than 5 seasons

SELECT * 
FROM netflix_titles
WHERE 
     type = 'TV Show'
	 AND
	 SPLIT_PART(duration, ' ', 1)::NUMERIC > 5 

--> 9. Count the number of content items in each genre


SELECT 
     
	  UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
	  COUNT(show_id) AS total_content
FROM netflix_titles
GROUP BY 1


-->10. Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release

SELECT 
      EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	  COUNT(*) yaerly_content,
	  ROUND(
	  COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix_titles WHERE country = 'India')::numeric * 100, 2)
	  as avg_content_per_year
FROM netflix_titles
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--> 11. List all movies that are documentaries

SELECT * 
FROM netflix_titles
WHERE listed_in ILIKE '%documentaries%'

--> 12. Find all content without a director

SELECT * 
FROM netflix_titles
WHERE director IS null


--> 13. Find how many movies actor 'Salman Khan' appeared in last 10 years

SELECT * 
FROM netflix_titles
WHERE casts ILIKE '%salman khan%'
      AND
	  release_year > Extract(year from current_date)- 10

--> 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
	  UNNEST(STRING_TO_ARRAY(CASTS, ',')) AS actors,
	  COUNT(*) AS total_content
FROM netflix_titles
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
limit 10



--> 15.Peak Content Addition Month
SELECT 
      EXTRACT(MONTH FROM TO_DATE(date_added, 'Month DD, YYYY')) as month,
	  count(*) as content_count
FROM netflix_titles
WHERE date_added IS NOT NULL
group by month
ORDER BY content_count DESC



--END OF PROJECT










