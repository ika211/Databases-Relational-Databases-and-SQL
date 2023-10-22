-- Find the names of all reviewers who rated Gone with the Wind.
SELECT name
FROM Reviewer
WHERE rID in (SELECT rID FROM Rating WHERE mID = (SELECT mID FROM Movie WHERE title = 'Gone with the Wind'));

-- For any rating where the reviewer is the same as the director of the movie, return the
-- reviewer name, movie title, and number of stars.
SELECT name, title, stars
FROM Movie m INNER JOIN Rating r INNER JOIN Reviewer re
    ON m.mID = r.mID and r.rID = re.rID
WHERE name = director;

-- Return all reviewer names and movie names together in a single list, alphabetized.
-- (Sorting by the first name of the reviewer and first word in the title is fine;
-- no need for special processing on last names or removing "The".)
SELECT name
FROM Reviewer
UNION
SELECT title
FROM Movie;

-- Find the titles of all movies not reviewed by Chris Jackson.
SELECT title
FROM Movie
WHERE mID NOT IN
(SELECT mID
FROM Reviewer re, Rating r
WHERE re.rID = r.rID and name = 'Chris Jackson');

-- For all pairs of reviewers such that both reviewers gave a rating
-- to the same movie, return the names of both reviewers. Eliminate
-- duplicates, don't pair reviewers with themselves, and include
-- each pair only once. For each pair, return the names in the pair
-- in alphabetical order.
SELECT distinct re1.name, re2.name
FROM Rating r1, Rating r2, Reviewer re1, Reviewer re2
WHERE r1.mID = r2.mID AND re1.name < re2.name AND r1.rID = re1.rID
  AND r2.rID = re2.rID
ORDER BY re1.name;

-- For each rating that is the lowest (fewest stars) currently in the
-- database, return the reviewer name, movie title, and number of stars.
SELECT name, title, stars
FROM Reviewer re, Movie m, Rating r
WHERE re.rID = r.rID AND r.mID = m.mID AND
    stars = (SELECT MIN(stars) FROM Rating);

-- List movie titles and average ratings, from highest-rated to lowest-rated.
-- If two or more movies have the same average rating, list them in alphabetical order.
SELECT title, AVG(stars) avg_rating
FROM Movie m, Rating r
WHERE m.mID = r.mID
GROUP BY title
ORDER BY avg_rating DESC, title;

-- Find the names of all reviewers who have contributed three or more ratings.
-- (As an extra challenge, try writing the query without HAVING or without COUNT.)
SELECT name
FROM Reviewer
WHERE rID in (SELECT rID FROM Rating GROUP BY rID HAVING COUNT(*) >= 3);

-- Some directors directed more than one movie. For all such directors, return
-- the titles of all movies directed by them, along with the director name. Sort
-- by director name, then movie title. (As an extra challenge, try writing the
-- query both with and without COUNT.)
SELECT title, director
FROM Movie
WHERE director in (SELECT director FROM Movie GROUP BY director HAVING COUNT(*) > 1)
ORDER BY director, title;

-- Find the movie(s) with the highest average rating. Return the movie title(s)
-- and average rating. (Hint: This query is more difficult to write in SQLite
-- than other systems; you might think of it as finding the highest average
-- rating and then choosing the movie(s) with that average rating.)
SELECT title, AVG(stars) avg_rating
FROM Movie m, Rating r
WHERE m.mID = r.mID
GROUP BY m.mID
HAVING avg_rating = (SELECT MAX(avg_rating) FROM (SELECT AVG(stars) avg_rating FROM Rating GROUP BY mID));

-- Find the movie(s) with the lowest average rating. Return the movie title(s)
-- and average rating. (Hint: This query may be more difficult to write in SQLite
-- than other systems; you might think of it as finding the lowest average rating
-- and then choosing the movie(s) with that average rating.)
SELECT title, AVG(stars) avg_rating
FROM Movie m, Rating r
WHERE m.mID = r.mID
GROUP BY m.mID
HAVING avg_rating = (SELECT MIN(avg_rating) FROM (SELECT AVG(stars) avg_rating FROM Rating GROUP BY mID));

-- For each director, return the director's name together with the title(s) of the
-- movie(s) they directed that received the highest rating among all of their movies,
-- and the value of that rating. Ignore movies whose director is NULL.
SELECT distinct director, title, stars
FROM Movie m1, Rating r
WHERE m1.mID = r.mID
  AND m1.director IS NOT NULL
  AND stars = (
SELECT MAX(stars)
FROM Movie m2, Rating r
WHERE m2.mID = r.mID and m1.director = m2.director
GROUP BY m2.director);



SELECT *
FROM Reviewer re LEFT JOIN Rating r
ON re.rID = r.rID;

SELECT *
FROM Movie m RIGHT JOIN Rating r
ON m.mID = r.mID;
