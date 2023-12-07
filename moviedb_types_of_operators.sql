-- Three types of operators
/*  1. Comparision Operator (=, >, <, >=, <=, <>)
	2. Logical Operator ( AND, OR, NOT, IN )
	3. Arithmetic Operator ( +, -, *, /, %) */
	
-- WHERE CLAUSE :- 
-- Allow us to add specific conditions to our queries
-- we can limit the results that only data that satisfies our condition
-- filter rows on data by running condition
-- we use the where clause in conjuction with operators

-- 1. Get all the english movies
select * from movies
where movie_language = 'English';

--2. get all the japanese movies
select * from movies
where movie_language = 'Japanese'

--3. get all the english movies and age certificate to 18
select * from movies
where movie_language = 'English'
and age_certificate = '18';

--4. get all english or japanese moies
select * from movies
where movie_language = 'English'
or movie_language = 'japanese'
order by movie_language;

--5. get all english language and director id equal to 8
select * from movies
where movie_language = 'English'
and director_id = 8;

--6. get all english or chinese movies and movies with age certficate equal to 12
select *
from movies
where 
(movie_language = 'English' 
or movie_language = 'Chinese')
and age_certificate = '12';

--7. get all movies length is greater than 100
select * from movies
where movie_length > '100';

-- 8. get all movies length is greater than and equal to 100  
select * from movies
where movie_length >= '100';

--9. get all movies length is less than 100
select * from movies
where movie_length < '100';

--10. get all movies length is less than 100 and equal to 100
select * from movies
where movie_length <= '100';

--11. get all movies where relased date is greater than 2000
select * from movies
where released_date >= '2000-01-01'
order by released_date asc;

--12. get all movies which greater than enlish language
select * from movies
where movie_language > 'English';

--13. get all movies which not in engish language
select * from movies
where movie_language <> 'English'
order by movie_language;

--14. get all movies for engllish, chinese, and japanese
select * from movies
where movie_language in ('English', 'Chinese', 'Japanese')
order by movie_language;

--15. get all the movies where age certificate is 13 and PG type
select * from movies
where age_certificate in ('PG', '13')
order by age_certificate;

--16. get all the movies where director id is not 13 or 10
select * from movies
where director_id not in (13,10);

--17. get all actors where actor id is not 1,2,3,4
select * from movies
where actor_id not in (1,2,3,4);

--18. get all actors where bith date between 1991 and 1995
select * from actors
where date_of_birth between '1991-01-01' and '1995-12-31';

--19. get all movies where domestic revenue are between 100 and 300
select * from movies_revenues
where domestic_revenue between '100' and '300';

--20. partial character search using '%'
select 'hello' like 'h%'
select 'hello' like '%e%'
select 'hello' like '%ll'
select 'hello' like '_ello'
select 'hello' like '__lL_'
select 'hello' like '%ll_'

--21. get all the actor name starting anme 'A'
select * from actors
where first_name like 'A%';

--22. get all the names where last name ending with 'a'
select * from actors
where last_name like '%e';

--23. get all names with 5 characters 
select * from actors
where first_name like '_____';

--24. get all ators first_name and last_name contains 'l' on the second place
select * from actors
where first_name like '_l%';

--25. get the top 5 movies from the 5th record onwards by long movie length
select * from movies
order by movie_length desc
offset 5
fetch first 5 rows only

--26. lets combine first name and last name
select concat(first_name, ' ', last_name) as new_name
from actors;

select first_name || ' ' || last_name
from actors;

--27. pint first_name, last_name, date_of_birth of all actors separator by comma
select concat_ws(',',first_name, last_name, date_of_birth) 
from actors;
