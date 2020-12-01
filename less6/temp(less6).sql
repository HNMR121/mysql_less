-- Вложенные запросы, агрегирующие ф-ции
use social3011;
-- персональная страница пользователя
select 
	firstname,
	lastname,
	hometown,
	(select filename from photos where id = u.photo_id) as 'personal_photo',
	(select count(*) from (select initiator_user_id from friend_requests where target_user_id = u.id and status = 'approved'
		union
	select target_user_id from friend_requests where initiator_user_id = u.id and status = 'approved') as fr_list) as 'friends',
	(select count(*) from friend_requests where target_user_id = u.id and status ='requested') as 'followers',
	(select count(*) from photos where user_id = u.id) 'photos'
from users as u 
where id = 40;

-- Список друзей пользователя 1 с указанием пола и возраста 

select  
	firstname,
	lastname,
	timestampdiff(year, birthday, now()) as age,
	case(gender)
		when 'm' then 'Мужчина'
		when 'f' then 'Женщина'
	end as 'gender'
from users where id in (select * from (
select 
	case
		when initiator_user_id = 1 and status = 'approved' then target_user_id
		when target_user_id = 1 and status = 'approved' then initiator_user_id
	end as friend_id
from friend_requests) as fr_list where friend_id is not null);


-- Получить id друзей пользователя №1
select initiator_user_id from friend_requests where target_user_id = 1 and status = 'approved'
union
select target_user_id from friend_requests where initiator_user_id = 1 and status = 'approved';

-- Получить id друзей пользователя №2
select * from (
select 
	case
		when initiator_user_id = 1 and status = 'approved' then target_user_id
		when target_user_id = 1 and status = 'approved' then initiator_user_id
	end as friend_id
from friend_requests) as fr_list where friend_id is not null;

-- список непрочитанных сообщений, адресованные пользователю 
select
	(select concat(firstname, ' ', lastname) from users where id = m.from_user_id) from_user,
	message,
	create_at 
from messages m
where to_user_id = 30 and is_read = 0;

-- кол-во непрочитанных сообщений, адресованные пользователю от друзей
select
	(select concat(firstname, ' ', lastname) from users where id = m.from_user_id) from_user,
	count(*) as total_msg 
from messages m
where 
	from_user_id in (select initiator_user_id from friend_requests where target_user_id = m.to_user_id and status = 'approved'
		union
	select target_user_id from friend_requests where initiator_user_id = m.to_user_id and status = 'approved') 
and
	to_user_id = 30 
and is_read = 0 
group by m.from_user_id order by total_msg desc;

-- среднее количество постов, опубликованных каждым пользователем

select avg(total_user_posts) from (select count(*) as total_user_posts  from posts group by user_id) as total_users_posts_tbl;

-- архив новостей
select count(*) as total_news, monthname(created_at) as `month` from posts group by `month` order by total_news desc;

-- Среднее количество групп у всех пользователей
select (select count(*) from users_communities)/(select count(*) from users);

-- Поделить число пользователей на число групп с ненулевым числом пользователей
select (select count(*) from users)/(select count(distinct community_id ) from users_communities);

--  min max
select max(timestampdiff(year, birthday, now())) as age from users;

select timestampdiff(year, birthday, now()) as age from users order by age desc limit 1;

select gender, min(timestampdiff(year, birthday, now())) as age from users group by gender;

-- агрегирующие ф-ции и null
select count(*) from photos;

select count(id) from photos;

select count(description) from photos;




-- ДЗ

select concat(firstname," ",lastname) as fl_name from users where id = 54;

select * from messages where to_user_id = 54;
select * from messages order by to_user_id =54;
select from_user_id, count(*) as c from messages where to_user_id = 54 group by from_user_id order by c desc;


-- пусть пользователь будет 54
select id,concat(firstname," ",lastname) as fl_name,
(select from_user_id  from messages where to_user_id = u.id group by from_user_id order by count(*) desc limit 1) as id_max_user,
(select concat(firstname," ",lastname) from users where id = id_max_user) as max_messages_user
 from users as u
 where id = 54;
 -- можно сделать по расчету знаков в соо

select from_user_id, count(*) as c from messages where to_user_id = 54 group by from_user_id order by c desc limit 1;

select count(*) from messages where to_user_id = 54 and from_user_id = 46;



-----------------

select id,  
concat(firstname," ",lastname) as fl_name, 
timestampdiff(year, birthday, now()) as age, 
(select count(id) from likes_posts where user_id =u.id group by user_id) as count_like
from users u 
order by age ASC limit 10;

select count(id) from likes_posts group by user_id;
select * from likes_posts;

select id,
user_id,
post,
(select * from likes_posts where post_id = p.
from posts as p where user_id = 74;
select * from likes_posts where post_id = 34;


select * from posts;
select user_id, id
,(select count(*) from likes_posts where post_id = p.id) as like_post 
from posts as p;

select post_id, count(*) from likes_posts group by post_id;
select count(*) from likes_posts group by post_id;

select user_id, id, 
(select count(id) from likes_posts where post_id = p.id ) as like_countpost
 from posts as p  order by like_countpost desc;
 
 select id, count(id) from likes_posts  where post_id = 19 group by id;
 select count(id) from likes_posts  where post_id = 19;


select user_id, 
(select count(*) as c from likes_posts where post_id = p.id ) as like_countpost
 from posts as p group by user_id,like_countpost order by like_countpost desc;
 
 select * from posts where user_id =210;
 
 select * from likes_posts where post_id = 19;

select gender, min(timestampdiff(year, birthday, now())) as age from users group by gender;

select * from users;
select * from posts;
select * from likes_posts;


select users.id, posts.id as post_id , likes_posts.id as likes_posts
from users 
INNER JOIN
	posts on users.id = posts.user_id 
		INNER JOIN
			likes_posts on posts.id = likes_posts.post_id
group by users.id, posts.id, likes_posts.id;

-- ------------------------------- внизу решение на 3 дополнить
select users.id, COUNT(likes_posts.id) as likes_posts
from users 
INNER JOIN
	posts on users.id = posts.user_id 
		INNER JOIN
			likes_posts on posts.id = likes_posts.post_id
group by users.id;
-- ------------------------------  task 3
select id,  
concat(firstname," ",lastname) as fl_name, 
timestampdiff(year, birthday, now()) as age, 
(select COUNT(likes_posts.id) as likes_posts
from users 
INNER JOIN
	posts on users.id = posts.user_id 
		INNER JOIN
			likes_posts on posts.id = likes_posts.post_id
where users.id=u.id) as count_like
from users u 
order by age ASC limit 10;

-- ------------------------------  task 4

select gender,   
sum((select COUNT(likes_posts.id) as likes_posts
from users 
INNER JOIN
	posts on users.id = posts.user_id 
		INNER JOIN
			likes_posts on posts.id = likes_posts.post_id
where users.id=u.id)) as count_like
from users u
group by gender
order by gender
;




select * from users where id = 209;
