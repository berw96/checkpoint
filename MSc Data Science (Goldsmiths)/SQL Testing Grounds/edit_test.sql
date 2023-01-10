use test;

describe addresses;
describe people;
describe pets;

alter table addresses add primary key (id);
alter table people add primary key(id);
alter table addresses drop primary key;
alter table people add constraint fk_people_address foreign key (address) references addresses(id);

#alter table pets add constraint unq_species unique (species);
#alter table pets drop index unq_species;

alter table pets add primary key (id);
alter table pets add constraint fk_owner_id foreign key (owner_id) references people(id);
alter table people add column email varchar(50);
alter table people add constraint unq_email unique (email);
alter table pets rename column `name` to `first_name`;
alter table addresses modify postcode char(7);

select * from people;

alter table people add column age int;
alter table people add column gender enum("M", "F");

set sql_safe_updates = 0;
insert into people (first_name, age, gender) values ("Emma", 21, "F");
insert into people (first_name, age, gender) values ("John", 30, "M");
insert into people (first_name, age, gender) values ("Thomas", 27, "M");
insert into people (first_name, age, gender) values ("Chris", 44, "M");
insert into people (first_name, age, gender) values ("Sally", 23, "F");
insert into people (first_name, age, gender) values ("Frank", 55, "M");


