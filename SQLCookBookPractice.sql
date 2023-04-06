/*CHAPTER 1
Retrieving Records*/

/* You have a table and want to see all of the data in it */.
select * from employees;

/* You have a table and want to see only rows that satisfy a specific condition */
select * from employees
where salary >2000;


/* you want to return rows that satisfy multiple condition */
select * from employees
where employee_id >= 110
and salary > 5000;


/* You have table and want to see values for speific column rather than for all the columns.*/
select email from employees;

/* You would like to changes of the names of the columns that are returned by your  
querry so that they are more readable and understable*/
select salary as employees_salary from employees; 
/* New renamed columns are called alias */

/* You have used aliases to provide more meaningful column names for your result set
and would like to exclude some of the rows using the WHERE clause. However, your
attempt to reference alias names in the WHERE clause fails*/
select avg(salary) as avg_salary, department_id
from employees 
where avg_salary <5000
group by department_id;

select * from 
(select avg(salary) as avg_salary, department_id
from employees
group by department_id) x
where avg_salary < 5000;

/* You want to return values in multiple columns as one column.*/
select concat(first_name, ' ', last_name) as full_name
from employees

select first_name || ' ' || last_name as full_name
from employees

select first_name || ' ' || last_name || ' phone number is ' || phone_number
from employees;

/*You want to perform IF-ELSE operations on values in your SELECT statement. For
example, you would like to produce a result set such that if an employee is paid
$2,000 or less, a message of “UNDERPAID” is returned; if an employee is paid $4,000
or more, a message of “OVERPAID” is returned; and if they make somewhere in
between, then “OK” is returned*/
select concat(first_name, ' ', last_name) as full_name,
	case when salary <=4000 then 'underpaid'
		when salary >=8000 then 'overpaid'
		else 'ok'
		end
		as status
from employees;

/*You want to limit the number of rows returned in your query*/
select employee_id, salary
from employees
limit 5;

select * 
from (select employee_id, salary 
from employees
order by salary asc
limit 5) x
order by salary desc;

/*You want to return a specific number of random records from a table*/
select employee_id, salary
from employees
order by random() limit 10;

/*You want to find all rows that are null for a particular column. */
select employee_id, first_name, last_name
from employees
where manager_id is null;

/*You have rows that contain nulls and would like to return non-null values in place of
those nulls.*/
select coalesce(manager_id,0)
from employees;

select first_name, last_name,
	(case
		when manager_id is not null then manager_id
		else 0
		end)
	from employees;
		
/*You want to return rows that match a particular substring or pattern*/
select first_name, last_name
from employees
where manager_id in (100,120)
and (first_name like '%e%' or last_name like '%y');

----------------------------------------------------------------------------------------------------------

/*CHAPTER 2
Sorting Query Results*/

/*You want to display the names, jobs, and salaries of employees in department 10 in
order based on their salary (from lowest to highest)*/
select concat(first_name,' ',last_name) as names, job_id, salary
from employees
where department_id = 10
order by salary asc;

/*You want to sort the rows from EMP first by DEPTNO ascending, then by salary
descending.*/
select first_name, last_name, employee_id, department_id, salary
from employees
order by department_id desc, salary desc;

/*You want to sort the results of a query by specific parts of a string.*/
select first_name, substr(first_name,length(first_name)-2) as substr
from employees
order by substr(first_name,length(first_name)-2)

/*You have mixed alphanumeric data and want to sort by either the numeric or charac‐
ter portion of the data */
select * 
from (select concat(first_name, ' ', job_id) as name_job_id
from employees) as x 
order by substr(name_job_id, length(name_job_id)-1)

create view name_job_id
as (select concat(first_name, ' ', job_id) as name_job_id
from employees)

select name_job_id, 
translate(name_job_id,'0123456789','##########') as translate_one,
replace(translate(name_job_id,'0123456789','##########'),'#','') as replace_one, 
replace(name_job_id,replace(translate(name_job_id,'0123456789','##########'),'#',''),'') as replace_two
from name_job_id
order by replace_two ;


/*You want to sort results from EMP by COMM, but the field is nullable. You need a
way to specify whether nulls sort last:*/

select first_name, manager_id
from
	(select first_name, manager_id,
	 case when manager_id is null then 0
			end 
	 		as manager_id_null
	from employees) x
order by manager_id_null desc;
	
/*You want to sort based on some conditional logic. For example, if JOB is SALES‐
MAN, you want to sort on COMM; otherwise, you want to sort by SAL.*/

select e.first_name, e.salary, d.department_name, (case when d.department_name = 'Marketing' then e.first_name
		  	else department_name
				end ) as ordered
from employees e
left join departments d
on e.department_id = d.department_id
order by (case when department_name = 'Marketing' then first_name
		  	else department_name
				end ) desc
				
				
				
-----------------------------------------------------------------------------------------------------				

/* CHAPTER 3
Working with Multiple Tables */		
	
/*You want to return data stored in more than one table, conceptually stacking one
result set atop the other. The tables do not necessarily have a common key, but their
columns do have the same data types*/

select first_name, department_id
from employees
where department_id = 10
union all

select '........', null
from (select '........', null as x) t1
union all

select department_name, department_id
from departments;

***(/*Specifying UNION rather than UNION ALL will most likely result in a sort opera‐
tion to eliminate duplicates*/)***

/*You want to return rows from multiple tables by joining on a known common col‐
umn or joining on columns that share common values.*/

select e.first_name, e.last_name, d.department_name
from employees e, departments d
where e.department_id = d.department_id
and e.department_id = 10;

/*You want to find common rows between two tables, but there are multiple columns
on which you can join.*/

create view  v 
as (select first_name, last_name, job_id, salary
from employees)

select * from v	
	
select e.first_name, e.last_name, e.job_id, e.salary, e.department_id
from employees e, v
where e.first_name = v.first_name
and  e.last_name = v.last_name
and e.salary = v.salary

/*You want to find those values in one table, call it the source table, that do not also
exist in some target table.*/

insert into departments
values (12, 'random dept', null)

select department_id 
from departments 
except 
select department_id 
from employees

select department_id 
from departments
where department_id 
not in (select department_id from employees)



/* OR | T | F | N |
+----+---+---+----+
| T | T | T | T |
| F | T | F | N |
| N | T | N | N |
+----+---+---+----+


 NOT |
+-----+---+
| T | F |
| F | T |
| N | N |
+-----+---+


 AND | T | F | N |
+-----+---+---+---+
| T | T | F | N |
| F | F | F | F |
| N | N | F | N |
+-----+---+---+---+ */


/*You want to find rows that are in one table that do not have a match in another table,
for two tables that have common keys.*/

select d.department_id, d.department_name, l.city
from departments d
left join locations l
on d.location_id = l.location_id

/*You have a query that returns the results you want. You need additional information,
but when trying to get it, you lose data from the original result set.*/

select c.country_name, x.department_name
from
(select d.department_id, d.department_name, l.country_id, l.city
from departments d
left join locations l
on d.location_id = l.location_id) as x
left join countries c
on x.country_id = c.country_id
order by country_name ;	
	
/*You want to know whether two tables or views have the same data (cardinality and
values). */

create view dummy_emp
as 
select * from employees
where department_id != 10
union all
select * from employees 
where first_name = 'John'

(select first_name, last_name, department_id, hire_date, email , count(*) as cnt
from dummy_emp
group by first_name, last_name, department_id, hire_date, email
except
select first_name, last_name, department_id, hire_date, email, count(*) as cnt
from employees
group by first_name, last_name, department_id, hire_date, email)

union all

(select first_name, last_name, department_id, hire_date, email, count(*) as cnt
from employees
group by first_name, last_name, department_id, hire_date, email
except
select first_name, last_name, department_id, hire_date, email, count(*) as cnt
from dummy_emp
group by first_name, last_name, department_id, hire_date, email)
	
	
/*You want to return the name of each employee in department 10 along with the loca‐
tion of the department. */

select x.first_name, x.last_name, x.department_id, l.city
from 
(select e.first_name,e.last_name, e.department_id, d.location_id
from employees e
left join departments d
on e.department_id = d.department_id
where e.department_id = 10 ) as x
left join locations l
on x.location_id = l.location_id;

	
/*You want to perform an aggregation, but your query involves multiple tables. You
want to ensure that joins do not disrupt the aggregation.*/

create table emp_bonus
(emp_no int, 
received varchar,
 bonus_type int)

insert into emp_bonus
values (7934,'17-mar-2005',1), 
(7934, '15-feb-2005', 2), 
(7839, '15-feb-2005', 3),
(7782, '15-feb-2005', 1)

select * from emp_bonus
select * from employees 

alter table employee_bouns rename to employee_bonus

commit 

alter table employee_bonus rename column emp_no to employee_id

update employee_bonus 
set employee_id = 101
where employee_id = 7934

update employee_bonus 
set employee_id = 105
where employee_id = 7839	

update employee_bonus 
set employee_id = 110
where employee_id = 7782


select employee_id, department_id, sum(salary) as total_salary
from employees
group by 1, 2
order by 1, 2 desc

select x.department_id,
	   x.total_salary,
	   sum(e.salary * case when eb.bonus_type = 1 then 0.1
		   				  when eb.bonus_type = 2 then 0.2
		   				  when eb.bonus_type = 3 then 0.3
		   			end) 
					as total_bonus
from employees e, employee_bonus eb,
(select department_id, sum(salary) as total_salary 
from employees
where department_id in (6,9,10)
group by department_id) as x
where e.department_id = x.department_id
	and e.employee_id = eb.employee_id
group by x.department_id, x.total_salary 


select * from employee_bonus


/*You want to return missing data from multiple tables simultaneously. Returning rows
from table DEPT that do not exist in table EMP (any departments that have no
employees) requires an outer join.*/

select e.first_name, e.last_name, d.department_name
from employees e
full outer join departments d 
on e.department_id = d.department_id


-------------------------------------------------------------------------------------------------

/*CHAPTER 4
Inserting, Updating, and Deleting*/


/* You want to insert a new record into a table. For example, you want to insert a new
record into the DEPT table. The value for DEPTID should be 50, DNAME should be
PROGRAMMING,.*/

insert into departments
(department_id, department_name)
values (60, 'Mechanical'),
		(70, 'Sports')

/* A table can be defined to take default values for specific columns. You want to insert a
row of default values without having to specify those values.*/
insert into D default values

/*You are inserting into a column having a default value, and you want to override that
default value by setting the column to NULL.*/
create table D
(id integer default 0, 
 foo varchar (10))

insert into D
(id, foo) 
values (null, 'Brighten')

/* You want to copy rows from one table to another by using a query. The query may be
complex or simple, but ultimately you want the result to be inserted into another table.*/

create table department_east
(department_id integer,
 department_name varchar, 
 location_id integer)


insert into department_east (department_id, department_name, location_id)
select deaprtment_id, department_name, location_id
from departments
where location_id in (1700,1500)

/*You want to create a new table having the same set of columns as an existing table.*/
create table departments_2
as 
select * from departments 
where 1 = 0

/*You want to take rows returned by a query and insert those rows into multiple target
tables.*/

/*You want to prevent users, or an errant software application, from inserting values
into certain table columns */

create view new_employees as 
select employee_id, first_name, job_id
from employees

insert into new_employees
(employee_id, first_name, job_id)
values (101, 'John', 4)


select * from employees
select * from departments

/*You want to modify values for some or all rows in a table.*/
update employees
set salary = salary*1.10
where department_id = 10

/*You want to update rows in one table when corresponding rows exist in another.*/
update employees
set salary = salary*1.10
where employee_id in (select employee_id from employee_bonus )

/*You want to update rows in one table using values from another.*/

create table new_salary
(department_id integer,
salary integer)

insert into new_salary
values (10, 4000)

update employees as e
set salary = ns.salary
from new_salary as ns
where ns.department_id = e.department_id

/*You want to conditionally insert, update, or delete records in a table depending on
whether corresponding records exist.*/

alter table employees
add column commission integer

update employees
set commission = 1000
where employee_id = 101


update employees
set commission = 0
where employee_id = 104

update employees
set commission = 2000
where employee_id = 110

create table employee_commission as 
(select * from employees)

merge into employee_commission ec
using (select * from employees) e
on e.employee_id = ec.employee_id
when matched then 
	update set ec.commsion = 1000
	delete where (salary < 2000)
when not matched then
	insert (ec.employee_id, ec.first_name, ec.department_id, ec.commssion)
	values (e.employee_id, e.first_name, e.department_id, e.commssion)

/*You want to delete all the records from a table.*/
delete from employees

/*You want to delete records meeting a specific criterion from a table.*/
delete from employees 
where deptno = 10

/*You want to delete a single record from a table*/
delete from employees
where employee_id = 101

/*You want to delete records from a table when those records refer to nonexistent
records in some other table. */
delete from employees e
where not exists 
(select * from departments d
where d.department_id = e.department_id)

alternate

delete from employees
where deptartment_id not in (select department_id from deptartments)

/*You want to delete duplicate records from a table.*/

create table dupes
(employee_id integer, first_name varchar)

select * from employees

insert into dupes
values(100, 'steven')
	  
insert into dupes
values	(102, 'Lex')

insert into dupes
values(103, 'Alexander')

delete from dupes
where employee_id not in (select min(employee_id)
						from dupes
						group by first_name)


/*You want to delete records from one table when those records are referenced from
some other table.*/
create table department_accidents
(department_id integer,
accident_name varchar(20))

insert into department_accidents
values (10, 'Broken Foot')

insert into department_accidents
values (20, 'Broken Foot')

insert into department_accidents
values (10, 'Fire')

delete from employees
where department_id in (select department_id
					   from department_accidents
					   group by department_id
					   having count(*)<= 3)
					   
					   
					   

-----------------------------------------------------------------------------------------------------------


/*CHAPTER 5
Metadata Queries*/


/*You want to see a list of all the tables you’ve created in a given schema.*/

select * 
from information_schema.tables
where table_type = 'VIEW'


/*You want to list the columns in a table, along with their data types, and their position
in the table they are in. */

select *
from information_schema.columns
where table_schema = 'public'
and table_name = 'employees'

/*You want list indexes, their columns, and the column position (if available) in the
index for a given table.*/

select a.tablename,a.indexname,b.column_name
from pg_catalog.pg_indexes a,
information_schema.columns b
where a.schemaname = 'public'
and a.tablename = b.table_name
order by a.tablename desc

/*You want to list the constraints defined for a table in some schema and the columns
they are defined on.*/

select a.table_name,
a.constraint_name,
b.column_name,
a.constraint_type
from information_schema.table_constraints a,
information_schema.key_column_usage b
where a.table_name = 'employees'
and a.table_schema = 'public'
and a.table_name = b.table_name
and a.table_schema = b.table_schema
and a.constraint_name = b.constraint_name


/*You want to list tables that have foreign key columns that are not indexed.*/

select fkeys.table_name,
fkeys.constraint_name,
fkeys.column_name,
ind_cols.indexname
from (
select a.constraint_schema,
a.table_name,
a.constraint_name,
a.column_name
from information_schema.key_column_usage a,
information_schema.referential_constraints b
where a.constraint_name = b.constraint_name
and a.constraint_schema = b.constraint_schema
and a.constraint_schema = 'view'
and a.table_name = 'employees'
) fkeys
left join
(
select a.schemaname, a.tablename, a.indexname, b.column_name
from pg_catalog.pg_indexes a,
information_schema.columns b
where a.tablename = b.table_name
and a.schemaname = b.table_schema
) ind_cols
on ( fkeys.constraint_schema = ind_cols.schemaname
and fkeys.table_name = ind_cols.tablename
and fkeys.column_name = ind_cols.column_name )
where ind_cols.indexname is null

/*You want to create dynamic SQL statements, perhaps to automate maintenance tasks.
You want to accomplish three tasks in particular: count the number of rows in your
tables, disable foreign key constraints defined on your tables, and generate insert
scripts from the data in your tables.*/


---------------------------------------------------------------------------------------------

/* CHAPTER 6
Working with Strings */

/*You want to traverse a string to return each character as a row, but SQL lacks a loop
operation. For example, you want to display the ENAME “KING” from table EMP as
four rows, where each row contains just characters from KING.*/
select substring(e.first_name, iter.pos, 1) s
from (select first_name from employees
	 where first_name = 'Steven') e,
	 (select id as pos from t10 )iter
where iter.pos <= length(e.first_name) 


/*You want to embed quote marks within string literals. You would like to produce
results such as the following with SQL:
QMARKS
--------------
g'day mate
beavers' teeth */

insert into t1 (anything)
values (1)

select * from t1

select 'g''day mate' as QMARKS from t1 
union all
select 'beavers'' teeth' as QMARKS from t1
union all 
select '''' as QMARKS from t1

select 'apples core', 'apples''s core',
	case when '' is null then 0
	else 1
	end
from t1

/* You want to count the number of times a character or substring occurs within a given
string. Consider the following string:
10,CLARK,MANAGER
You want to determine how many commas are in the string.*/

select (length('10,Clark,Manager') - length(replace('10,Clark,Manager',',','')))
from t1 

select (length ('POOJA POOJA')- length(replace('POOJA POOJA','OO', '')))/length('OO')
from t1
		
/* You want to remove specific characters from your data. A scenario where this may
occur is in dealing with badly formatted numeric data, especially currency data,
where commas have been used to separate zeros, and currency markers are mixed in
the column with the quantity. */

select first_name, replace(translate(first_name, 'aeiouAEIOU', 'aaaaaaaaaa'), 'a', '') as stripped_1,
		salary, replace(cast (salary as varchar(5)), '0', '') as stripped_2
from employees


/* You have numeric data stored with character data together in one column. This could
easily happen if you inherit data where units of measurement or currency have been
stored with their quantity (e.g., a column with 100 km, AUD$200, or 40 pounds,
rather than either the column making the units clear or a separate column showing
the units where necessary). */

select concat(first_name,salary) as name_salary from employees

Select replace (translate(x.name_salary, '0123456789.', '###########'), '#', '') as only_name,
replace(x.name_salary, replace(translate(x.name_salary, '0123456789.', '###########'), '#', ''),'') as only_salary
from (select concat(first_name,salary) as name_salary from employees) as x

Select replace (translate(x.name_salary, '0123456789.', '###########'), '#', '') as only_name,
cast(replace
	 (translate(lower(x.name_salary),'abcdefghijklmnopqrstuvwxyz', rpad('z', 26, 'z')), 'z', '') as float) as only_salary
from (select concat(first_name,salary) as name_salary from employees) as x

/* You want to return rows from a table only when a column of interest contains no
characters other than numbers and letters. Consider the following view V (SQL
Server users will use the operator + for concatenation instead of ||):*/

create view v_view as
select first_name as emp_data from employees
where department_id = 8 
union all 
select first_name ||', $'|| cast(salary as varchar(6)) as emp_data
from employees
where department_id = 9
union all
select first_name || cast(salary as varchar (6)) as emp_data
from employees
where department_id = 10

select * from v_view

select emp_data from v_view
where 
translate (lower(emp_data), '0123456789abcdefghijklmnopqrstuvwxyz', rpad('a',36,'a')) = rpad('a',length(emp_data),'a')


select emp_data, replace (replace(emp_data, ', $', '.'), '.', ' ')
from v_view


/* You want convert a full name into initials. Consider the following name:
Stewie Griffin 
You would like to return:
S.G. */

select concat(substr(first_name, 1, 1), '.',
			 substr(last_name, 1, 1), '.')
from employees;

select concat(replace 
	   (translate 
		(replace(e.full_name, ' ', '.'), 'abcdefghijklmnopqrstuvwxyz', rpad('#', 26, '#')), '#', ''), '.')
from (select concat ( first_name, ' ', last_name) as full_name from employees) as e 

/* You want to order your result set based on a substring. */
select first_name
from employees
order by substr(first_name, length (first_name) - 1)

/*You want order your result set based on a number within a string. */
create view V_com as
select e.first_name || ' '|| cast (e.employee_id as varchar(4)) || ' '|| d.department_name as mix_data
from employees e, departments d 
where e.department_id = d.department_id

select mix_data
from V_com 
order by 
	cast(
	replace( 
  	translate(mix_data, 
	replace( 
	translate(mix_data, '0123456789', '#'), '#', ''), rpad('#', 20, '#')), '#', ' ') as integer)

/* You want to return table rows as values in a delimited list, perhaps delimited by com‐
mas, rather than in vertical columns as they normally appear. */

select department_id, 
	string_agg(first_name, ',' order by employee_id ) as emp_dep
from employees
group by department_id
order by department_id







