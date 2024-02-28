CREATE TABLE input_val (
id int8, formula varchar(250), value int8
);

INSERT INTO input_val 
(id, formula, value)
VALUES (1, '1+4', 10), 
(2, '2+1', 5), (
3, '3-2', 40), 
(4, '4-1', 20);


SELECT * FROM input_val;


WITH cte AS (
SELECT *, CAST (LEFT(formula, 1) AS NUMERIC) AS d1, CAST (RIGHT(formula, 1) AS NUMERIC) AS d2, (substring(formula, 2,1) ) AS operation
FROM input_val)
SELECT cte.id, cte.formula, cte.value,
CASE 
	WHEN operation = '+' THEN i1.value + i2.value 
	WHEN operation = '-' THEN i1.value - i2.value
END AS result
FROM cte 
INNER JOIN input_val AS i1
ON cte.d1 = i1.id
INNER JOIN input_val AS i2 
ON cte.d2 = i2.id;


---------------------------------------------------------------------------------------------------------
CREATE TABLE events 
(id int8,
event_type varchar(250), 
event_year int4,
gold varchar(250),
silver varchar(250), 
bronge varchar(250)
);

INSERT INTO events 
(id ,event_type, event_year, gold, silver, bronge)
VALUES (1, '100m', 2016, 'Amthhew Mogarray', 'Donald', 'Barbara' ),
(2, '200m', 2016, 'Nichole', 'Alvaro Eaton', 'Jonet Smith' ),
(3, '500m', 2016, 'Charles', 'Nichole', 'Susana' ),
(4, '100m', 2016, 'Ronald', 'Maria', 'Paula' ),
(5, '200m', 2016, 'Alfred', 'Carol', 'Steven' ),
(6, '500m', 2016, 'Nichole', 'Alfred','Brandon' ),
(7, '100m', 2016, 'Charles', 'Dennis', 'Susana' ),
(8, '200m', 2016, 'Thomas', 'Dawan', 'Catherine' ),
(9, '500m', 2016, 'Thomas', 'Dennis','Paula' ),
(10, '100m', 2016, 'Charles', 'Dennis', 'Susana' ),
(11, '200m', 2016, 'Jessica', 'Donald', 'Stefeney' ),
(12, '500m', 2016, 'Thomas', 'Steven','Catherine' );

SELECT gold AS player, count(*) AS no_of_gold_medals
FROM events
WHERE gold NOT IN (SELECT silver FROM events UNION ALL SELECT bronge FROM events )
GROUP BY 1;

-----------------------------------------------------------------------------------------------------------------------
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

WITH cte AS (
SELECT ticket_id, create_date, resolved_date, ( resolved_date - create_date) AS actual_days, 
((EXTRACT (week FROM resolved_date)) - (EXTRACT  (week FROM create_date))) AS actual_weeks, 
count(holiday_date) AS no_of_holidays 
FROM tickets t
LEFT JOIN holidays h
ON h.holiday_date BETWEEN t.create_date AND t.resolved_date
GROUP BY 1,2,3,4,5
)
SELECT ticket_id, create_date, resolved_date, ((actual_days - 2* actual_weeks)- no_of_holidays) AS no_of_days
FROM cte

---------------------------------------------------------------------------------------------------------------------
create table hospital 
( emp_id int, 
action varchar(10),
time timestamp);

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

WITH cte AS (
SELECT emp_id, 
max(CASE WHEN ACTION = 'in' THEN time END) AS in_time,
max(CASE WHEN ACTION = 'out' THEN time END) AS out_time
FROM hospital 
GROUP BY 1)
SELECT * FROM cte 
WHERE in_time > out_time OR out_time IS NULL ;

-------------------------------------------------------------------------------------------------------------------
create table airbnb_searches 
(
user_id int,
date_searched date,
filter_room_types varchar(200)
);
delete from airbnb_searches;
insert into airbnb_searches values
(1,'2022-01-01','entire home,private room'),
(2,'2022-01-02','entire home,shared room'),
(3,'2022-01-02','private room,shared room'),
(4,'2022-01-03','private room');

SELECT * FROM airbnb_searches;

WITH cte AS (
SELECT *, UNNEST 
(string_to_array(filter_room_types, ',')) AS room_types
FROM airbnb_searches 
)
SELECT room_types AS value, count(*)
FROM cte 
GROUP BY 1
ORDER BY 2 DESC ;

----------------------------------------------------------------------------------------------------------------------
CREATE TABLE emp_salary
(
    emp_id INTEGER  NOT NULL,
    emp_name VARCHAR(20)  NOT NULL,
    salary VARCHAR(30),
    dept_id INTEGER
);


INSERT INTO emp_salary
(emp_id, emp_name, salary, dept_id)
VALUES(101, 'sohan', '3000', '11'),
(102, 'rohan', '4000', '12'),
(103, 'mohan', '5000', '13'),
(104, 'cat', '3000', '11'),
(105, 'suresh', '4000', '12'),
(109, 'mahesh', '7000', '12'),
(108, 'kamal', '8000', '11');

SELECT * FROM emp_salary;

WITH cte AS (
SELECT dept_id, salary
FROM emp_salary 
GROUP BY 1,2
HAVING count(*) > 1
) 
SELECT e.* FROM emp_salary e
INNER JOIN cte 
ON e.dept_id = cte.dept_id AND e.salary = cte.salary;




