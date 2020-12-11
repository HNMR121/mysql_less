
-- ----------- task1
drop procedure if exists hello; 
delimiter //
create procedure hello()
BEGIN
	DECLARE `NOW` INT DEFAULT SUBSTRING(NOW(),12,2);
    IF(`NOW` BETWEEN 6 AND 12) THEN 
		SELECT 'Доброе утро';
	ELSEIF(`NOW` BETWEEN 12 AND 18) THEN 
		SELECT 'Доброый день';
	ELSEIF(`NOW` BETWEEN 18 AND 24) THEN 
		SELECT 'Добрый вечер';
	ELSEIF(`NOW` BETWEEN 0 AND 6) THEN 
		SELECT 'Доброй ночи';
    ELSE 
		SELECT 'ошибка';
    END IF;
END //
delimiter ;
call hello;

-- -----------task2 -- не до конца доделал. нет проверки 2 значений нулл

drop table if exists prod;
create table prod (name varchar(255),description varchar(255));
insert into prod values
('nnnn','asdsfafadf'),(null,'sdsdsd');
select * from prod;

drop trigger if exists check_upd_null;
delimiter //
create trigger check_upd_null before update on prod
for each row
begin
	if (new.name is null or new.description is null) then 
		signal sqlstate '45000' set message_text = 'UPDATE candeled';
	end if;
end;
delimiter;

SET SQL_SAFE_UPDATES = 0;
update prod set name = '1231313' where name = 'nnnn';

select * from prod;
update prod set description = '1231313' where name = 1231313;
update prod set description = null where name = '1231313';




-- -----------task3

drop procedure if exists fibo; 
delimiter //
create procedure fibo(x int)
begin
	DECLARE f1 int default 1;
	DECLARE f2 int default 1;
    DECLARE i int default 1;
    DECLARE fsum int default 1;
    while i < x-1 do
		set fsum = f1+f2;
        set f1 = f2;
        set f2 = fsum;
        set i = i+1;
	end while;
	SELECT fsum;
END;


call fibo(10);