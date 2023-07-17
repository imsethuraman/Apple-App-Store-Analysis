create TABLE applestore_description_combined AS

select * from appleStore_description1
UNION ALL
select * from appleStore_description2
UNION ALL
select * from appleStore_description3
UNION ALL
select * from appleStore_description4

***EXPLORATORY DATA ANALYSIS***

----CHECK THE UNIQUE APPS IN BOTH TABLES APPLESTORE AND THE COMBINED DATASETSAppleStore

---appleStore table
SELECT COUNT(DISTINCT id) as UniqueAppIDs
from AppleStore

----combined description tableAppleStore
SELECT COUNT(DISTINCT id) as UniqueAppIDs
from applestore_description_combined

----key fields missing values

----applestore
select count(*) as MissingVALUES
from AppleStore
where track_name is NULL or user_rating is NULL or prime_genre is NULL

----combined descriptionAppleStore
select count(*) as MissingVALUES
from applestore_description_combined
where app_desc is NULL 

----find the number of apps genre
select prime_genre, count(*) as Num_Apps
from AppleStore
group by prime_genre
order by Num_Apps DESC;

---Get the overiew of Apps ratingsAppleStore
select min(user_rating) as Min_rating,
       max(user_rating) as Max_rating,
       avg(user_rating) as Avg_rating
from AppleStore

----Get Apps Price distributionAppleStore
SELECT
  (price/2)*2 as Price_Bin_Start,
  ((price/2)*2)+2 as Price_Bin_End,
  count(*) as NumApps
FROM
  AppleStore
GROUP BY
  Price_Bin_Start
ORDER BY
  Price_Bin_Start;
  
---Get the overiew of Apps price AppleStore
select min(price) as Min_Price,
       max(price) as Max_Price,
       avg(price) as Avg_Price
from AppleStore

*** Data Analysis AppleStore***

----determine whether the paid apps have higher ratings then the free apps in AppleStore

SELECT 
  CASE 
    WHEN price > 0 THEN 'Paid'
    ELSE 'Free'
  END AS App_Type,
  AVG(user_rating) AS Avg_Rating
FROM 
  AppleStore
GROUP BY 
  App_Type;
  
---- check whether the apps that support more language have good rating

SELECT 
  CASE 
    WHEN lang_num < 10 THEN '< 10 language'
    WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 language'
    ELSE '>30 language'
  END AS language_Bucket,
  AVG(user_rating) AS Avg_Rating
FROM 
  AppleStore
GROUP BY 
  language_Bucket
ORDER BY 
  Avg_Rating desc;
  
  
---Genre with low rating
SELECT 
  prime_genre,
  AVG(user_rating) AS Avg_Rating
FROM 
  AppleStore
GROUP BY 
  prime_genre
ORDER BY 
  Avg_Rating 
LIMIT 10;

----check if there is correlertion between app description and user ratingsAppleStore

SELECT 
  CASE 
    WHEN LENGTH(b.app_desc) < 500 THEN 'short'
    WHEN LENGTH(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
    ELSE 'long'
  END AS Description_length_Bucket,
  AVG(a.user_rating) AS Avg_Rating
FROM 
  AppleStore AS a
JOIN
  applestore_description_combined AS b
ON 
  a.id = b.id
GROUP BY 
  Description_length_Bucket
ORDER BY 
  Avg_Rating DESC;
  
  
---- Top rated for each genresAppleStore

SELECT prime_genre, track_name, user_rating
FROM (
  SELECT prime_genre, track_name, user_rating,
    RANK() OVER (PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
  FROM AppleStore
) AS a
WHERE a.rank = 1;








  
  



















       
       
       








