Exercises https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_social_query_core/


--Q1 Find the names of all students who are friends with someone named Gabriel.
select distinct name from Highschooler, Friend
where ID=ID1 and
(ID1 in (select ID from Highschooler where name = 'Gabriel')
or ID2 in (select ID from Highschooler where name = 'Gabriel'))
and name <> 'Gabriel';

--Q2 For every student who likes someone 2 or more grades younger than themselves, 
--return that student's name and grade, and the name and grade of the student they like
select First.name, First.grade, Second.name, Second.grade
from Highschooler as First join Likes on First.ID = Likes.ID1
join Highschooler as Second on Second.ID = Likes.ID2
where  First.grade - Second.grade >=2;

--Q3 For every pair of students who both like each other, return the name and grade of both students. Include each pair only once 
select distinct H.name, H.grade, Q.name, Q.grade from
Highschooler H join
(select ID1, ID2 from Likes) Pair
on H.ID = Pair.ID1
join
 (select ID2, ID1 from Likes) Reverse
on Pair.ID1 = Reverse.ID2
join
Highschooler Q
on Q.ID = Reverse.ID1
 where
Pair.ID2 = Reverse.ID1
and Pair.ID1 > Reverse.ID1;

