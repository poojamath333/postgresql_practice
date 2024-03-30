 /* ICC CWC 2023 points table using sql */
 create table icc_world_cup
(
match_no int,
team_1 Varchar(20),
team_2 Varchar(20),
winner Varchar(20)
);

INSERT INTO icc_world_cup values(1,'ENG','NZ','NZ');
INSERT INTO icc_world_cup values(2,'PAK','NED','PAK');
INSERT INTO icc_world_cup values(3,'AFG','BAN','BAN');
INSERT INTO icc_world_cup values(4,'SA','SL','SA');
INSERT INTO icc_world_cup values(5,'AUS','IND','IND');
INSERT INTO icc_world_cup values(6,'NZ','NED','NZ');
INSERT INTO icc_world_cup values(7,'ENG','BAN','ENG');
INSERT INTO icc_world_cup values(8,'SL','PAK','PAK');
INSERT INTO icc_world_cup values(9,'AFG','IND','IND');
INSERT INTO icc_world_cup values(10,'SA','AUS','SA');
INSERT INTO icc_world_cup values(11,'BAN','NZ','NZ');
INSERT INTO icc_world_cup values(12,'PAK','IND','IND');
INSERT INTO icc_world_cup values(12,'SA','IND','DRAW');

select * from icc_world_cup ;

with matches as (
select team, sum(matches) as matches
from
	(select team_1  as team , count(*) as matches 
	from icc_world_cup 
	group by team_1 
	union 
	select team_2  as team , count(*) as matches 
	from icc_world_cup 
	group by team_2 ) a
group by  1
),
win as (
select winner as team, count(*) as win_match
from  icc_world_cup 
group by 1
)
select m.team, m.matches, coalesce(w.win_match,0) as win, (m.matches - coalesce(w.win_match,0)) as loss
from matches m 
left join win w
on m.team = w.team;

-- Another Solution

select team, sum(matches) as matches, sum(wins) as win, (sum(matches) - sum(wins)) as loss
from
	(select team_1  as team , count(*) as matches, sum(case when team_1 = winner then 1 else 0 end ) as wins
	from icc_world_cup 
	group by team_1 
	union 
	select team_2  as team , count(*) as matches, sum(case when team_1 = winner then 1 else 0 end ) as wins
	from icc_world_cup 
	group by team_2 ) a
group by  1;

---------------------------------------------------------------------------------
-- Find the origin and destination of each cid.

CREATE TABLE flights 
(
    cid VARCHAR(512),
    fid VARCHAR(512),
    origin VARCHAR(512),
    Destination VARCHAR(512)
);

INSERT INTO flights (cid, fid, origin, Destination) VALUES ('1', 'f1', 'Del', 'Hyd');
INSERT INTO flights (cid, fid, origin, Destination) VALUES ('1', 'f2', 'Hyd', 'Blr');
INSERT INTO flights (cid, fid, origin, Destination) VALUES ('2', 'f3', 'Mum', 'Agra');
INSERT INTO flights (cid, fid, origin, Destination) VALUES ('2', 'f4', 'Agra', 'Kol');

select o.cid, o.origin, d.destination
from flights o
inner join flights d
on o.destination = d.origin

---------------------------------------------------------------------------------
-- Find the count of new customers added in each month

CREATE TABLE sales 
(
    order_date date,
    customer VARCHAR(512),
    qty INT
);

INSERT INTO sales (order_date, customer, qty) VALUES ('2021-01-01', 'C1', '20');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-01-01', 'C2', '30');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-02-01', 'C1', '10');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-02-01', 'C3', '15');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-03-01', 'C5', '19');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-03-01', 'C4', '10');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-04-01', 'C3', '13');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-04-01', 'C5', '15');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-04-01', 'C6', '10');

select order_date, count(distinct customer) as cnt
from(
select *, row_number () over (partition by customer order by order_date) as rn
from sales ) a 
where rn = 1
group by 1;

-----------------------------------------------------------------------------------
create table source(id int, name varchar(5))

create table target(id int, name varchar(5))

insert into source values(1,'A'),(2,'B'),(3,'C'),(4,'D')

insert into target values(1,'A'),(2,'B'),(4,'X'),(5,'F');

select * from source ;
select * from target ;

select coalesce (s.id,t.id), s.name, t.name,
case when s.name is null then 'New in target'
	 when t.name is null then 'New in source'
	 when t.name != s.name then 'Mismatch' end 
from source s
full join target t
on s.id = t.id 
where s.name != t.name or s.name is null or t.name is null;

----------------------------------------------------------------------------------------
-- Find the words which are repeting more than once considering all the rows of content column

create table namaste_python (
file_name varchar(25),
content varchar(200)
);

delete from namaste_python;
insert into namaste_python 
values ('python bootcamp1.txt','python for data analytics 0 to hero bootcamp starting on Jan 6th')
,('python bootcamp2.txt','classes will be held on weekends from 11am to 1 pm for 5-6 weeks')
,('python bootcamp3.txt','use code NY2024 to get 33 percent off. You can register from namaste sql website. Link in pinned comment')

select parts, count(*) as cnt
from(
	select *,
	unnest(string_to_array(content, ' ')) as parts
	from namaste_python) a
group by 1
having count(*) > 1
order by 2 desc ;
