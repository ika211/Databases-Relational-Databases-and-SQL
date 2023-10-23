-- For every situation where student A likes student B, but student B likes a
-- different student C, return the names and grades of A, B, and C.
SELECT a.name, a.grade, b.name, b.grade, c.name, c.grade
FROM Likes l1, Likes l2, Highschooler a, Highschooler b, Highschooler c
WHERE l1.ID2 = l2.ID1 and l1.ID1 <> l2.ID2
    and l1.ID1 = a.ID and l1.ID2 = b.ID and l2.ID2 = c.ID;

-- Find those students for whom all of their friends are in different grades
-- from themselves. Return the students' names and grades.
WITH all_friends AS (
    SELECT ID1, ID2
    FROM Friend
    UNION
    SELECT ID2, ID1
    FROM Friend
), same_grade_friends AS (
    SELECT ID1
    FROM all_friends af, Highschooler h1, Highschooler h2
    WHERE af.ID1 = h1.ID and af.ID2 = h2.ID and h1.grade = h2.grade
)
SELECT name, grade
FROM Highschooler
WHERE ID in (SELECT ID1 FROM all_friends EXCEPT SELECT ID1 FROM same_grade_friends);

-- What is the average number of friends per student? (Your result should be just one number.)
WITH all_friends AS (
    SElECT ID1, ID2
    FROM Friend
    UNION
    SELECT ID2, ID1
    FROM Friend
), friends_for_each AS (
SELECT ID1, COUNT(*) count
FROM all_friends
GROUP BY ID1)
SELECT AVG(count)
FROM friends_for_each;

-- Find the number of students who are either friends with Cassandra or are friends of friends
-- of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend.
WITH cassandra_circle AS (
SELECT C.ID C_ID, F.ID F_ID, FOF.ID FOF_ID
FROM Friend f1, Friend f2, Highschooler C, Highschooler F, Highschooler FOF
WHERE f1.ID2 = f2.ID1 AND f1.ID1 = c.ID AND c.name = 'Cassandra'
    AND f1.ID2 = F.ID AND f2.ID2 = FOF.ID AND FOF.ID <> C.ID)
SELECT COUNT(*)
FROM
(SELECT F_ID
FROM cassandra_circle
UNION
SELECT FOF_ID
FROM cassandra_circle) s;

-- Find the name and grade of the student(s) with the greatest number of friends.
WITH all_friends AS (
    SElECT ID1, ID2
    FROM Friend
    UNION
    SELECT ID2, ID1
    FROM Friend
), friends_for_each AS (
SELECT ID1, COUNT(*) count
FROM all_friends
GROUP BY ID1)
SELECT name, grade
FROM Highschooler
WHERE ID IN (SELECT ID1 FROM friends_for_each WHERE count = (SELECT MAX(count) FROM friends_for_each));