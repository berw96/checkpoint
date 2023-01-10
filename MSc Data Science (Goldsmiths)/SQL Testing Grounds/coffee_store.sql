show databases; 

create database coffee_store;

use coffee_store;

create table products(
	id int auto_increment primary key,
    name varchar(30),
    price decimal(3,2)
);

show tables;

describe products;
select * from products;

insert into products (name, price, origin) values ("Espresso", 2.50, "Brazil");
insert into products (name, price, origin) values ("Macchiato", 3.00, "Brazil");
insert into products (name, price, origin) values ("Cappuccino", 3.50, "Costa Rica");
insert into products (name, price, origin) values ("Latte", 3.50, "Indonesia");
insert into products (name, price, origin) values ("Americano", 3.00, "Brazil");
insert into products (name, price, origin) values ("Flat White", 3.50, "Indonesia");
insert into products (name, price, origin) values ("Filter", 3.00, "India");

set sql_safe_updates = 0;
update products set origin = "Sri Lanka" where id = 7;
update products set price = 3.25, origin = "Ethiopia" where name = "Americano";
update products set origin = "Colombia" where origin = "Brazil";


