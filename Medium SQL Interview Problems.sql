CREATE TABLE events (
ID int,
event varchar(255),
YEAR INt,
GOLD varchar(255),
SILVER varchar(255),
BRONZE varchar(255)
);

delete from events;

INSERT INTO events VALUES (1,'100m',2016, 'Amthhew Mcgarray','donald','barbara');
INSERT INTO events VALUES (2,'200m',2016, 'Nichole','Alvaro Eaton','janet Smith');
INSERT INTO events VALUES (3,'500m',2016, 'Charles','Nichole','Susana');
INSERT INTO events VALUES (4,'100m',2016, 'Ronald','maria','paula');
INSERT INTO events VALUES (5,'200m',2016, 'Alfred','carol','Steven');
INSERT INTO events VALUES (6,'500m',2016, 'Nichole','Alfred','Brandon');
INSERT INTO events VALUES (7,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events VALUES (8,'200m',2016, 'Thomas','Dawn','catherine');
INSERT INTO events VALUES (9,'500m',2016, 'Thomas','Dennis','paula');
INSERT INTO events VALUES (10,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events VALUES (11,'200m',2016, 'jessica','Donald','Stefeney');
INSERT INTO events VALUES (12,'500m',2016,'Thomas','Steven','Catherine');

select * from events;

--1. Write a query to find no of gold medal per swimmer for swimmer who won only gold medals.
select gold as player_name, count(*) as no_of_gold_medals
from events 
where gold not in (select silver from events union all select bronze from events)
group by 1

-------------------------------------------------------------------------------

create table tickets
(
ticket_id varchar(10),
create_date date,
resolved_date date
);

delete from tickets;

insert into tickets values
(1,'2022-08-01','2022-08-03')
,(2,'2022-08-01','2022-08-12')
,(3,'2022-08-01','2022-08-16');

create table holidays
(
holiday_date date
,reason varchar(100)
);

delete from holidays;

insert into holidays values
('2022-08-11','Rakhi'),('2022-08-15','Independence day');

select * from holidays;
select * from tickets ;

--2. write a sql to find the business day bewtween create date and resolved date by excluding weekends and holidays
with cte as (
select ticket_id, create_date, resolved_date, holiday_date,
(resolved_date - create_date) as total_days_resolve, 
extract(week from resolved_date) - extract(week from create_date) as weeks_diff,
count(holiday_date) as no_of_holidays
from tickets t
left join holidays h
on h.holiday_date between t.create_date and t.resolved_date
group by 1,2,3,4
)
select ticket_id, ticket_id, create_date, resolved_date,((total_days_resolve - 2*weeks_diff) - no_of_holidays) as resolved_days
from cte

------------------------------------------------------------------------------------------
create table hospital ( emp_id int
, action varchar(10)
, time timestamp);

insert into hospital values ('1', 'in', '2019-12-22 09:00:00');
insert into hospital values ('1', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:00:00');
insert into hospital values ('2', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:30:00');
insert into hospital values ('3', 'out', '2019-12-22 09:00:00');
insert into hospital values ('3', 'in', '2019-12-22 09:15:00');
insert into hospital values ('3', 'out', '2019-12-22 09:30:00');
insert into hospital values ('3', 'in', '2019-12-22 09:45:00');
insert into hospital values ('4', 'in', '2019-12-22 09:45:00');
insert into hospital values ('5', 'out', '2019-12-22 09:40:00');

select * from hospital ;

-- 3. Write a sql to find the total numbers of employee present inside the hospital
with latest_time as (
select emp_id, max(time) as latest_time
from hospital 
group by 1
),
latest_in_time as (
select emp_id, max(time) as latest_in_time
from hospital
where action = 'in'
group by 1
)
select lt.emp_id, latest_time 
from latest_time lt
inner join latest_in_time lit
on lt.emp_id = lit.emp_id and latest_in_time = latest_time;

------------------------------------------------------------------------------------------
create table airbnb_searches 
(
user_id int,
date_searched date,
filter_room_types varchar(200)
);

delete from airbnb_searches;

insert into airbnb_searches values
(1,'2022-01-01','entire home,private room')
,(2,'2022-01-02','entire home,shared room')
,(3,'2022-01-02','private room,shared room')
,(4,'2022-01-03','private room')
;

select * from airbnb_searches ;
/* 4. Find the room type that has searched most number of times.
output the room type alongside no of search for it.
if the filter for room type has more than one room type,
consider each room type as a unique room as separte row.
sort the result based on no. of search in descending order.*/

select unnest (string_to_array(filter_room_types, ',')), count(*)
from airbnb_searches 
group by 1
order by 2 desc ;

-----------------------------------------------------------------------------------------
CREATE TABLE emp_salary
(
    emp_id INTEGER  NOT NULL,
    name VARCHAR(20)  NOT NULL,
    salary VARCHAR(30),
    dept_id INTEGER
);


INSERT INTO emp_salary
(emp_id, name, salary, dept_id)
VALUES(101, 'sohan', '3000', '11'),
(102, 'rohan', '4000', '12'),
(103, 'mohan', '5000', '13'),
(104, 'cat', '3000', '11'),
(105, 'suresh', '4000', '12'),
(109, 'mahesh', '7000', '12'),
(108, 'kamal', '8000', '11');
 
select * from emp_salary ;

-- 5. write a Sql query to return all employees whose salary is same in same department

with cte as (
select dept_id, salary  
from emp_salary 
group by 1, 2
having count(1) > 1)
select e.*
from cte e
inner join emp_salary d
on e.dept_id = d.dept_id and e.salary = d.salary












