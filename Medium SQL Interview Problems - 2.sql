/* There are 2 tables, first table has 5 records and second table has 10 records.
you can assume any value in each of the tables. How many maximum and minimum records 
possible in case of inner join, left join, right join and full outer join.*/
create table t1 (id int);
create table t2 (id int);
create table t3 (id int);

insert into t1 
values (1),(1),(1),(1),(1)

insert into t2
values (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)

insert into t3
values (2),(2),(2),(2),(2),(2),(2),(2),(2),(2)

-- Maximum
select *
from t1
inner join t2
on t1.id = t2.id

select *
from t1
left join t2
on t1.id = t2.id

select *
from t1
right join t2
on t1.id = t2.id

select *
from t1
full outer join t2
on t1.id = t2.id

-- Minimum 
select *
from t1
inner join t3
on t1.id = t3.id

select *
from t1
left join t3
on t1.id = t3.id

select *
from t1
right join t3
on t1.id = t3.id

select *
from t1
full outer join t3
on t1.id = t3.id

/* write a query to print highest and lowest salary emp in each dept.*/
create table employee 
(
emp_name varchar(10),
dep_id int,
salary int
);

delete from employee;

insert into employee values 
('Siva',1,30000),('Ravi',2,40000),('Prasad',1,50000),('Sai',2,20000)

(select dep_id, max(salary) as salary, 'max_salary'
from employee
group by dep_id
order by 1 )
union 
(select dep_id, min(salary) as salary, 'min_salary'
from employee
group by dep_id
order by 1)
------------------------------------------------------------------------
with cte as 
(select dep_id, max(salary) as max_salary, min(salary) as min_salary
from employee 
group by 1
)
select e.dep_id, 
max(case when salary = c.max_salary then emp_name else null end) max_salary,
max(case when salary = c.min_salary then emp_name else null end) min_salary
from employee e
inner join cte c
on e.dep_id = c.dep_id
group by 1;
--------------------------------------------------------------
with cte as 
(select *,
row_number() over (partition by dep_id order by salary desc) as rank_desc,
row_number() over (partition by dep_id order by salary asc) as rank_asc
from employee
)
select e.dep_id, 
max(case when rank_desc = 1 then e.emp_name else null end) max_salary,
max(case when rank_asc = 1 then e.emp_name else null end) min_salary
from employee e
inner join cte c
on e.dep_id = c.dep_id
group by 1;

----------------------------------------------------------------------------
/* write a query to get start time and end time of each call below 2 tables.
 also create a call duration in minutes. Please do not take into account that 
 there will be multiple calls from one number and each entry in start table has a 
 corresponding entry in end table */

create table call_start_logs
(
phone_number varchar(10),
start_time timestamp
);

insert into call_start_logs values
('PN1','2022-01-01 10:20:00'),('PN1','2022-01-01 16:25:00'),('PN2','2022-01-01 12:30:00')
,('PN3','2022-01-02 10:00:00'),('PN3','2022-01-02 12:30:00'),('PN3','2022-01-03 09:20:00')

create table call_end_logs
(
phone_number varchar(10),
end_time timestamp
);

insert into call_end_logs values
('PN1','2022-01-01 10:45:00'),('PN1','2022-01-01 17:05:00'),('PN2','2022-01-01 12:55:00')
,('PN3','2022-01-02 10:20:00'),('PN3','2022-01-02 12:50:00'),('PN3','2022-01-03 09:40:00')
;


