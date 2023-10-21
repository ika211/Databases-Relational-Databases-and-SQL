-- Find the titles of all movies directed by Steven Spielberg.
SELECT title
FROM Movie
WHERE director = 'Steven Spielberg';

-- Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
SELECT distinct year
FROM Movie
WHERE mID in (SELECT mID from Rating WHERE stars >= 4)
ORDER BY year;

-- Find the titles of all movies that have no ratings.
SELECT title
FROM Movie m LEFT JOIN Rating r
    ON  m.mID = r.mID
WHERE r.rID is NULL;

-- Some reviewers didn't provide a date with their rating.
-- Find the names of all reviewers who have ratings with a NULL value for the date.
SELECT name
FROM Reviewer
WHERE rID in (SELECT rID FROM Rating WHERE ratingDate is NULL);

-- Write a query to return the ratings data in a more readable format: reviewer name,
-- movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then
-- by movie title, and lastly by number of stars.
SELECT re.name, m.title, ra.stars, ra.ratingDate
FROM Movie m INNER JOIN Rating ra INNER JOIN Reviewer re
ON m.mID = ra.mID and ra.rID = re.rID
ORDER BY re.name, m.title, ra.stars ;


-- For all cases where the same reviewer rated the same movie twice and gave it a
-- higher rating the second time, return the reviewer's name and the title of the movie.
SELECT r.name, m.title
FROM Rating old, Rating new, Reviewer r, Movie m
WHERE old.rID = new.rID and old.mID = new.mID
  and old.rID = r.rID and old.mID = m.mID
  and old.ratingDate < new.ratingDate and old.stars < new.stars;

-- For each movie that has at least one rating, find the highest number of stars that movie received.
-- Return the movie title and number of stars. Sort by movie title.
SELECT m.title, MAX(r.stars)
FROM Movie m, Rating r
WHERE r.mID = m.mID
GROUP BY m.mID
ORDER BY m.title;

-- For each movie, return the title and the 'rating spread', that is, the difference between highest and
-- lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.
SELECT *
FROM
(SELECT m.title, MAX(r.stars) - MIN(r.stars) as rating_spread
FROM Movie m INNER JOIN Rating r ON m.mID = r.mID
GROUP BY m.mID) s
ORDER BY rating_spread desc, title ;

-- Find the difference between the average rating of movies released before 1980 and the average rating of
-- movies released after 1980. (Make sure to calculate the average rating for each movie, then the average
-- of those averages for movies before 1980 and movies after. Don't just calculate the overall average
-- rating before and after 1980.)
with t1 as (
	SELECT avg(stars) avg_stars_1
	FROM Rating INNER JOIN Movie ON Rating.mID = Movie.mID
	WHERE Movie.year < 1980
	GROUP BY Movie.mID),
	t2 as (
	SELECT avg(stars) avg_stars_2
	FROM Rating INNER JOIN Movie ON Rating.mID = Movie.mID
	WHERE Movie.year > 1980
	GROUP BY Movie.mID)
SELECT avg(avg_stars_1),avg(avg_stars_2)
FROM t1, t2;


