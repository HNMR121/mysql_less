-- --------task1

select u.name
from users as u
where exists(select * from orders where id = u.id);

-- --------task2

select
	o.user_id,
    u.name,
    op.order_id,
    op.product_id,
    pr.name,
    ca.name
from orders as o
join users as u
on
	o.user_id = u.id
join orders_products as op 
on
	o.id = op.order_id
    join products as pr
    on
		op.product_id = pr.id
        join catalogs as ca
	on
		pr.catalog_id = ca.id
order by user_id;

-- --------task3

select f.id,f.from,f.to,c.name as from_rus,ci.name as to_rus from flights as f
join cities as c
	on f.from = c.label 
join cities as ci
    on f.to = ci.label;

