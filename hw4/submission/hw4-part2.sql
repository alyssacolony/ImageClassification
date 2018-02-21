--Question 1
PRAGMA foreign_keys=ON;
DROP TABLE IF EXISTS Sales;
.mode tabs

CREATE TABLE Sales(
name varchar(10),
discount int,
month char(3),
price int);

.import mrFrumbleData.txt Sales

--Question 2
--FD #1  name -> price
select  name, count(distinct(price))
from Sales
group by name
having count(distinct(price))>1;
-- answer to the query was empty

-- FD #2 month -> discount
select  month, count(distinct(discount))
from Sales
group by month
having count(distinct(discount))>1;
-- answer to the query was empty

--Question 3
drop table IF EXISTS MonthName;
DROP TABLE IF EXISTS NamePrice;
drop table IF EXISTS MonthDiscount;

CREATE TABLE NamePrice(
	name varchar(10)  primary key,
	price int);

CREATE TABLE MonthDiscount(
	month char(3) primary key ,
	discount int);

CREATE TABLE MonthName(
	month char(3),
	name varchar(10),
	FOREIGN KEY (name) REFERENCES NamePrice(name), 
	FOREIGN KEY (month) REFERENCES MonthDiscount(month)
);


--Question 4
insert into NamePrice -- insert these rows into Table A
select distinct name, price
from Sales;

select count(*)
from NamePrice;
-- count = 37

insert into MonthDiscount 
select distinct month, discount
from Sales
order by month ;

select count(*)
from MonthDiscount;
--count = 13

insert into MonthName 
select distinct month, Name
from Sales;

select count(*)
from MonthName;
-- count = 427 

with A as (SELECT distinct MN.name, discount, MN.month, price 
from MonthName AS MN, MonthDiscount AS MD, NamePrice AS NP
WHERE NP.name = MN.name AND MD.month = MN.month)
--select * from A
Select * 
FROM A 
WHERE NOT EXISTS (select * from Sales);

with A as (SELECT distinct MN.name, discount, MN.month, price 
from MonthName AS MN, MonthDiscount AS MD, NamePrice AS NP
WHERE NP.name = MN.name AND MD.month = MN.month)
--select * from A
Select * 
FROM  Sales 
WHERE NOT EXISTS (select * from A);

