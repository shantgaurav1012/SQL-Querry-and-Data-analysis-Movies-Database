USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

select count(*) from genre; 
select count(*) from director_mapping ; 
select count(*) from movie ; 
select count(*) from names ; 
select count(*) from ratings; 
select count(*) from role_mapping ; 

-- Genre has 14662 rows

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT * FROM movie WHERE id IS NULL;
SELECT * FROM movie WHERE title IS NULL;
SELECT * FROM movie WHERE year IS NULL;
SELECT * FROM movie WHERE date_published IS NULL;
SELECT * FROM movie WHERE duration IS NULL;
SELECT * FROM movie WHERE country IS NULL;
SELECT * FROM movie WHERE worlwide_gross_income IS NULL;
SELECT * FROM movie WHERE languages IS NULL;
SELECT * FROM movie WHERE production_company IS NULL;

-- 4 columns has null values ---


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    year, COUNT(title) AS Number_of_movies
FROM
    movie
GROUP BY year;

SELECT 
    MONTH(date_published) AS month_number,
    COUNT(*) AS number_of_movie
FROM
    movie
GROUP BY month_number
ORDER BY month_number;

-- March has 824 movies --

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select year,
	count(title) as Movies_count from movie
    WHERE  ( country LIKE '%INDIA%'
          OR country LIKE '%USA%' )
       AND year = 2019;
       
-- answer is 1059 movies --



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct(genre) as Different_genres from genre; 



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select genre , 	
	count(movie_id) as Total_movies 
    from genre
    group by genre
    ORDER BY Total_movies DESC limit 1;

-- drama = 4285 movie 

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT genre_count, 
       Count(movie_id) as Total_movies
FROM (SELECT movie_id, Count(genre) as genre_count
      FROM genre
      GROUP BY movie_id
      ORDER BY genre_count DESC) genre_count
WHERE genre_count = 1
GROUP BY genre_count;


-- Answer is 3289 movies ---





/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    genre, AVG(duration) AS Average_duration
FROM
    movie AS mov
        INNER JOIN
    genre AS gen ON gen.movie_id = mov.id
GROUP BY genre
ORDER BY Average_duration DESC;


-- action has 112 duration --




/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select genre , 	
	count(movie_id) as Total_movies,
    Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank
    from genre
    group by genre;





/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS Minimum_Rating,
    MAX(avg_rating) AS Maximum_Rating,
    MIN(total_votes) AS Minimum_votes,
    MAX(total_votes) AS Maximumum_votes,
    MIN(median_rating) AS Minimum_median,
    MAX(median_rating) AS Maximum_median
FROM
    ratings;




    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT 
	title, 
    avg_rating,
	dense_rank() OVER(ORDER BY avg_rating Desc) AS genre_rank
FROM movie
INNER JOIN ratings
ON movie.id = ratings.movie_id;





/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT DISTINCT
    (median_rating) AS Med_rating,
    COUNT(median_rating) AS Total_movies
FROM
    ratings
GROUP BY Med_rating
ORDER BY Med_rating;



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
      Count(movie_id) as movie_count, 
      Rank() OVER( ORDER BY Count(movie_id) DESC ) AS prod_company_rank
FROM ratings AS rat
     INNER JOIN movie AS mov
     ON mov.id = rat.movie_id
WHERE avg_rating > 8 and production_company IS NOT NULL
GROUP BY production_company;





-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select genre,
       Count(movie.id) as Total_movies
from movie
     INNER JOIN genre as gen
           ON gen.movie_id = movie.id
     INNER JOIN ratings as rat
           ON rat.movie_id = movie.id
where year = 2017
	  AND Month(date_published) = 3
	  AND country LIKE '%USA%'
	  AND total_votes > 1000
group by genre
order by Total_movies desc;





-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    title, avg_rating AS Ratings, genre
FROM
    movie AS mov
        INNER JOIN
    genre AS gen ON gen.movie_id = mov.id
        INNER JOIN
    ratings AS rat ON rat.movie_id = mov.id
WHERE
    avg_rating > 8 AND title LIKE 'THE%'
ORDER BY Ratings DESC;






-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    COUNT(id) AS No_of_movies
FROM
    movie
        INNER JOIN
    ratings ON movie.id = ratings.movie_id
WHERE
    median_rating = 8
        AND date_published BETWEEN '2018-04-01' AND '2019-04-01';





-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT country ,
	SUM(total_votes) AS Total_votes
FROM
    movie
        INNER JOIN
    ratings ON movie.id = ratings.movie_id
    where country = "Italy" ;
    
SELECT 
    country, SUM(total_votes) AS Total_votes
FROM
    movie
        INNER JOIN
    ratings ON movie.id = ratings.movie_id
WHERE
    country = 'Germany';





-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
    COUNT(id) AS height_nulls
FROM
    names
WHERE
    height IS NULL;
SELECT 
    COUNT(id) AS name_nulls
FROM
    names
WHERE
    name IS NULL;
SELECT 
    COUNT(id) AS date_of_birth_nulls
FROM
    names
WHERE
    date_of_birth IS NULL;
SELECT 
    COUNT(id) AS known_for_movies_nulls
FROM
    names
WHERE
    known_for_movies IS NULL;




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

With Top_genre 
as
(select genre, 
	Count(gen.movie_id ) as Top_3
from genre as gen 
     INNER JOIN ratings as rat
           ON rat.movie_id = gen.movie_id 
where avg_rating > 8
group by genre
order by Top_3 desc limit 3 )
select 
    nam.NAME as director_name ,
	Count(nam.id) AS movie_count from director_mapping as dm
       inner join names as nam
       ON nam.id = dm.name_id
       inner join genre gen using (movie_id)
       inner join Top_genre using (genre)
       inner join ratings using (movie_id)
where avg_rating > 8
group by name
order by movie_count DESC limit 3 ;




/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select nam.name as actor_name, count(rolmap.movie_id) as movie_count from role_mapping as rolmap
inner join ratings on ratings.movie_id = rolmap.movie_id 
inner join names nam on nam.id = rolmap.name_id
where category = 'actor' and median_rating >= 8
group by nam.name
order by movie_count desc
limit 2;






/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:



select production_company, 
	sum(total_votes) as vote_count,
	Rank() OVER( ORDER BY sum(total_votes) DESC ) AS prod_company_rank from movie 
inner join ratings as rat on movie.id = rat.movie_id 
group by production_company
limit 3;






/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
    nam.name AS Actor_Name,
    total_votes,
    COUNT(movie.id) as Movie_count,
    Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) as actor_avg_rating

FROM
    ratings as rat
inner join role_mapping as rolmap on rat.movie_id = rolmap.movie_id 
inner join names as nam on rolmap.name_id = nam.id
inner join movie on movie.id = rat.movie_id
where country = "India" and category = "actor"
group by Actor_name
having Movie_count >= 5
order by actor_avg_rating desc;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
    nam.name AS Actress_Name,
    total_votes,
    COUNT(movie.id) as Movie_count,
    Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actress_avg_rating
FROM
    ratings as rat
inner join role_mapping as rolmap on rat.movie_id = rolmap.movie_id 
inner join names as nam on rolmap.name_id = nam.id
inner join movie on movie.id = rat.movie_id
where country = "India" and category = "actress"
group by Actress_Name
having Movie_count >= 5 
order by actress_avg_rating desc;







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

-- Gaurav_code --

select mov.title as Movie_name ,
genre ,
rat.avg_rating as avg_rating,
CASE
when avg_rating > 8 then 'Superhit movies'
when avg_rating > 7 and avg_rating < 8 then 'Hit movies'
when avg_rating > 5 and avg_rating < 7 then 'One-time-watch movies'
else 'flop movies'
END as Hit_or_Flop from genre as gen
inner join ratings as rat on rat.movie_id = gen.movie_id
inner join movie as mov on mov.id = gen.movie_id
where genre = "Thriller" ;

-- raghav code --

SELECT 
    title,
    avg_rating,
    CASE
        WHEN avg_rating > 8 THEN 'Superhit movies'
        WHEN avg_rating > 7 AND avg_rating < 8 THEN 'Hit movies'
        WHEN avg_rating > 5 AND avg_rating < 7 THEN 'One-time-watch movies'
        ELSE 'flop movies'
    END AS rating
FROM
    movie
        INNER JOIN
    ratings ON movie.id = ratings.movie_id
        INNER JOIN
    genre AS gen ON gen.movie_id = movie.id
WHERE
    gen.genre = 'thriller';


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select genre, 
round(avg(duration),2) as avg_duration, 
SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre) AS running_total_duration,
AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre) 
AS moving_avg_duration
FROM movie
INNER JOIN genre AS gen
ON movie.id= gen.movie_id
GROUP BY genre
ORDER BY genre; 








-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

With Top_genre 
as
(select genre, 
  Count(gen.movie_id ) as Top_3
from genre as gen 
     INNER JOIN ratings as rat
           ON rat.movie_id = gen.movie_id 
where avg_rating > 8
group by genre
order by Top_3 desc limit 5 )

select gen.genre, year, title as movie_name ,
CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) as gross_income, rank() OVER( ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10))  DESC ) AS movie_rank from movie
inner join genre as gen on gen.movie_id = movie.id 
inner join Top_genre using (genre)
where worlwide_gross_income is not null
group by genre;



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company, count(id) as movie_count, 
	rank() over(order by count(id) desc) as prod_comp_rank from movie
inner join ratings on movie.id = ratings.movie_id 
where median_rating >= 8 and position(',' in languages) > 0 and production_company is not null
group by production_company
limit 3;






-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select nam.name as actress_name, 
	sum(rat.total_votes) as total_votes , rat.avg_rating as Actress_rating , 
	count(rolmap.movie_id) as movie_count, 
	row_number() over(order by avg_rating desc) as actress_rank
from role_mapping as rolmap
	inner join names nam on nam.id = rolmap.name_id
	inner join ratings as rat on rat.movie_id = rolmap.movie_id 
	inner join genre as gen on gen.movie_id = rat.movie_id
where category = 'actress' and avg_rating > 8 and gen.genre = 'drama'
group by nam.name
limit 3 ;






/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

SELECT 
    name_id AS director_id,
    COUNT(dir_map.movie_id) AS num_of_movies,
    nam.name AS director_name,
    rat.avg_rating AS Average_rating,
    rat.total_votes AS Total_votes,
    MIN(rat.avg_rating) AS Minimum_rating,
    MAX(rat.avg_rating) AS Max_rating,
    SUM(mov.duration) AS Total_duration
FROM
    director_mapping AS dir_map
        INNER JOIN
    names AS nam ON dir_map.name_id = nam.id
        INNER JOIN
    ratings AS rat ON rat.movie_id = dir_map.movie_id
        INNER JOIN
    movie AS mov ON mov.id = dir_map.movie_id
GROUP BY director_name
ORDER BY num_of_movies DESC
LIMIT 9;






