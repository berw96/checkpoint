create database test;

use test;

create table addresses(
	id int,
	house_number int,
    city varchar(20),
    postcode varchar(7)
);

create table people(
	id int,
    first_name varchar(20),
    last_name varchar(20),
    address int
);

create table pets(
	id int,
    name varchar(20),
    species varchar(20),
    owner_id int
);

show databases;

show tables;


