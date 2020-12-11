-- ------task1
use shop0212;
start transaction;

insert into sample.users(`name`,birthday_at,updated_at,created_at)
select
	`name`,birthday_at,created_at,updated_at
from 
	shop0212.users
where 
	id = 1;
commit;

-- ----task2
create or replace view pr1 as
select
	p.name as p_name,
    c.name as c_name
from products as p
join catalogs as c
on
	p.id = c.id;

select * from pr1;

-- ----task3

use shop0212;
drop table if exists tmp1;
create table tmp1(created_at date);
drop table if exists tmp2;
create table tmp2(created_at date);

insert into tmp1 values 
	('2018-08-01'),('2018-08-04'),('2018-08-16'),('2018-08-17');
    
insert into tmp2 values 
	('2018-08-01'),
    ('2018-08-02'),
    ('2018-08-03'),
    ('2018-08-04'),
    ('2018-08-05'),
    ('2018-08-06'),
    ('2018-08-07'),
    ('2018-08-08'),
    ('2018-08-09'),
    ('2018-08-10'),
    ('2018-08-11'),
    ('2018-08-12'),
    ('2018-08-13'),
    ('2018-08-14'),
    ('2018-08-15'),
    ('2018-08-16'),
    ('2018-08-17'),
    ('2018-08-18'),
    ('2018-08-19'),
    ('2018-08-20'),
	('2018-08-21'),
    ('2018-08-22'),
    ('2018-08-23'),
    ('2018-08-24'),
    ('2018-08-25'),
    ('2018-08-26'),
    ('2018-08-27'),
    ('2018-08-28'),
    ('2018-08-29'),
    ('2018-08-30'),
    ('2018-08-31');
    


-- -----------------task3----------------------------
select created_at,
case 
 when created_at in (select * from tmp1) then 1
 else 0
end as X
from tmp2;





-- ----------task4-----------------------------
SET SQL_SAFE_UPDATES = 0;
delete
from tmp2
where created_at not in (select * from(select *
from tmp2 
order by created_at
limit 5)as X);
SET SQL_SAFE_UPDATES = 1;







-- temp
select
	p.name as p_name,
    c.name as c_name
from products as p
join catalogs as c
on
	p.id = c.id;
	
    
select *
from tmp2
where created_at not in (select * from(select *
from tmp2 
order by created_at
limit 5)as X);    
    
    
    
select created_at
from tmp2 
order by created_at
limit 5;


select created_at,
case 
 when created_at in ('2018-08-31','2018-08-30') then 1
 else 0
end
from tmp2;