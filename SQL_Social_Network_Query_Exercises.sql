-- Find the names of all students who are friends with someone named Gabriel.
SELECT DISTINCT h2.name
FROM
(SELECT ID1, ID2
FROM Friend
UNION
SELECT ID2, ID1
FROM Friend) f2, Highschooler h1, Highschooler h2
WHERE f2.ID2 = h2.ID AND f2.ID1 = h1.ID
AND h1.name = 'Gabriel';

-- For every student who likes someone 2 or more grades younger than themselves,
-- return that student's name and grade,
-- and the name and grade of the student they like.
SELECT h1.name, h1.grade, h2.name, h2.grade
FROM Likes l, Highschooler h1, Highschooler h2
WHERE l.ID1 = h1.ID AND l.ID2 = h2.ID
    AND h1.grade - h2.grade >= 2;

-- For every pair of students who both like each other, return the name and
-- grade of both students. Include each pair only once, with the two names in
-- alphabetical order.
SELECT h1.name, h1.grade, h2.name, h2.grade
FROM Likes l1, Likes l2, Highschooler h1, Highschooler h2
WHERE l1.ID1 = l2.ID2 and l2.ID1 = l1.ID2
    AND l1.ID1 = h1.ID and l1.ID2 = h2.ID
    AND h1.name < h2.name;

-- Find all students who do not appear in the Likes table (as a student who
-- likes or is liked) and return their names and grades. Sort by grade, then
-- by name within each grade.
SELECT name, grade
FROM Highschooler
WHERE ID NOT IN (SELECT ID1 FROM Likes UNION SELECT ID2 FROM Likes)
ORDER BY grade, name;

-- For every situation where student A likes student B, but we have no
-- information about whom B likes (that is, B does not appear as an ID1
-- in the Likes table), return A and B's names and grades.
SELECT h1.name, h1.grade, h2.name, h2.grade
FROM Likes l, Highschooler h1, Highschooler h2
WHERE l.ID1 = h1.ID AND l.ID2 = h2.ID AND
      l.ID2 NOT IN (SELECT ID1 FROM Likes);


-- Find names and grades of students who only have friends in the same grade.
-- Return the result sorted by grade, then by name within each grade.
SELECT name, grade
FROM Highschooler
WHERE ID NOT IN (
SELECT h1.ID
FROM Friend f, Highschooler h1, Highschooler h2
WHERE ((f.ID1 = h1.ID AND f.ID2 = h2.ID) OR (f.ID2 = h1.ID AND f.ID1 = h2.ID)) AND h1.grade <> h2.grade)
AND ID IN (SELECT ID1 FROM Friend UNION SELECT ID2 FROM Friend)
ORDER BY grade, name;

-- For each student A who likes a student B where the two are not friends,
-- find if they have a friend C in common (who can introduce them!). For all
-- such trios, return the name and grade of A, B, and C.
WITH all_friends AS (
SELECT ID1, ID2 FROM Friend UNION SELECT ID2, ID1 FROM Friend)
SELECT h1.name, h1.grade, h3.name, h3.grade, h2.name, h2.grade
FROM all_friends f1, all_friends f2, Highschooler h1, Highschooler h2, Highschooler h3
WHERE f1.ID1 = h1.ID AND f1.ID2 = h2.ID AND f2.ID2 = h3.ID
AND f1.ID2 = f2.ID1 AND f1.ID1 <> f2.ID2 AND
      (f1.ID1, f2.ID2) IN (SELECT ID1, ID2
                            FROM Likes
                            WHERE (ID1, ID2) NOT IN (SELECT * FROM Friend)
                            AND (ID2, ID1) NOT IN (SELECT * FROM Friend));

-- Find the difference between the number of students in the school and the number of different first names.
SELECT (SELECT COUNT(*) FROM Highschooler) - (SELECT COUNT(DISTINCT name) FROM Highschooler);

-- Find the name and grade of all students who are liked by more than one other student.
SELECT name, grade
FROM Highschooler
WHERE ID in
(SELECT ID2
FROM Likes
GROUP BY ID2
HAVING COUNT(*) > 1);