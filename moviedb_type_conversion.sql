-- string to integer conversion
select cast('10' as integer); or select '10' :: integer;

---- string to date conversion
select cast('2020-01-01' as date);

---- string to boolean conversion
select cast('true' as boolean);

-- Convert all values in the rating column into integeres.
create table ratings
(rating_id serial, rating varchar(1) not null);

insert into ratings (rating)
values ('A'),('B'),('C'),('D'),(1),(2),(3),(4);

select rating_id,
case when rating~e'^\\d+$' then 
	cast (rating as integer)
	else 0
	end as rating
from ratings;

--