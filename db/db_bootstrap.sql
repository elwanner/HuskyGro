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

create view new_view as
select *
from Employees;

create table if not exists Category(
    category_id int primary key,
    category_name varchar(50)
);


create table if not exists Products(
    product_id int primary key,
    aisle int,
    sell_price decimal(6,2) not null,
    unit_price decimal(6,2) not null,
    units_in_stock int not null,
    product_name varchar(80) not null,
    category_id int,
    foreign key(category_id)
        REFERENCES Category(category_id)
        on update cascade
);


create table if not exists Customers(
    customer_id int primary key,
    phone varchar(12),
    email varchar(80),
    name varchar(50) not null
);


create table if not exists Supplier(
    company_name varchar(50) primary key,
    phone varchar(12) not null,
    num_employees int not null,
    country varchar(50) not null,
    state varchar(50) not null,
    city varchar(50) not null,
    street_address varchar(50) not null
);


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


create table if not exists DeliveryCar(
    lp_num varchar(10) primary key,
    make varchar(50) not null,
    model varchar(50) not null,
    year int not null
);


create table if not exists DeliveryDriver(
    driver_id int primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    start_date datetime default CURRENT_TIMESTAMP,
    lp_num varchar(10) not null,
    foreign key(lp_num)
        REFERENCES DeliveryCar(lp_num)
);


create table if not exists CustOrder(
    order_id int primary key,
    customer_id int not null,
    order_date datetime default CURRENT_TIMESTAMP,
    need_by_date date not null,
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


create table if not exists Manager(
    employee_id int primary key,
    working boolean not null,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    company_name varchar(50) not null,
    foreign key(company_name)
        references Supplier(company_name)
);


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


/*Employees Inserts*/
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date) VALUES (1,'Doe','Pickles','VP Accounting',0,'2021-06-21 15:44:33');
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (2,'Annette','Muston','Clinical Specialist',0,'2017-10-06 14:38:06',1);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (3,'Vlad','Lesley','Financial Advisor',0,'2020-01-17 19:50:55',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (4,'Barbaraanne','Madgewick','Senior Sales Associate',1,'2020-05-28 01:06:29',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (5,'Neille','Shillito','Information Systems Manager',1,'2021-01-19 04:52:23',1);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (6,'Charmain','Bramah','Data Coordinator',0,'2017-08-17 11:11:13',1);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (7,'Corabelle','Burgoine','Programmer III',0,'2016-10-31 10:26:30',1);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (8,'Monro','Cobbin','Tax Accountant',1,'2018-07-31 16:43:53',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (9,'Sammy','Scocroft','VP Marketing',0,'2021-04-17 02:33:14',1);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (10,'Edwin','Penhearow','Financial Analyst',0,'2017-07-31 16:08:23',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (11,'Annadiane','Byass','Human Resources Manager',0,'2015-04-25 20:58:12',1);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (12,'Fifine','Lanaway','Legal Assistant',1,'2017-05-06 03:05:01',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (13,'Ody','Freer','Database Administrator IV',1,'2021-07-18 09:31:42',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (14,'Ancell','Muffett','Administrative Assistant IV',0,'2014-11-07 04:54:14',1);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (15,'Leslie','Cours','Business Systems Development Analyst',1,'2019-06-14 13:46:33',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (16,'Sylvan','Daveridge','Community Outreach Specialist',1,'2016-07-04 21:57:47',1);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (17,'Dionne','Tarpey','Research Nurse',1,'2018-06-14 19:04:12',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (18,'Angeline','Pafford','Chief Design Engineer',0,'2015-09-08 13:43:15',1);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (19,'Adel','Wanden','Executive Secretary',0,'2017-07-29 16:02:21',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (20,'Cole','Plummer','VP Product Management',0,'2018-11-08 20:09:52',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (21,'Wit','Lithgow','Food Chemist',0,'2018-05-26 12:07:21',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (22,'Dory','Rustich','Executive Secretary',0,'2023-02-23 01:03:35',1);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (23,'Carlie','Jouannisson','Junior Executive',1,'2015-10-27 21:00:51',1);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (24,'Matty','Wylder','Information Systems Manager',0,'2023-02-05 03:24:24',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (25,'Wilton','Arnoud','Database Administrator I',0,'2016-11-10 17:27:27',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (26,'Noah','Archard','Account Coordinator',1,'2017-01-21 08:25:03',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (27,'Chandler','Francecione','Recruiting Manager',0,'2019-09-20 10:50:22',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (28,'Emelen','Macer','Staff Scientist',1,'2016-11-21 14:36:27',1);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (29,'Ella','Jeaves','Recruiter',0,'2020-03-03 11:47:06',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (30,'Rowland','Keggins','Research Nurse',1,'2018-05-30 00:53:22',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (31,'Barton','Kite','Accounting Assistant III',0,'2015-06-10 17:16:11',1);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (32,'Catriona','Loughney','Human Resources Manager',1,'2017-05-11 08:44:39',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (33,'Perl','Gonzalez','Quality Control Specialist',0,'2017-05-27 01:09:02',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (34,'Glendon','Gouldeby','Graphic Designer',1,'2014-09-24 01:01:41',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (35,'Clementius','Skunes','Teacher',0,'2020-08-28 23:59:06',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (36,'Gallard','Colloby','Marketing Manager',0,'2017-12-06 00:02:42',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (37,'Carlotta','Cotmore','Environmental Tech',0,'2019-05-12 17:22:53',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (38,'Gustie','Coulthart','Web Developer IV',1,'2021-09-27 07:56:54',1);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (39,'Pamella','Gossington','Internal Auditor',1,'2020-03-05 15:35:27',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (40,'Cecilia','Lante','Software Consultant',1,'2020-01-30 14:09:56',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (41,'Ody','Buckeridge','Design Engineer',1,'2015-11-18 16:47:30',1);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (42,'Marleah','Cawcutt','GIS Technical Architect',1,'2017-10-17 17:22:30',1);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (43,'Justin','Malshinger','Biostatistician I',1,'2015-09-19 01:35:31',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (44,'Jeannette','Aarons','Staff Scientist',1,'2022-02-27 23:41:57',1);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (45,'Maryrose','Agnew','Technical Writer',0,'2018-01-02 03:21:41',1);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (46,'Obidiah','Beamson','Operator',1,'2020-05-09 01:38:58',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (47,'Nicky','Ewells','Help Desk Technician',0,'2021-06-15 17:25:43',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (48,'Sully','Kochs','Account Representative I',0,'2021-01-18 09:13:03',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (49,'Minette','Rubroe','Environmental Specialist',0,'2019-01-09 11:28:52',2);
INSERT INTO Employees(employee_id,first_name,last_name,title,working,start_date,sup_id) VALUES (50,'Vladimir','Esplin','General Manager',0,'2021-01-27 17:25:20',2);


/*Category Inserts*/
INSERT INTO Category(category_id,category_name) VALUES (1,'FrozenFood');
INSERT INTO Category(category_id,category_name) VALUES (2,'Canned/Jarred Goods');
INSERT INTO Category(category_id,category_name) VALUES (3,'Bread/Bakery');
INSERT INTO Category(category_id,category_name) VALUES (4,'Dry/Baking Goods');
INSERT INTO Category(category_id,category_name) VALUES (5,'Bread/Bakery');
INSERT INTO Category(category_id,category_name) VALUES (6,'Dairy');
INSERT INTO Category(category_id,category_name) VALUES (7,'Bread/Bakery');
INSERT INTO Category(category_id,category_name) VALUES (8,'Beverages');

/*Products Inserts*/
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (1,18,37.96,73.51,43,'Eel Fresh',1);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (2,17,98.26,90.58,19,'Rice - Basmati',7);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (3,22,95.6,63.23,46,'Soup - Campbells - Tomato',2);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (4,2,60.99,29.27,11,'Cheese - Cambozola',8);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (5,3,85.65,99.13,21,'Scallops - 20/30',3);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (6,15,86.28,37.73,37,'Tomatoes - Grape',6);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (7,24,2.87,68.76,14,'Arrowroot',4);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (8,20,16.29,95.16,40,'Lamb - Racks, Frenched',5);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (9,16,47.04,5.43,47,'Lamb Shoulder Boneless Nz',6);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (10,3,139.71,41.13,29,'Puree - Passion Fruit',5);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (11,23,115.68,25.3,43,'Kellogs Cereal In A Cup',7);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (12,23,127.96,57.26,18,'Cheese - Cheddar, Old White',2);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (13,14,139.45,27.33,6,'Celery',8);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (14,8,12.94,50.44,40,'Gatorade - Fruit Punch',1);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (15,8,67.11,30.95,27,'Wine - Chardonnay South',4);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (16,16,50.72,55.83,39,'Juice - Apple 284ml',3);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (17,17,22.88,78.0,29,'Wine - Red, Colio Cabernet',7);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (18,6,113.55,51.23,14,'Milk 2% 500 Ml',6);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (19,18,149.21,83.93,32,'Food Colouring - Green',8);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (20,20,80.1,95.7,17,'Tomato - Tricolor Cherry',4);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (21,20,104.65,71.25,24,'Versatainer Nc - 9388',5);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (22,18,115.65,97.98,31,'Brandy - Bar',2);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (23,21,96.86,87.16,19,'Beef - Ground, Extra Lean, Fresh',1);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (24,1,121.2,10.76,0,'Wine - Sauvignon Blanc Oyster',3);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (25,18,133.27,42.03,19,'Turkey - Breast, Boneless Sk On',6);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (26,10,76.83,8.89,45,'Icecream - Dibs',5);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (27,11,50.26,72.41,44,'Veal - Leg, Provimi - 50 Lb Max',7);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (28,2,116.64,41.07,7,'Coffee - Colombian, Portioned',8);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (29,20,102.17,53.06,10,'Pasta - Penne, Lisce, Dry',4);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (30,13,25.6,17.56,21,'Potatoes - Peeled',1);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (31,24,8.35,99.27,33,'Edible Flower - Mixed',3);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (32,11,81.67,70.81,17,'Wine - Winzer Krems Gruner',2);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (33,16,104.11,3.91,33,'Wine - Stoneliegh Sauvignon',5);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (34,22,124.44,7.13,24,'Absolut Citron',4);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (35,4,90.83,28.58,34,'The Pop Shoppe - Grape',6);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (36,11,88.24,61.13,44,'Veal - Liver',2);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (37,2,20.67,92.78,49,'Wine - Remy Pannier Rose',8);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (38,6,99.55,26.75,0,'Table Cloth 53x53 White',7);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (39,24,38.59,87.63,17,'Juice - Orange, Concentrate',1);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (40,7,56.39,89.34,20,'Pepper - Red Thai',3);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (41,24,101.1,22.87,18,'Oil - Truffle, Black',7);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (42,15,9.78,3.44,36,'Liqueur Banana, Ramazzotti',3);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (43,4,6.92,97.37,18,'Burger Veggie',8);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (44,5,62.96,48.17,22,'Plaintain',2);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (45,17,99.55,93.3,30,'Pasta - Lasagna, Dry',5);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (46,5,73.83,32.95,8,'Beans - Black Bean, Preserved',6);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (47,10,137.08,82.37,35,'Radish - Pickled',4);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (48,16,114.2,68.67,7,'Lambcasing',1);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (49,25,11.22,16.85,19,'Vodka - Smirnoff',7);
INSERT INTO Products(product_id,aisle,sell_price,unit_price,units_in_stock,product_name,category_id) VALUES (50,1,94.3,6.94,43,'Bagelers',4);



/*Customers Inserts*/
INSERT INTO Customers(customer_id,phone,email,name) VALUES (1,'216-765-7492','pjakubovicz0@vkontakte.ru','Paula Jakubovicz');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (2,'581-846-9373','krojahn1@about.me','Keene Rojahn');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (3,'915-828-4024','cpiet2@ucoz.ru','Chrystel Piet');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (4,'323-332-7960','bbrabbins3@aboutads.info','Borden Brabbins');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (5,'620-650-2520','afernando4@theguardian.com','Athene Fernando');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (6,'898-226-7094','qgockeler5@furl.net','Quinton Gockeler');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (7,'849-861-1135','apattillo6@deliciousdays.com','Almira Pattillo');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (8,'451-782-9677','kgocke7@booking.com','Kristoforo Gocke');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (9,'412-573-1136','zskotcher8@oracle.com','Zacharias Skotcher');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (10,'501-556-2050','lperillio9@nsw.gov.au','Lela Perillio');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (11,'593-567-2884','tdowsa@sciencedaily.com','Tania Dows');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (12,'704-411-6846','ssuggeyb@delicious.com','Sol Suggey');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (13,'245-435-8109','kleabeaterc@multiply.com','Karel Leabeater');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (14,'409-923-3900','klaytond@nationalgeographic.com','Kitty Layton');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (15,'370-365-9852','balejandrie@prnewswire.com','Blisse Alejandri');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (16,'144-264-1524','scordenf@sourceforge.net','Sherlock Corden');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (17,'269-419-0569','mlatchg@sourceforge.net','Monique Latch');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (18,'217-600-0163','wdroghanh@networkadvertising.org','Wenona Droghan');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (19,'831-842-3171','bantcliffei@dailymail.co.uk','Betta Antcliffe');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (20,'402-372-3669','gmottoj@google.ru','Graehme Motto');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (21,'916-708-0261','jlahertyk@mapy.cz','Jozef Laherty');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (22,'579-800-5611','ttowersl@cornell.edu','Trisha Towers');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (23,'412-654-8187','fmcturkm@illinois.edu','Farrel McTurk');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (24,'747-477-1637','hgillonn@google.fr','Hector Gillon');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (25,'212-731-3207','lhuddarto@discovery.com','Linnell Huddart');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (26,'900-932-8641','mcaulwellp@nationalgeographic.com','Maxi Caulwell');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (27,'715-839-8613','gfrenscheq@macromedia.com','Gerladina Frensche');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (28,'749-806-1896','ocowwellr@usa.gov','Orton Cowwell');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (29,'475-583-0346','cworleys@shinystat.com','Cristionna Worley');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (30,'790-521-9107','blargent@cargocollective.com','Benedick Largen');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (31,'203-654-1723','mhaggettu@hao123.com','Myrwyn Haggett');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (32,'402-777-1218','ndorningv@businessinsider.com','Nerty Dorning');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (33,'296-505-0179','lkelsow@miibeian.gov.cn','Leonelle Kelso');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (34,'498-500-0209','npargiterx@wp.com','Nickie Pargiter');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (35,'539-817-5798','zcoverdilly@elegantthemes.com','Zarah Coverdill');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (36,'329-595-4327','rgorthyz@squidoo.com','Ron Gorthy');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (37,'283-795-3747','ebrinkley10@theguardian.com','Ebony Brinkley');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (38,'971-746-7695','bcargo11@army.mil','Buiron Cargo');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (39,'236-314-0907','rthorbon12@jimdo.com','Rosamond Thorbon');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (40,'605-865-6960','jfinkle13@gmpg.org','Jacqueline Finkle');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (41,'248-951-7632','ldowtry14@blogtalkradio.com','Lannie Dowtry');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (42,'659-626-8916','bdominighi15@hatena.ne.jp','Bev Dominighi');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (43,'490-411-8311','bmacgoun16@foxnews.com','Baxie MacGoun');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (44,'201-556-6531','xfeyer17@time.com','Xylia Feyer');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (45,'273-511-0458','centicknap18@google.pl','Cletus Enticknap');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (46,'588-338-5016','coleksiak19@amazonaws.com','Clarey Oleksiak');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (47,'605-493-2968','emigheli1a@cbsnews.com','Earl Migheli');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (48,'273-554-1983','vmicklewicz1b@nps.gov','Vale Micklewicz');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (49,'835-262-8700','tpetegre1c@mac.com','Ted Petegre');
INSERT INTO Customers(customer_id,phone,email,name) VALUES (50,'645-322-6482','mwildin1d@dmoz.org','Monty Wildin');

/*Supplier Inserts*/
INSERT INTO Supplier(company_name,phone,num_employees,country,state,city,street_address) VALUES ('Fresh Fruits','817-180-1427',11,'United States','Massachusetts','Boston','20 Cascade Alley');
INSERT INTO Supplier(company_name,phone,num_employees,country,state,city,street_address) VALUES ('Fresh Vegetables','217-468-9249',14,'United States','New York','New York','9 Bluejay Court');
INSERT INTO Supplier(company_name,phone,num_employees,country,state,city,street_address) VALUES ('Fruits on the Go','202-150-5545',73,'United States','Washington','Seattle','1 Stang Junction');
INSERT INTO Supplier(company_name,phone,num_employees,country,state,city,street_address) VALUES ('Vegetables On the Go','719-464-3657',54,'United States','Florida','Tallahassee','017 Atwood Park');
INSERT INTO Supplier(company_name,phone,num_employees,country,state,city,street_address) VALUES ('Meat and Fish Co','435-614-6582',42,'United States','Texas','Miami','6378 Garrison Court');
INSERT INTO Supplier(company_name,phone,num_employees,country,state,city,street_address) VALUES ('Dairy Direct','602-344-6935',27,'United States','Kansas','Austin','9 Farmco Street');
INSERT INTO Supplier(company_name,phone,num_employees,country,state,city,street_address) VALUES ('FrozenFoodz','469-925-5480',20,'United States','Nebraska','Topeka','1353 Sherman Hill');
INSERT INTO Supplier(company_name,phone,num_employees,country,state,city,street_address) VALUES ('Fresh Bread','202-736-7570',54,'United States','Massachusetts','Lincoln City','2400 Elmside Place');

/*StoreOrder Inserts*/
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (1,'2016-03-29 03:31:36','2020-08-13 05:26:47','2015-05-28 11:07:18',44,'Fresh Vegetables');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (2,'2022-03-02 05:53:33','2018-03-15 09:41:10','2021-07-20 11:02:35',27,'Vegetables On the Go');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (3,'2016-04-21 06:08:01','2020-06-20 16:10:06','2019-01-15 14:50:13',16,'Fruits on the Go');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (4,'2021-01-26 20:37:28','2018-04-27 08:42:47','2018-06-16 12:00:59',3,'FrozenFoodz');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (5,'2017-01-23 21:22:43','2017-10-16 01:52:56','2022-07-24 05:43:04',42,'Fresh Fruits');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (6,'2019-01-28 15:49:08','2017-03-21 12:56:17','2018-04-27 12:53:17',48,'Meat and Fish Co');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (7,'2017-03-23 17:26:49','2019-03-21 01:24:36','2020-03-21 15:01:30',36,'Dairy Direct');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (8,'2020-06-05 18:00:36','2018-11-11 14:20:07','2021-06-26 01:19:34',34,'Fresh Bread');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (9,'2022-08-17 01:42:25','2020-01-09 06:02:15','2020-07-14 10:39:22',19,'Fresh Bread');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (10,'2023-03-05 03:10:15','2018-05-15 20:02:30','2017-04-03 04:45:24',2,'Meat and Fish Co');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (11,'2017-06-18 11:01:14','2023-02-27 16:43:27','2016-01-17 22:37:02',24,'Fresh Fruits');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (12,'2019-11-22 05:13:05','2020-05-26 13:25:43','2016-08-10 15:11:14',8,'Fruits on the Go');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (13,'2021-02-11 06:45:16','2019-08-29 16:19:31','2020-05-08 15:14:29',9,'Dairy Direct');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (14,'2016-09-26 14:21:56','2015-07-18 23:03:51','2023-04-12 13:52:27',17,'Fresh Vegetables');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (15,'2022-08-09 07:20:24','2016-02-17 08:10:11','2020-05-02 10:17:37',11,'Vegetables On the Go');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (16,'2022-10-14 19:07:45','2017-06-02 15:41:17','2021-09-20 02:12:53',21,'FrozenFoodz');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (17,'2018-08-23 22:11:00','2016-04-13 15:50:36','2021-01-15 19:43:19',4,'Fresh Vegetables');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (18,'2016-07-04 10:03:57','2018-01-01 13:35:05','2017-01-09 03:26:27',26,'Fresh Fruits');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (19,'2021-02-16 14:11:37','2022-03-17 17:13:50','2016-02-11 07:27:22',47,'Meat and Fish Co');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (20,'2017-10-26 15:46:31','2019-04-05 22:12:38','2018-01-14 20:42:28',33,'Fruits on the Go');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (21,'2018-10-15 22:09:08','2021-09-18 22:28:16','2021-10-11 10:03:49',12,'Fresh Bread');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (22,'2018-01-27 23:45:42','2023-03-06 07:31:19','2017-12-01 09:09:15',1,'FrozenFoodz');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (23,'2015-12-05 20:44:16','2015-12-08 13:03:18','2019-03-08 23:59:25',15,'Dairy Direct');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (24,'2015-12-18 03:46:37','2022-12-07 07:24:27','2019-01-20 18:55:11',6,'Vegetables On the Go');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (25,'2016-07-11 13:20:49','2016-02-17 21:51:12','2019-01-06 17:02:45',32,'Dairy Direct');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (26,'2016-08-21 06:20:43','2016-03-07 03:06:08','2021-05-29 04:39:43',37,'Vegetables On the Go');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (27,'2022-10-19 04:05:25','2016-12-11 11:14:56','2019-03-06 06:00:12',7,'Fresh Vegetables');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (28,'2016-03-28 19:46:48','2020-08-26 14:44:50','2018-03-10 19:55:17',23,'Meat and Fish Co');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (29,'2019-06-09 18:46:53','2018-08-06 07:14:54','2020-08-09 01:23:07',50,'Fresh Bread');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (30,'2016-08-08 22:06:36','2021-02-17 09:53:57','2015-12-03 03:33:45',35,'FrozenFoodz');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (31,'2017-10-27 11:40:27','2021-11-12 18:00:52','2021-11-25 12:31:29',39,'Fresh Fruits');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (32,'2021-01-08 05:43:46','2016-08-11 19:56:16','2019-11-01 11:44:58',46,'Fruits on the Go');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (33,'2017-03-30 10:50:49','2017-07-12 03:28:46','2019-01-31 04:16:27',41,'Meat and Fish Co');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (34,'2021-08-26 23:18:09','2021-05-28 18:42:46','2016-09-04 03:04:14',22,'FrozenFoodz');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (35,'2018-08-23 02:32:59','2016-06-03 19:42:40','2021-05-09 08:23:15',25,'Fresh Bread');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (36,'2015-11-28 04:51:26','2016-02-19 06:55:44','2018-05-23 13:49:14',49,'Fresh Fruits');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (37,'2019-01-04 22:30:44','2016-03-08 09:16:14','2020-11-06 01:13:17',45,'Fruits on the Go');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (38,'2021-01-05 13:25:45','2023-03-29 08:14:04','2021-05-01 02:59:37',28,'Fresh Vegetables');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (39,'2016-09-01 13:32:11','2022-02-26 23:26:01','2022-06-05 20:03:16',31,'Dairy Direct');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (40,'2021-12-19 23:59:41','2016-08-13 18:17:39','2019-10-02 14:19:50',40,'Vegetables On the Go');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (41,'2021-07-31 05:26:54','2020-02-22 07:37:50','2018-08-04 18:36:21',43,'Dairy Direct');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (42,'2018-01-24 22:32:07','2018-01-11 10:59:35','2018-12-07 21:39:57',5,'Meat and Fish Co');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (43,'2016-10-28 22:50:52','2019-10-10 07:02:11','2017-07-13 17:50:07',38,'Fresh Fruits');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (44,'2020-02-16 04:36:29','2019-10-17 01:51:40','2015-10-01 13:53:59',14,'Fruits on the Go');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (45,'2019-09-17 23:23:21','2022-09-29 07:02:50','2021-03-19 22:33:45',13,'Fresh Bread');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (46,'2016-09-02 17:44:01','2019-07-20 04:25:20','2020-12-03 15:15:53',29,'Fresh Vegetables');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (47,'2022-04-24 15:19:20','2018-03-24 01:12:44','2017-08-30 13:02:27',10,'Vegetables On the Go');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (48,'2022-12-09 01:34:41','2016-07-28 19:20:06','2020-05-08 08:36:12',30,'FrozenFoodz');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (49,'2022-05-16 13:57:47','2022-09-04 02:17:42','2016-04-17 11:33:14',18,'Dairy Direct');
INSERT INTO StoreOrder(order_id,need_by_date,fulfillment_date,order_date,employee_id,company_name) VALUES (50,'2016-04-08 20:24:55','2019-02-28 15:41:19','2022-01-23 12:18:49',20,'FrozenFoodz');

/*DeliveryCar Inserts*/
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('223-ty-05','Porsche','911',1995);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('131-qn-12','Mitsubishi','Diamante',1996);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('849-kt-30','Volvo','S40',2011);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('290-fr-55','Audi','A3',2006);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('792-kg-24','Audi','V8',1991);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('867-tz-22','Honda','CR-V',1998);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('808-mh-40','Lincoln','MKT',2013);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('177-ch-27','Infiniti','QX',2000);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('235-wa-67','Saturn','VUE',2007);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('065-km-71','Eagle','Talon',1994);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('944-fk-46','Pontiac','Fiero',1988);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('594-uh-16','Dodge','D350 Club',1992);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('212-hb-46','Ford','Econoline E150',1999);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('867-zh-95','Mercedes-Benz','C-Class',2004);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('068-cb-58','Toyota','TundraMax',2012);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('710-nk-07','Jaguar','X-Type',2002);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('570-qs-72','Dodge','Monaco',1992);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('112-bh-67','Mazda','B-Series',1997);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('596-ip-81','Chevrolet','Express 1500',2008);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('616-jk-46','Ford','Bronco II',1989);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('036-gu-61','Mercedes-Benz','C-Class',2007);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('090-jq-76','GMC','3500',1999);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('251-yg-97','Hyundai','Veracruz',2007);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('464-ih-35','BMW','X5 M',2012);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('626-es-87','Pontiac','Firefly',1991);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('977-pu-63','Chevrolet','Colorado',2007);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('033-ta-12','Eagle','Summit',1996);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('215-gk-56','GMC','Savana 3500',2006);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('688-dh-39','Toyota','T100 Xtra',1997);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('125-zf-39','Mazda','Mazda5',2012);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('882-te-70','Mitsubishi','Montero',1993);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('250-nm-95','Hyundai','Elantra',2000);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('642-ux-58','Chevrolet','Corvette',2010);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('420-sw-52','Saab','9-5',2001);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('596-mr-03','Mitsubishi','Precis',1990);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('054-se-49','Infiniti','Q',1992);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('753-jy-77','Honda','S2000',2007);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('463-lj-28','Dodge','Ram Van 2500',2001);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('249-gd-09','Volkswagen','Eos',2011);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('008-wr-72','Suzuki','Daewoo Magnus',2006);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('318-ph-95','Chrysler','New Yorker',1995);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('308-uc-16','Ford','Taurus',1989);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('465-rs-96','Plymouth','Laser',1993);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('812-fn-59','Kia','Forte',2012);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('894-sk-29','Oldsmobile','Toronado',1992);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('683-dj-14','Mercedes-Benz','W123',1977);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('002-hb-19','Mazda','MX-5',2000);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('218-lk-43','Hyundai','Tiburon',2008);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('760-oh-38','Bentley','Continental GT',2009);
INSERT INTO DeliveryCar(lp_num,make,model,year) VALUES ('322-bx-38','Lexus','LX',2008);

/*DeliveryDriver Inserts*/
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (1,'Red','Seabrooke','2020-01-04 16:09:38','223-ty-05');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (2,'Salem','Regglar','2020-02-16 21:55:11','131-qn-12');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (3,'Jenelle','Clench','2018-10-27 01:57:15','849-kt-30');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (4,'Marnia','Simonini','2018-01-17 17:32:12','290-fr-55');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (5,'Hall','Airey','2015-09-02 06:04:53','792-kg-24');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (6,'Ty','Derby','2020-07-30 11:41:56','867-tz-22');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (7,'Gannie','Galego','2020-12-22 00:46:00','808-mh-40');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (8,'Daveta','Posen','2019-12-17 16:23:24','177-ch-27');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (9,'Rowney','Dzenisenka','2021-10-11 21:47:16','235-wa-67');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (10,'Sheelah','Skottle','2022-01-14 03:44:57','065-km-71');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (11,'Bing','Bea','2017-12-03 17:12:47','944-fk-46');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (12,'Karlis','Sinncock','2019-03-15 10:18:44','594-uh-16');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (13,'Edd','Mc Andrew','2020-08-27 17:38:12','212-hb-46');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (14,'Raina','Zanitti','2023-03-16 11:54:55','867-zh-95');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (15,'Carita','Clother','2016-04-01 05:01:07','068-cb-58');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (16,'Orland','Tilbey','2017-02-08 10:20:43','710-nk-07');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (17,'Mignonne','McCullogh','2023-04-12 22:40:07','570-qs-72');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (18,'Sarette','Sousa','2022-09-11 08:42:15','112-bh-67');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (19,'Carling','Kenan','2023-02-02 20:22:41','596-ip-81');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (20,'Alvin','Pau','2019-03-05 19:54:47','616-jk-46');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (21,'Esdras','Batteson','2016-06-11 07:09:17','036-gu-61');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (22,'Verine','Morrow','2017-04-05 10:31:00','090-jq-76');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (23,'Parker','Shurrocks','2021-11-21 21:07:44','251-yg-97');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (24,'Thomasin','Webling','2020-01-22 13:12:55','464-ih-35');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (25,'Nicolle','Frigout','2016-07-15 22:40:55','626-es-87');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (26,'Kali','Sharpley','2018-06-19 10:58:37','977-pu-63');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (27,'Blayne','Helis','2017-06-23 04:37:47','033-ta-12');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (28,'Noak','Geggus','2019-03-29 10:16:43','215-gk-56');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (29,'Jonathon','Chucks','2017-11-09 03:33:33','688-dh-39');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (30,'Say','Esberger','2016-12-09 12:51:39','125-zf-39');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (31,'Obidiah','Soreau','2019-04-01 13:35:16','882-te-70');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (32,'Levey','Strowan','2017-06-17 18:59:01','250-nm-95');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (33,'Adore','Biset','2016-11-17 20:11:16','642-ux-58');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (34,'Mathilda','Wandrey','2023-03-25 02:12:32','420-sw-52');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (35,'Julietta','Denge','2022-12-24 03:52:55','596-mr-03');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (36,'Richmound','Bevar','2016-12-11 01:08:03','054-se-49');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (37,'Willie','Luciani','2022-11-29 07:42:11','753-jy-77');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (38,'Edan','Smorthit','2019-08-15 19:06:19','463-lj-28');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (39,'Jaquelin','Reary','2019-05-03 15:04:52','249-gd-09');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (40,'Mamie','Hankin','2021-02-22 16:45:22','008-wr-72');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (41,'Micky','Hiddsley','2019-07-12 15:16:40','318-ph-95');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (42,'Gisele','Dowty','2019-09-16 03:37:53','308-uc-16');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (43,'Alejoa','Di Frisco','2019-02-26 08:57:35','465-rs-96');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (44,'Ade','Swafield','2015-12-12 14:25:09','812-fn-59');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (45,'Cristine','Gaddes','2017-06-01 10:14:07','894-sk-29');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (46,'Danna','Simonato','2017-09-25 20:03:40','683-dj-14');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (47,'Amie','Assiter','2020-01-26 17:04:51','002-hb-19');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (48,'Annabal','Silverthorne','2021-09-09 19:24:44','218-lk-43');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (49,'Maridel','Pratchett','2021-04-12 16:03:51','760-oh-38');
INSERT INTO DeliveryDriver(driver_id,first_name,last_name,start_date,lp_num) VALUES (50,'Vivien','Lackner','2022-06-27 16:12:58','322-bx-38');

/*CustOrder Inserts*/
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (1,48,'2017-04-20 17:49:57','2020-10-26',11.49,'2021-03-25 11:19:15',1,5,0,'7 Corry Alley',50);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (2,4,'2022-10-02 23:37:18','2019-06-24',58.41,'2022-11-02 00:30:18',0,6,1,'1156 Scofield Junction',8);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (3,36,'2020-04-15 04:59:13','2017-06-16',84.42,'2020-07-19 13:16:20',0,17,1,'7134 Spaight Center',11);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (4,7,'2022-07-15 09:08:27','2016-09-05',76.1,'2018-09-06 12:06:00',1,23,0,'0173 Carioca Lane',35);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (5,14,'2021-03-28 23:09:40','2020-11-21',69.76,'2017-06-22 08:59:18',0,7,1,'61 Goodland Street',9);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (6,46,'2016-05-07 14:44:09','2021-05-31',17.93,'2019-04-04 21:09:46',0,42,0,'9797 Butternut Junction',42);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (7,15,'2022-02-08 14:57:10','2016-08-15',16.85,'2018-03-22 02:09:43',0,44,0,'06 Warbler Crossing',47);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (8,19,'2016-12-21 15:01:57','2017-03-29',90.55,'2018-07-28 19:46:46',0,3,0,'46 Judy Park',41);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (9,18,'2023-02-12 23:25:45','2018-08-29',25.98,'2020-12-30 08:23:11',0,49,0,'3823 Carberry Parkway',5);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (10,33,'2023-04-10 14:34:58','2021-04-29',50.28,'2017-04-08 16:43:15',0,31,1,'0457 Morningstar Place',32);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (11,50,'2016-06-11 18:05:01','2016-12-01',99.51,'2016-09-15 09:54:24',0,32,1,'43 Holmberg Crossing',30);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (12,32,'2019-08-16 10:16:29','2017-08-20',60.06,'2022-11-04 17:19:12',1,1,0,'623 Reinke Road',19);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (13,9,'2023-03-30 19:50:13','2017-01-14',32.77,'2018-08-18 14:29:14',1,20,0,'6 Farragut Parkway',25);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (14,38,'2022-01-14 14:34:25','2020-11-15',39.44,'2022-09-26 03:17:39',1,13,1,'8 Calypso Park',27);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (15,23,'2023-02-21 22:32:56','2021-12-06',94.41,'2018-01-18 02:51:32',0,9,1,'3 Holy Cross Point',36);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (16,40,'2021-06-10 03:01:48','2020-09-30',80.59,'2022-02-14 13:11:39',0,11,0,'595 Ilene Circle',4);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (17,41,'2016-11-08 03:22:24','2021-04-05',44.84,'2023-03-23 03:34:56',1,2,1,'499 Tomscot Junction',48);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (18,5,'2017-06-14 11:31:56','2022-11-17',29.88,'2017-04-06 08:11:15',1,25,0,'7 Lillian Avenue',3);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (19,17,'2016-07-02 15:33:56','2021-05-15',62.69,'2019-10-22 01:17:06',1,34,1,'4634 Kensington Park',38);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (20,1,'2021-01-14 01:28:15','2017-04-05',64.84,'2018-09-15 04:08:04',1,28,0,'282 Oriole Plaza',20);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (21,12,'2020-08-19 12:56:03','2022-10-25',7.52,'2019-10-06 00:07:21',0,4,0,'91 Merchant Point',26);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (22,44,'2017-03-17 08:59:37','2017-06-15',11.61,'2016-05-23 01:05:11',0,12,1,'425 Eggendart Drive',21);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (23,30,'2021-01-10 06:03:24','2021-07-08',37.84,'2019-07-10 09:05:03',0,18,0,'802 Jenifer Crossing',40);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (24,10,'2019-04-03 00:19:56','2017-11-23',42.71,'2018-10-02 22:16:33',0,27,1,'32 Vernon Avenue',16);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (25,37,'2023-03-29 09:11:34','2016-07-22',4.35,'2022-06-02 15:40:18',1,14,1,'1485 Hudson Place',14);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (26,49,'2016-06-17 08:17:03','2016-11-11',97.71,'2017-06-08 13:28:23',0,38,1,'33 Loeprich Junction',22);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (27,29,'2022-07-13 04:30:37','2019-04-23',46.88,'2020-12-23 04:27:16',0,19,0,'04 Veith Way',49);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (28,27,'2018-05-01 22:10:35','2017-11-09',8.27,'2018-09-05 16:48:05',0,24,1,'454 Ridge Oak Street',37);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (29,21,'2017-02-27 10:48:49','2018-09-17',83.97,'2020-04-15 02:21:52',0,50,0,'80441 Heath Lane',44);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (30,31,'2017-07-01 18:01:06','2016-08-04',24.09,'2018-11-29 08:00:44',1,46,1,'301 Northport Point',7);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (31,28,'2019-09-05 01:43:06','2016-10-17',73.4,'2021-08-23 00:44:42',1,45,0,'8223 Sheridan Drive',24);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (32,47,'2017-11-20 07:10:08','2019-09-25',68.16,'2022-08-01 12:53:06',1,36,0,'1 Hoffman Circle',17);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (33,20,'2020-04-22 01:38:36','2020-08-04',35.65,'2023-03-02 19:20:12',0,33,0,'89 Eastlawn Parkway',6);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (34,43,'2023-03-19 04:04:08','2016-08-26',24.45,'2019-11-03 01:22:01',1,10,0,'99401 American Ash Junction',43);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (35,22,'2016-10-27 16:53:08','2021-04-13',85.11,'2020-03-14 19:29:13',1,35,0,'9817 Dapin Plaza',15);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (36,13,'2021-08-16 08:57:55','2016-07-30',88.33,'2018-05-08 08:15:27',1,37,0,'8248 Katie Center',28);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (37,45,'2020-11-13 20:05:24','2018-04-18',42.3,'2017-06-01 22:19:15',1,21,1,'307 Spaight Court',46);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (38,2,'2017-10-31 01:59:39','2019-01-23',87.83,'2022-02-02 08:51:03',0,43,1,'9 Sherman Terrace',29);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (39,6,'2017-06-13 16:30:07','2022-09-04',81.14,'2019-04-25 03:41:39',0,39,1,'47961 Burning Wood Court',1);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (40,39,'2021-07-14 06:39:38','2017-12-02',8.87,'2017-03-12 12:16:25',1,30,1,'0497 Kings Drive',34);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (41,11,'2018-09-09 18:34:59','2018-10-20',34.83,'2018-03-28 22:45:03',0,40,1,'9 Norway Maple Point',33);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (42,35,'2017-11-01 05:47:21','2017-11-03',66.63,'2017-03-15 20:08:27',0,16,0,'6612 Harbort Terrace',12);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (43,25,'2022-12-22 15:18:10','2019-04-03',9.12,'2018-10-19 06:16:25',0,41,1,'00593 Gateway Junction',13);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (44,26,'2018-09-06 07:07:44','2019-10-24',14.11,'2022-01-10 11:59:59',0,15,0,'8 Larry Place',23);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (45,42,'2016-12-16 08:20:16','2016-12-28',16.79,'2023-01-26 10:35:56',0,47,1,'70214 Duke Alley',39);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (46,3,'2019-02-26 20:10:29','2017-06-13',94.14,'2020-02-02 03:33:27',1,22,0,'93 Green Point',31);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (47,34,'2018-07-22 19:00:15','2019-06-07',46.62,'2021-01-15 10:19:46',0,8,0,'07327 Forest Alley',18);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (48,8,'2017-05-07 10:02:51','2023-03-14',29.56,'2017-03-04 15:52:20',0,29,0,'40 Westend Park',2);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (49,24,'2018-04-22 23:37:00','2020-06-16',94.99,'2022-04-09 03:31:06',0,26,0,'5183 Hoard Court',10);
INSERT INTO CustOrder(order_id,customer_id,order_date,need_by_date,tip,fulfillment_date,paid,employee_id,delivery,address,driver_id) VALUES (50,16,'2022-07-07 12:57:54','2020-04-09',95.94,'2020-01-17 12:41:02',0,48,1,'13 Mifflin Hill',45);

/*Manager Inserts*/
INSERT INTO Manager(employee_id,working,first_name,last_name,company_name) VALUES (1,1,'Aguistin','Burbank','Fresh Fruits');
INSERT INTO Manager(employee_id,working,first_name,last_name,company_name) VALUES (2,0,'Tyrus','Eckly','Fresh Vegetables');
INSERT INTO Manager(employee_id,working,first_name,last_name,company_name) VALUES (3,0,'Miof mela','Sime','Fruits on the Go');
INSERT INTO Manager(employee_id,working,first_name,last_name,company_name) VALUES (4,0,'Doralin','Civitillo','Vegetables On the Go');
INSERT INTO Manager(employee_id,working,first_name,last_name,company_name) VALUES (5,0,'Alex','Keyzor','Meat and Fish Co');
INSERT INTO Manager(employee_id,working,first_name,last_name,company_name) VALUES (6,0,'Merrile','Adelsberg','Dairy Direct');
INSERT INTO Manager(employee_id,working,first_name,last_name,company_name) VALUES (7,0,'Adele','Pollok','FrozenFoodz');
INSERT INTO Manager(employee_id,working,first_name,last_name,company_name) VALUES (8,1,'Debera','Sidnell','Fresh Bread');

/*StoreOrderDetails Inserts*/
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (1,1,81);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (2,2,50);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (3,3,95);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (4,4,29);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (5,5,23);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (6,6,24);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (7,7,58);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (8,8,24);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (9,9,63);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (10,10,6);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (11,11,51);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (12,12,89);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (13,13,33);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (14,14,61);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (15,15,61);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (16,16,92);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (17,17,94);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (18,18,17);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (19,19,35);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (20,20,61);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (21,21,61);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (22,22,60);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (23,23,14);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (24,24,59);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (25,25,61);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (26,26,84);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (27,27,78);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (28,28,31);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (29,29,36);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (30,30,9);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (31,31,54);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (32,32,2);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (33,33,12);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (34,34,61);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (35,35,13);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (36,36,33);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (37,37,10);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (38,38,1);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (39,39,65);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (40,40,64);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (41,41,17);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (42,42,67);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (43,43,85);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (44,44,80);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (45,45,68);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (46,46,70);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (47,47,56);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (48,48,85);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (49,49,71);
INSERT INTO StoreOrderDetails(order_id,product_id,quantity) VALUES (50,50,13);

/*CustOrderDetails Inserts*/
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (1,1,14);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (2,2,8);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (3,3,14);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (4,4,10);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (5,5,20);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (6,6,3);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (7,7,19);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (8,8,6);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (9,9,17);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (10,10,18);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (11,11,3);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (12,12,17);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (13,13,11);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (14,14,4);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (15,15,17);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (16,16,13);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (17,17,13);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (18,18,2);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (19,19,17);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (20,20,10);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (21,21,8);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (22,22,5);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (23,23,7);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (24,24,19);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (25,25,1);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (26,26,18);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (27,27,11);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (28,28,11);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (29,29,8);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (30,30,5);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (31,31,4);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (32,32,20);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (33,33,8);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (34,34,12);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (35,35,6);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (36,36,12);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (37,37,5);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (38,38,17);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (39,39,6);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (40,40,1);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (41,41,15);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (42,42,3);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (43,43,11);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (44,44,12);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (45,45,19);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (46,46,18);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (47,47,14);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (48,48,8);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (49,49,5);
INSERT INTO CustOrderDetails(order_id,product_id,quantity) VALUES (50,50,3);
