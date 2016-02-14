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

--Q4ind all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. 
--Sort by grade, then by name within each grade. 
select name, grade from Highschooler
where ID not in (select ID1 from Likes)
and ID not in (select ID2 from Likes)
order by grade, name;

--Q5 For every situation where student A likes student B, but we have no information about whom B likes, return A and B's names and grades. 
select distinct One.name, One.grade, Two.name, Two.grade from Highschooler One,  Highschooler Two,
(select ID1,ID2 from Likes where ID2 not in
(select ID1 from Likes)) as A
where One.ID = A.ID1
and Two.ID = A.ID2;

--Q6 Find names and grades of students who only have friends in the same grade. 
--Return the result sorted by grade, then by name within each grade. 
select distinct One.name, One.grade from Highschooler One, Highschooler Two, Friend
where One.ID =  Friend.ID1 and Two.ID = Friend.ID2
and One.grade = Two.grade
except
select distinct One.name, One.grade from Highschooler One, Highschooler Two, Friend
where One.ID =  Friend.ID1 and Two.ID = Friend.ID2 and One.grade <> Two.grade
order by 2,1;

--Q7 For each student A who likes a student B where the two are not friends, find if they have a friend C in common 
--For all such trios, return the name and grade of A, B, and C. 
select distinct Student1.name, Student1.grade, Student2.name, Student2.grade, Student3.name, Student3.grade
from Highschooler Student1, Likes, Highschooler Student2, Highschooler Student3, Friend FOne, Friend FTwo
where Student1.ID = Likes.ID1 and Likes.ID2 = Student2.ID and
  Student2.ID not in (select ID2 from Friend where ID1 = Student1.ID) and
  Student1.ID = FOne.ID1 and FOne.ID2 = Student3.ID and
  Student3.ID = FTwo.ID1 and FTwo.ID2 = Student2.ID;
  
  --Q8 Find the difference between the number of students in the school and the number of different first names. 
  select A.a - B.b from
(select count(distinct ID) as a from Highschooler) as A,
(select count(distinct name) as b from Highschooler) as B;

--Q9 Find the name and grade of all students who are liked by more than one other student. 
select name, grade from 
(select ID2, count(ID2) as Liked from Likes group by ID2) as A, Highschooler
where A.ID2 = ID and A.Liked > 1;

