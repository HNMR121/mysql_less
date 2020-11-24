use shop;

-- Операторы сортировки, фильтрации ...

-- 1_task
-- SET SQL_SAFE_UPDATES = 0; отключить режим безопасный
UPDATE shop.users set created_at=NOW() where created_at is null;
UPDATE shop.users set updated_at=NOW() where updated_at is null;

-- 2_task
create table user_date (
id serial primary key,
created_at varchar(255));

INSERT INTO user_date
  (id, created_at)
  VALUES
  (1, '20.10.2017 12:34'),
  (2, '20.10.2017 15:10'),
  (3, '20.10.2017 8:10'),
  (4, '20.10.2017 16:20'),
  (5, '20.10.2017 21:10');
    
select * from user_date;

-- 3_task

select id, `value`
from storehouses_products
order by 
	if(value > 0,1,0) DESC ,value ASC;


-- 4_task

select name,birthday_at,
	case
		when substring(birthday_at , 6, 2) = '05' then 'may'
        when substring(birthday_at , 6, 2) = '08' then 'august'
	end as a
from users
Having a is not null;

-- select birthday_at, substring(birthday_at , 6, 2) as a
-- from users;

-- 5_task

select * from catalogs where id in (5,1,2) order by field(id , 5,1,2);

-- 6_task

SELECT avg(timestampdiff(YEAR,birthday_at, NOW())) as age FROM shop.users;


-- 7_task

select 
	name,
    birthday_at,
	concat(year(now()), '-', substring(birthday_at , 6, 10)) as `year_2020`,
    dayname(concat(year(now()), '-', substring(birthday_at , 6, 10))) as `dayname_2020`
	-- count(dayname(concat(year(now()), '-', substring(birthday_at , 6, 10)))) as count_dayname
from users;




-- 8_task
create table values_test (
value int);

INSERT INTO values_test(value)
	VALUES
  (1),
  (2),
  (3),
  (4),
  (5);

select * from values_test;

select exp(sum(log(value))) as product 
from values_test;
-- можно использовать округление round



-- ----------------------------- 


select created_at, str_to_date(created_at, '%d.%m.%Y' '%T') as date_new
from user_date;

Alter table user_date
add date_new datetime;
Update user_date set date_new = str_to_date(created_at, '%d.%m.%Y' '%T');

select * from user_date;











select * from users;

select * from storehouses_products;




INSERT INTO storehouses_products
  (id, value)
VALUES
  (1, 1999),
  (2, 134),
  (3, 1000),
  (4, 1500),
  (5, 200),
  (6, 20),
  (7, 2000);
  
INSERT INTO storehouses_products
  (id, value)
  VALUES
  (8, 0),
  (9, 0),
  (10, 0);
  

  
  

    






select  str_to_date("20.10.2017", '%d.%m.%Y' '%T') as date_new;








