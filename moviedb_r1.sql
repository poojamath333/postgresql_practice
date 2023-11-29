-- 1. cretaing table
create table customers (
	customer_id serial  primary key,
	first_name varchar(50),
	last_name varchar(50),
	email varchar(150),
	age int
);

--2. inserting values into the table
insert into customers (first_name, last_name, email, age)
values('Adnan', 'Waheed', 'a@b.com', 40);

--3. inserting multiple values
insert into customers(first_name, last_name)
values
('Adanan', 'Waheed'),
('John', 'Adams'),
('Linda', 'abe');

--4. insering first_name as "Bill'o Sullivan"
insert into customers(first_name)
values('Bill"o"sullivan');

update customers
set first_name = 'Bill''0 sullivan'
where customer_id = 5;

--5. RETURNING to get info an returns rows
insert into customers(first_name)
values ('joseph') returning *;

--6. UPDATE single column record in a table
update customers 
set email = 'a2@b.com'
where customer_id = 1;

--7. UPDATE multiple column record in a table
update customers 
set email = 'a4@b.com', age = 30
where customer_id = 1;

--8. returning to get updated rows
update customers 
set email = 'ac@b.com', age = 40
where customer_id = 4 returning *;

--9. UPDATE all records in a table
update customers 
set age = 35;

--10. DELETE records based on condition
delete from customers
where customer_id = 9;

--11. DELETE all records
delete from customers;

--12. UPSERT 
create table t_tags(
	id serial primary key,
	tag text unique,
	update_dtae timestamp default now()
);

insert into t_tags (tag)
values ('Pen'), ('Pencil');

-----------------------------------------
--12.1 insert a records, on conflict do nothing
insert into t_tags (tag)
values ('pen')
on conflict 
do nothing;

--12.2 insert a records, on conflict set new values 
insert into t_tags (tag)
values ('pen')
on conflict (tag)
do 
update set 
tag = excluded.tag,
update_dtae = now();



