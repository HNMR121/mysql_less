-- ------------------------------ task 2
-- пусть пользователь будет 54
select id,concat(firstname," ",lastname) as fl_name,
(select from_user_id  from messages where to_user_id = u.id group by from_user_id order by count(*) desc limit 1) as id_max_user,
(select concat(firstname," ",lastname) from users where id = id_max_user) as max_messages_user
 from users as u
 where id = 54;




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
order by count_like desc;