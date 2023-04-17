-- This file is to bootstrap a database for the CS3200 project. 

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith 
-- data source creation.
create database HuskyGrocers;

-- Via the Docker Compose file, a special user called webapp will 
-- be created in MySQL. We are going to grant that user 
-- all privilages to the new database we just created. 
-- TODO: If you changed the name of the database above, you need 
-- to change it here too.
grant all privileges on HuskyGrocers.* to 'webapp'@'%';
flush privileges;

-- Move into the database we just created.
-- TODO: If you changed the name of the database above, you need to
-- change it here too. 
use HuskyGrocers;

-- Put your DDL 
create table if not exists Employees(
    employee_id int primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    title varchar(50) not null,
    working boolean not null,
    start_date datetime default CURRENT_TIMESTAMP,
    sup_id int,
    foreign key(sup_id)
        REFERENCES Employees(employee_id)
        on update cascade
);

insert into Employees
values(1, 'Robert', 'Chrow', 'associate', true, '2014-10-01 8:00:00', null);

insert into Employees
values(2, 'Gerald', 'Ford', 'associate', false, '2017-05-01 8:00:00', null);

create view new_view as
select *
from Employees;

create table if not exists Category(
    category_id int primary key,
    category_name varchar(50)
);

insert into Category
values(0, 'Produce');

insert into Category
values(1, 'Dairy');

create table if not exists Products(
    product_id int primary key,
    aisle int,
    sell_price decimal(6,2) not null,
    unit_price decimal(6,2) not null,
    units_in_stock int not null,
    product_name varchar(50) not null,
    category_id int,
    foreign key(category_id)
        REFERENCES Category(category_id)
        on update cascade
);

insert into Products
values(1, 4, 1.99, .50, 49, 'apple', 0);

insert into Products
values(2, 6, 4.99, 2.50, 16, 'banana yogurt', 1);

create table if not exists Customers(
    customer_id int primary key,
    phone varchar(12),
    email varchar(50),
    name varchar(50) not null
);

insert into Customers
values(5, '934-192-4230', 'jerrym@gmail.com', 'Jerry Moro');

insert into Customers
values(6, '234-456-4190', 'jennifert@gmail.com', 'Jennifer Taffy');

create table if not exists Supplier(
    company_name varchar(50) primary key,
    phone varchar(12) not null,
    num_employees int not null,
    country varchar(50) not null,
    state varchar(50) not null,
    city varchar(50) not null,
    street_address varchar(50) not null
);

insert into Supplier
values('Fresh Fruits', '912-675-2398', 140, 'United States', 'Massachusetts', 'Boston', '342 Main Street');

insert into Supplier
values('Yogurt Warehouse', '912-564-9808', 220, 'United States', 'Massachusetts', 'Boston', '17 Post Road');

create table if not exists StoreOrder(
    order_id int primary key,
    need_by_date datetime not null,
    fulfillment_date datetime,
    order_date datetime default CURRENT_TIMESTAMP,
    employee_id int not null,
    company_name varchar(50) not null,
    foreign key (employee_id)
        REFERENCES Employees(employee_id),
    foreign key (company_name)
        REFERENCES Supplier(company_name)
);

insert into StoreOrder
values(45, '2023-04-08 10:00:00', null, '2023-03-06 9:42:13', 2, 'Fresh Fruits');

insert into StoreOrder
values(46, '2023-04-10 10:00:00', null, '2023-03-06 9:52:45', 2, 'Yogurt Warehouse');

create table if not exists DeliveryCar(
    lp_num varchar(10) primary key,
    make varchar(50) not null,
    model varchar(50) not null,
    year int not null
);

insert into DeliveryCar
values('clg-141102', 'Toyota', 'Camry', 2011);

insert into DeliveryCar
values('ghyu-f4ht8', 'Ford', 'Bronco', 2016);

create table if not exists DeliveryDriver(
    driver_id int primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    start_date datetime default CURRENT_TIMESTAMP,
    lp_num varchar(10) not null,
    foreign key(lp_num)
        REFERENCES DeliveryCar(lp_num)
);

insert into DeliveryDriver
values(1, 'Jackson', 'Smith', '2021-09-11 08:00:00', 'clg-141102');

insert into DeliveryDriver
values(2, 'Samantha', 'Monthe', '2020-07-31 08:00:00', 'ghyu-f4ht8');

create table if not exists CustOrder(
    order_id int primary key,
    customer_id int not null,
    order_date datetime default CURRENT_TIMESTAMP,
    need_by_date datetime not null,
    tip decimal(6, 2) not null,
    fulfillment_date datetime,
    paid boolean not null,
    employee_id int,
    delivery boolean not null,
    address varchar(100) not null,
    driver_id int,
    foreign key(customer_id)
        references Customers(customer_id),
    foreign key(employee_id)
        references Employees(employee_id),
    foreign key(driver_id)
        references DeliveryDriver(driver_id)
);

insert into CustOrder
values(292, 5, '2023-04-07 08:16:02', '2023-04-10 08:00:00', 16.55, null, true, 1, true,
       '35 Columbus Avenue Boston, Massachusetts 02120', 1);

insert into CustOrder
values(294, 5, '2023-04-07 08:23:02', '2023-04-10 08:00:00', 4.31, null, true, 1, true,
       '35 Columbus Avenue Boston, Massachusetts 02120', 1);

create table if not exists Manager(
    employee_id int primary key,
    working boolean not null,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    company_name varchar(50) not null,
    foreign key(company_name)
        references Supplier(company_name)
);

insert into Manager
values(1, true, 'George', 'Lopez', 'Fresh Fruits');

insert into Manager
values(2, false, 'Rudy', 'Gillespie', 'Yogurt Warehouse');

create table if not exists StoreOrderDetails(
    order_id int,
    product_id int,
    quantity int not null,
    primary key(order_id, product_id),
    foreign key(order_id)
        references StoreOrder(order_id),
    foreign key(product_id)
        references Products(product_id)
);

insert into StoreOrderDetails
values(45, 1, 145);

insert into StoreOrderDetails
values(46, 2, 80);

create table if not exists CustOrderDetails(
    order_id int,
    product_id int,
    quantity int not null,
    primary key(order_id, product_id),
    foreign key(order_id)
        references CustOrder(order_id),
    foreign key(product_id)
        references Products(product_id)
);

insert into CustOrderDetails
values(292, 1, 4);

insert into CustOrderDetails
values(294, 2, 3);