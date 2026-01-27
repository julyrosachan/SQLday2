create database ecommerceDB;

use ecommerceDB;


create table categories (
    id int identity(1,1) primary key,
    name nvarchar(100) not null,
    description nvarchar(200)
);


create table suppliers (
    id int identity(1,1) primary key,
    name nvarchar(100) not null,
    contactinfo nvarchar(200)
);


create table products (
    id int identity(1,1) primary key,
    name nvarchar(100) not null,
    description nvarchar(200),
    price decimal(10,2),
    categoryid int,
    foreign key (categoryid) references categories(id)
);

create table customers (
    id int identity(1,1) primary key,
    name nvarchar(100) not null,
    email nvarchar(100),
    phone nvarchar(20)
);


create table orders (
    id int identity(1,1) primary key,
    customerid int,
    orderdate datetime default getdate(),
    status nvarchar(50),
    foreign key (customerid) references customers(id)
);


create table orderitems (
    id int identity(1,1) primary key,
    orderid int,
    productid int,
    quantity int,
    unitprice decimal(10,2),
    foreign key (orderid) references orders(id),
    foreign key (productid) references products(id)
);


create table productsuppliers (
    productid int,
    supplierid int,
    primary key (productid, supplierid),
    foreign key (productid) references products(id),
    foreign key (supplierid) references suppliers(id)
);



