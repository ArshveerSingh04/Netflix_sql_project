-- DROP TABLE IF EXISTS netflix;

-- CREATE TABLE netflix (
--     show_id TEXT,
--     type TEXT,
--     title TEXT,
--     director TEXT,
--     "cast" TEXT,
--     country TEXT,
--     date_added TEXT,
--     release_year INT,
--     rating TEXT,
--     duration TEXT,
--     listed_in TEXT,
--     description TEXT
-- );
-- SELECT COUNT(*) AS total_count FROM netflix;

-- SELECT DISTINCT TYPE FROM netflix----> to know what type of content you have in your dataset,
SELECT *FROM netflix;

-- 15 BUISNESS PROBLEMS



1. Count the number of Movies vs TV Shows

-- ANS NO 1 -->
SELECT TYPE,COUNT(*) AS total_content FROM netflix GROUP BY type

2. Find the most common rating for movies and TV shows

-- ANS NO 2-->  
SELECT 
  TYPE, 
rating
FROM
(SELECT
TYPE,
rating,
COUNT(*),
RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS ranking
FROM netfliX GROUP BY 1,2 
) as t1
WHERE ranking=1

3. List all movies released in a specific year (e.g., 2020)

-- ANS NO 3-->
SELECT* FROM netflix
WHERE TYPE='Movie'
AND 
release_year=2020

4. Find the top 5 countries with the most content on Netflix

-- ANS NO 4-->
SELECT 
UNNEST(STRING_TO_ARRAY(country,',')) AS new_country,
COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 5

5. Identify the longest movie or TV show duration

-- ANS NO 5
SELECT *FROM netflix
WHERE 
   TYPE='Movie'
   AND 
   duration=(SELECT MAX(duration)FROM netflix)

6. Find content added in the last 5 years

-- ANS NO 6-->
SELECT 
*FROM netflix
WHERE
  TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years'

7. Find all the moves/TV shows by director 'Rajiv Chilaka'

-- ANS NO 7-->
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

8. List all TV shows with more than 5 seasons
 
 -- ANS NO 8-->
SELECT *
FROM netflix
WHERE type = 'TV Show'
AND
 SPLIT_PART(duration, ' ', 1)::numeric > 5;
  
9. Count the number of content items in each genre

-- ANS NO 9-->
SELECT 
  UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
  COUNT(*) AS total_content
FROM netflix 
GROUP BY 1
ORDER BY total_content DESC;

10. Find the average release year for content produced in a specific country

-- ANS NO 10 (year-wise like your image)-->
SELECT 
  release_year AS year,
  COUNT(*) AS count,
  COUNT(*) * 1.0 / COUNT(DISTINCT release_year) AS avg_content_per_year
FROM netflix
GROUP BY release_year
ORDER BY year;

11. List all movies that are documentaries

-- ANS NO 11-->
SELECT *
FROM netflix
WHERE type = 'Movie'
  AND listed_in ILIKE '%Documentaries%';

12. Find all content without a director

-- ANS NO 12-->
SELECT *
FROM netflix
WHERE director IS NULL;

13. Find how many movies actor 'Salman Khan' appeared in last 10 years

-- ANS NO 13-->
SELECT COUNT(*) AS total_movies
FROM netflix
WHERE type = 'Movie'
  AND "cast" ILIKE '%Salman Khan%'
  AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;
  
14. Find the top 10 actors who have appeared in the highest number of movies produced

-- ANS NO 14-->
SELECT 
  TRIM(UNNEST(STRING_TO_ARRAY("cast", ','))) AS actor,
  COUNT(*) AS movie_count
FROM netflix
WHERE type = 'Movie'
GROUP BY 1
ORDER BY movie_count DESC
LIMIT 10;

15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

-- ANS NO 15-->
SELECT 
  CASE 
    WHEN description ILIKE '%kill%' 
      OR description ILIKE '%violence%' 
    THEN 'Bad'
    ELSE 'Good'
  END AS category,
  COUNT(*) AS total_content
FROM netflix
GROUP BY 1;




