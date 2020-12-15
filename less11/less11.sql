
-- ----------task1
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	`created_at` DATETIME NOT NULL,
	`table_name` VARCHAR(255) NOT NULL,
	`key` BIGINT NOT NULL,
	`name` VARCHAR(255) NOT NULL
) ENGINE = ARCHIVE;

-- ----------task2
DROP PROCEDURE IF EXISTS `loads` ;
delimiter //
CREATE PROCEDURE `loads`(x int)
BEGIN
	DECLARE i INT DEFAULT 1;
	while i<x do
		insert users(id,name) values (1,'тест');
		set i = i+1;
	end while;
END //
delimiter ;

call loads(1000000);




-- REDIS-----------------
SADD ip '127.0.0.1' '127.0.0.2' '127.0.0.3'
set test@mail.ru test 
set test test@mail.ru

get test@mail.ru 
get test
