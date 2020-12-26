use portfolio;




-- вывести общую прибыль РУБ
CREATE or replace VIEW  `view_profit_rub` AS
SELECT 
    SUM(((pp.quantity * pr.price) + pp.summa)) AS profit
FROM
    (SELECT 
        *
    FROM
        portfolio.portfolio
    WHERE
        currency_id = 1 and user_id = 1) AS pp
        LEFT JOIN
    (SELECT 
        *
    FROM
        price
    WHERE
        date = '2020-12-23') AS pr ON pp.ticker = pr.ticker_name;

-- вывести общую прибыль USD
CREATE or replace VIEW  `view_profit_usd` AS
SELECT 
    SUM(((pp.quantity * pr.price) + pp.summa)) AS profit
FROM
    (SELECT 
        *
    FROM
        portfolio.portfolio
    WHERE
        currency_id = 2 and user_id = 1) AS pp
        LEFT JOIN
    (SELECT 
        *
    FROM
        price
    WHERE
        date = '2020-12-23') AS pr ON pp.ticker = pr.ticker_name;



 -- представление для вывода планируемых выплат
CREATE or replace VIEW  `view_plan_divid` AS
SELECT 
    p.ticker,
    p.quantity,
    (p.quantity * pa.sum_on_quantity) AS summ_div,
    pa.date,
    pa.sum_on_quantity
FROM
    (SELECT 
        *
    FROM
        portfolio.portfolio
    WHERE
        quantity > 0 AND user_id = 1) AS p
        LEFT JOIN
    payments AS pa ON p.ticker = pa.ticker_name
;



-- представление для вывода выплат всех дивидендов
CREATE or replace VIEW  `view_plan_divid2` AS
SELECT 
    p.ticker, cf.summa, cf.currency_id
FROM
    (SELECT 
        *
    FROM
        portfolio.portfolio
    WHERE
        user_id = 1) AS p
        RIGHT JOIN
    (SELECT 
        ticker, SUM(summa) AS summa, currency_id
    FROM
        cash_fact
    WHERE
        user_id = 1 AND pay_id = 3
    GROUP BY ticker , currency_id) AS cf ON p.ticker = cf.ticker
ORDER BY ticker
;


-- temp
-- вывести прибыль по акции без дивидендов только курсовая стоимость
SELECT 
    currency_id,
    user_id,
    pp.ticker,
    pp.quantity,
    pr.price,
    ((pp.quantity * pr.price) + pp.summa) AS profit
FROM
    portfolio.portfolio AS pp
        LEFT JOIN
    (SELECT 
        *
    FROM
        price
    WHERE
        date = '2020-12-23') AS pr ON pp.ticker = pr.ticker_name;

-- временное удалить внизу

SELECT 
    ticker, SUM(summa) as summa, currency_id
FROM
    cash_fact
WHERE
    user_id = 1 AND pay_id = 3
GROUP BY ticker , currency_id;



