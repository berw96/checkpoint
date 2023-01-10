use coffee_store;

select * from products;
select * from orders;

describe products;
describe orders;

update orders set customer_id = null where id = 1;

select products.name, orders.order_time from orders inner join products on orders.product_id = products.id;

select orders.id, customers.phone_number, customers.last_name, orders.order_time from orders left join customers on orders.customer_id = customers.id order by orders.order_time limit 10;

select products.name, products.price, customers.first_name, customers.last_name, orders.order_time from products join orders on products.id = orders.product_id join customers on customers.id = orders.customer_id where customers.last_name = "Martin" order by orders.order_time asc;

select orders.id, customers.phone_number from orders join customers on orders.customer_id = customers.id where orders.product_id = 4;
select products.name, orders.order_time from products join orders on orders.product_id = products.id where orders.order_time between "2017-01-15" and "2017-02-14" and products.name = "Filter";
select products.name, products.price, orders.order_time from products join orders on orders.product_id = products.id join customers on orders.customer_id where customers.gender = "F" and orders.order_time like "2017-01%";
