use coffee_store;

select * from customers;
select * from orders;
select * from products;

select last_name from customers;
select last_name, phone_number from customers where phone_number is null;
select first_name, phone_number from customers where gender = "F" and last_name = "Bluth";
select * from customers where phone_number is null and gender = "M";
select * from customers where last_name in ("Taylor", "Bluth", "Armstrong");

select * from products where origin != "Colombia";
select * from products where price <= 3.00 or origin = "Colombia";
select name from products where price > 3.00 or origin = "Sri Lanka";

select product_id, customer_id, order_time from orders where order_time between "2017-01-01" and "2017-01-07";

select * from customers where last_name like "W%" or last_name like "S%" order by last_name desc;

select name, price from products where origin = "colombia" or origin = "Indonesia" order by name asc;
select * from orders where order_time like "2017-02%" and customer_id in (2,4,6,8);
select first_name, phone_number from customers where last_name like "%ar%";

# DISTINCT removes copies.
select distinct last_name from customers order by last_name asc;
select * from orders where customer_id = 1 and order_time like "2017-02%" limit 3;
select name, price as retail_price, origin from products;





