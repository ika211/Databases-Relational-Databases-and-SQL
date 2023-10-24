-- It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
DELETE FROM Highschooler
WHERE grade = 12;

-- If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
DELETE FROM Likes
WHERE (ID1, ID2) IN (SELECT * FROM Friend)
AND (ID2, ID1) NOT IN (SELECT * FROM Likes);

-- For all cases where A is friends with B, and B is friends with C, add a new friendship
-- for the pair A and C. Do not add duplicate friendships, friendships that already exist,
-- or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.)
INSERT INTO Friend
SELECT distinct A.ID, C.ID
FROM Friend f1, Friend f2, Highschooler A, Highschooler B, Highschooler C
WHERE f1.ID1 = A.ID AND
      f1.ID2 = B.ID AND
      f2.ID2 = C.ID AND
      f1.ID2 = f2.ID1 AND
      f1.ID1 <> f2.ID2 AND
      (A.ID, C.ID) NOT IN (SELECT * FROM Friend);