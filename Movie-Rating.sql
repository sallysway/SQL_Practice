-                 Exercises

--Q1 Find the titles of all movies directed by Steven Spielberg. 
select title from Movie where director = "Steven Spielberg";

--Q2 Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 
select distinct year from Movie, Rating
where Movie.mID = Rating.mID and
stars > 3 order by year;

--Q3 Find the titles of all movies that have no ratings. 
select distinct title from Movie, Rating
where Movie.mID not in (select mID from Rating);

--Q4 Find the names of all reviewers who have ratings with a NULL value for the date. 
select distinct name from Reviewer, Rating
where Reviewer.rID = Rating.rID and
Rating.ratingDate is NULL;

--Q5 Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 
select distinct name as 'reviewer name', title as 'movie title', stars, ratingDate from
Movie, Rating, Reviewer
where
Movie.mID = Rating.mID and Rating.rID = Reviewer.rID
order by name, title, stars;

--Q6 For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 
select name, title from Reviewer, Movie, Rating, Rating r2
where Rating.mID=Movie.mID and Reviewer.rID=Rating.rID 
  and Rating.rID = r2.rID and r2.mID = Movie.mID
  and Rating.stars < r2.stars and Rating.ratingDate < r2.ratingDate;
  
--Q7 For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 
select title, max(stars) from Movie, Rating
where Movie.mID = Rating.mID
group by Rating.mID
order by title;

--Q8 For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. 
select title, max(stars) - min(stars) as ratingSpread from Movie, Rating
where Movie.mID = Rating.mID
group by title
order by ratingspread desc, title;

--Q9 Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980.  
select smaller1980.second - bigger1980.first
from (select avg( averages1) as first
  from (select title, avg(stars) as averages1 from Movie, Rating where Movie.mID=Rating.mID and year > 1980 group by title)) as bigger1980,
(select avg( averages2) as second from (select title, avg(stars) as averages2 from Movie, Rating
      where Movie.mID=Rating.mID and year < 1980 group by title)) as smaller1980; 
      
      --        Extra practice
--Q1 Find the names of all reviewers who rated Gone with the Wind. 
select distinct name from Reviewer, Movie, Rating
where Reviewer.rID = Rating.rID and Movie.mID = Rating.mID
and title = 'Gone with the Wind';

--Q2 For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 
select name, title,stars from Movie, Rating, Reviewer
where Movie.mID = Rating.mID and Reviewer.rID = Rating.rID
and director = name;

--Q3 Return all reviewer names and movie names together in a single list, alphabetized.
select distinct title as a from Movie
union
select distinct name as a from Reviewer
order by a;

--Q4 Find the titles of all movies not reviewed by Chris Jackson
select title from Movie where
title not in (select title from Movie, Reviewer, Rating
where Movie.mID = Rating.mID and Reviewer.rID = Rating.rID
and Reviewer.name = 'Chris Jackson');

--Q5 For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. 
--Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. 
--For each pair, return the names in the pair in alphabetical order.
select distinct R1.name, R2.name from
(select mID, Reviewer.rID as r, name from Reviewer, Rating where Reviewer.rID = Rating.rID ) as R1,
(select mID, Reviewer.rID as q, name from Reviewer, Rating where Reviewer.rID = Rating.rID) as R2
where R1.r <> R2.q and R1.mID = R2.mID and
R1.name < R2.name
order by R1.name;

--Q6 For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. 
select name, title, stars
from Reviewer, Movie, Rating, (select min(stars) as lowest from Rating) as R
where stars = R.lowest
and Reviewer.rID = Rating.rID
and Rating.mID = Movie.mID;

--Q7 List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. 
select distinct R1.title, R1.averageRating from
(select title, avg(stars) as averageRating from Rating, Movie where Rating.mID = Movie.mID
group by title) as R1,
(select title, avg(stars) as averageRating from Rating, Movie where Rating.mID = Movie.mID
group by title) as R2
where R1.title = R2.title
order by R1.averageRating desc;

--Q8 Find the names of all reviewers who have contributed three or more ratings
select name from
(select name, count(name) c from Reviewer join Rating on Reviewer.rID = Rating.rID
group by name
having c >=3);

--Q9 Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title
select first.title, first.director
from Movie first, Movie second
where first.director = second.director and first.title <> second.title
order by first.director, first.title;
