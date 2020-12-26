drop database if exists portfolio;
create database portfolio;
use portfolio;

drop table if exists users;
CREATE TABLE `users` (
	`id` bigint NOT NULL auto_increment unique primary key,
	`name` varchar(255) NOT NULL,
    `birthday_at` DATE,
	`email` varchar(255) NOT NULL,
	`phone` varchar(255) NOT NULL,
    `balance_rub` decimal(10,2) DEFAULT 0,
    `balance_usd` decimal(10,2) DEFAULT 0,
	`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    -- KEY `id` (`id`)
) comment = 'таблица юзеров';

drop table if exists tools;
CREATE TABLE `tools` (
	`id` tinyint(1) NOT NULL auto_increment unique primary key,
	`name` varchar(30) NOT NULL
)comment = 'инструменты- акции, облигации, фьючерсы';



drop table if exists name_pay;
CREATE TABLE `name_pay` (
	`id` tinyint(1) NOT NULL auto_increment unique primary key,
	`name_pay` varchar(255) NOT NULL
);



drop table if exists position;
CREATE TABLE `position` (
	`id` tinyint(1) NOT NULL primary key,
	`position` varchar(4) NOT NULL
);



drop table if exists currency;
CREATE TABLE `currency` (
	`id` int NOT NULL auto_increment unique primary key,
	`currency_name` varchar(255) NOT NULL
);

-- drop table if exists cash_position;
-- CREATE TABLE `cash_position` (
-- 	`id_cash_position` tinyint(1) NOT NULL primary key,
-- 	`name_cash_position` varchar(255) NOT NULL
-- );

drop table if exists price;
CREATE TABLE `price` (
	`id` serial primary key,
	`ticker_name` varchar(30) NOT NULL,
	`date` DATE NOT NULL,
    `price` float
) comment ='';

drop table if exists payments;
CREATE TABLE `payments` (
	`id` serial primary key,
	`ticker_name` varchar(30) NOT NULL,
	`date` DATE NOT NULL,
	`sum_on_quantity` FLOAT NOT NULL
) comment ='';

drop table if exists ticker;
CREATE TABLE `ticker` (
	`id` bigint NOT NULL auto_increment unique primary key,
	`tools_id` tinyint(1) NOT NULL,
	`ticker` varchar(255) NOT NULL,
	`name` varchar(255) NOT NULL,
	`other` TEXT NOT NULL
    -- FOREIGN KEY (`tools_id`) REFERENCES `tools`(`id`)
)comment = 'название инструмента';

drop table if exists broker;
CREATE TABLE `broker` (
	`id` int NOT NULL auto_increment unique primary key,
	`broker_name` varchar(255) NOT NULL
);

drop table if exists `portfolio`;
CREATE TABLE `portfolio` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT unique primary key,
  `user_id` bigint NOT NULL,
  `ticker` varchar(255) NOT NULL,
  `currency_id` int NOT NULL,
  `quantity` int NOT NULL,
  `summa` decimal(10,2) DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  FOREIGN KEY (`currency_id`) REFERENCES `currency`(`id`)
) ;


drop table if exists fact_deal;
CREATE TABLE `fact_deal` (
	`id` serial primary key,
	`user_id` bigint NOT NULL,
    `currency_id` int NOT NULL,
    `broker_id` int NOT NULL, -- add tabl broker
	`position_id` tinyint(1) NOT NULL,
	`ticker` varchar(255) NOT NULL, -- правильно будет тикер_ид но будет усложнено добавление в базу данных
    `tools_id` tinyint(1) NOT NULL,
	`date` DATE not null,-- 3 вида даты. не дублируются с нижними датами
	`quantity` int NOT NULL,
	`price` FLOAT NOT NULL,
    `summa` decimal(10,2),
	`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    -- KEY `user_id` (`user_id`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
    FOREIGN KEY (`position_id`) REFERENCES `position` (`id`),
    FOREIGN KEY (`currency_id`) REFERENCES `currency`(`id`),
    FOREIGN KEY (`tools_id`) REFERENCES `tools`(`id`),
    FOREIGN KEY (`broker_id`) REFERENCES `broker`(`id`)
    -- FOREIGN KEY (`ticker_id`) REFERENCES `ticker` (`id`)
);
use portfolio;
drop table if exists cash_fact;
CREATE TABLE `cash_fact` (
	`id` serial primary key,
    `user_id` bigint NOT NULL,
    `currency_id` int NOT NULL,
	`broker_id` int NOT NULL,
    `pay_id` tinyint(1) NOT NULL,
    `ticker` varchar(255),
	`summa` FLOAT NOT NULL,
	-- `cash_position_id` tinyint(1) NOT NULL,
	`date` DATE not null,
	`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`currency_id`) REFERENCES `currency`(`id`),
    -- FOREIGN KEY (`cash_position_id`) REFERENCES `cash_position`(`id_cash_position`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
    FOREIGN KEY (`pay_id`) REFERENCES `name_pay`(`id`),
    FOREIGN KEY (`broker_id`) REFERENCES `broker`(`id`)
);



-- triger

drop trigger if exists add_portf;
delimiter //
create trigger add_portf after insert on fact_deal
for each row
BEGIN
    UPDATE portfolio set quantity = quantity-NEW.quantity, summa = summa + NEW.summa where ticker= NEW.ticker and NEW.position_id=0; -- сделать потом через if
    UPDATE portfolio set quantity = quantity+NEW.quantity, summa = summa - NEW.summa where ticker= NEW.ticker and NEW.position_id=1;
    UPDATE users set balance_rub = balance_rub -NEW.summa where NEW.position_id=1 and NEW.currency_id = 1; -- при покупке списываются деньги с баланса добавить фильтр пользователя
    UPDATE users set balance_rub = balance_rub + NEW.summa where NEW.position_id=0 and NEW.currency_id = 1;
    UPDATE users set balance_usd = balance_usd -NEW.summa where NEW.position_id=1 and NEW.currency_id = 2;
    UPDATE users set balance_usd = balance_usd + NEW.summa where NEW.position_id=0 and NEW.currency_id = 2; -- dollars
end//
delimiter ;

drop trigger if exists add_cash;
delimiter //
create trigger add_cash after insert on cash_fact
for each row
BEGIN
    UPDATE users set balance_rub = balance_rub +NEW.summa where NEW.pay_id=1 and NEW.currency_id = 1;
    UPDATE users set balance_rub = balance_rub +NEW.summa where NEW.pay_id=3 and NEW.currency_id = 1;-- при покупке списываются деньги с баланса добавить потом иф и фильтр пользователя
    UPDATE users set balance_rub = balance_rub + NEW.summa where NEW.pay_id=4 and NEW.currency_id = 1;
    UPDATE users set balance_rub = balance_rub - NEW.summa where NEW.pay_id=2 and NEW.currency_id = 1;
	UPDATE users set balance_rub = balance_usd +NEW.summa where NEW.pay_id=1 and NEW.currency_id = 2;
    UPDATE users set balance_rub = balance_usd +NEW.summa where NEW.pay_id=3 and NEW.currency_id = 2;-- при покупке списываются деньги с баланса
	UPDATE users set balance_rub = balance_usd + NEW.summa where NEW.pay_id=4 and NEW.currency_id = 2;
    UPDATE users set balance_rub = balance_usd - NEW.summa where NEW.pay_id=2 and NEW.currency_id = 2; -- dollars
    
end//
delimiter ;