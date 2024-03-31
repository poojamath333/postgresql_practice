-- Addition and substraction using formula
create table input (
id int,
formula varchar(10),
value int
)

insert into input values (1,'1+4',10),(2,'2+1',5),(3,'3-2',40),(4,'4-1',20);

with cte as (
select *, cast(left(formula, 1)as int) as d1, cast(right(formula, 1)as int) as d2, substring(formula, 2, 1) as o
from input
)
select cte.id, cte.formula, cte.value, i1.value as f1_value, i2.value as f2_value,
case when cte.o = '+' then (i1.value + i2.value)
	 when cte.o = '-' then (i1.value - i2.value) 
	 end  as Total_value
from cte 
inner join input i1 on cte.d1 = i1.id
inner join input i2 on cte.d2 = i2.id

------------------------------------------------------------------------------------
-- Condn 1 - crt1 and crt 2 shd be Y 
-- Condn 2 - In a team atleast 2 person should qualified 1st condn


create table Ameriprise_LLC
(
teamID varchar(2),
memberID varchar(10),
Criteria1 varchar(1),
Criteria2 varchar(1)
);

insert into Ameriprise_LLC values 
('T1','T1_mbr1','Y','Y'),
('T1','T1_mbr2','Y','Y'),
('T1','T1_mbr3','Y','Y'),
('T1','T1_mbr4','Y','Y'),
('T1','T1_mbr5','Y','N'),
('T2','T2_mbr1','Y','Y'),
('T2','T2_mbr2','Y','N'),
('T2','T2_mbr3','N','Y'),
('T2','T2_mbr4','N','N'),
('T2','T2_mbr5','N','N'),
('T3','T3_mbr1','Y','Y'),
('T3','T3_mbr2','Y','Y'),
('T3','T3_mbr3','N','Y'),
('T3','T3_mbr4','N','Y'),
('T3','T3_mbr5','Y','N');

with cte as (
select teamid, count(*) as no_of_eligible_team
from Ameriprise_LLC 
where Criteria1 = 'Y' and Criteria2 = 'Y'
group by teamid
having count(*) >= 2)
select *, 
(case when Criteria1 = 'Y' and Criteria2 = 'Y' and c.teamid is not null then 'Y' else 'N' end ) as eligible
from Ameriprise_LLC a
left join cte c 
on a.teamid = c.teamid

---------------------------------------------------------------------------------------------------------
-- pair adult and child based on age if adult have high the age then he will be paire with low age child 

create table family 
(
person varchar(5),
type varchar(10),
age int
);

delete from family ;

insert into family 
values 
('A1','Adult',54),
('A2','Adult',53),
('A3','Adult',52),
('A4','Adult',58),
('A5','Adult',54),
('C1','Child',20),
('C2','Child',19),
('C3','Child',22),
('C4','Child',15);

with adults as 
(select person, type as adults, age, row_number () over (order by age desc) as rn
from family 
where type = 'Adult'),
childs as (select person, type as adults, age, row_number () over (order by age asc) as rn
from family 
where type = 'Child')
select a.person, c.person
from adults a
left join childs c 
on a.rn = c.rn;

------------------------------------------------------------------------------------------

-- Find the company whose revenue is increasing every year.

create table company_revenue 
(
company varchar(100),
year int,
revenue int
)

insert into company_revenue
values 
('ABC1',2000,100),
('ABC1',2001,110),
('ABC1',2002,120),
('ABC2',2000,100),
('ABC2',2001,90),
('ABC2',2002,120),
('ABC3',2000,500),
('ABC3',2001,400),
('ABC3',2002,600),
('ABC3',2003,800);

with cte as (
select *, 
lag(revenue,1,0) over (partition by company order by year) as last_revenue,
revenue - lag(revenue,1,0) over (partition by company order by year) as diff_revenu,
count(1) over (partition by company) as comp_cnt
from company_revenue 
)
select company, comp_cnt, count(1) as revenue_inc_cnt
from cte
where diff_revenu > 0 
group by 1,2
having comp_cnt = count(1);






