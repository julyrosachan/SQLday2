
create database ecommercesDB;

use ecommercesDB;


create table categories (
    id int identity(1,1) primary key,
    name nvarchar(100) not null,
    description nvarchar(200)
);

insert into categories values
('electronics', 'electronic products'),
('clothes','wearable items'),
('school items', 'back to school')

select * from categories;

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

insert into products values
('Samsung Galaxy Buds pro 2', 'you can listen everywhere ;)', 105, 1),
('Scarf', 'warm', 49.9,2),
('Iphone 15 PRO', 'smart phone', 3399.9,1),
('Sketchbook', 'for drawing and sketching', 25, 3),
('BackPack', 'for your books', 125,3)






 select * from products;

create table customers (
    id int identity(1,1) primary key,
    name nvarchar(100) not null,
    email nvarchar(100),
    phone nvarchar(20)
);

insert into customers values
(N'Röya Əliyeva','roya@gmail.com','0505555555'),
(N'Emin Məmmədov','emi@gmail.com','0994676767'),
(N'Həmayıl Qasımlı', 'hemayil@gmail.com','07023232323'),
(N'Təhmasib Muradov', 'tehmasib@gmail.com','0773456767'),
(N'Yasin Quliyev', 'yasin@gmail.com','0552552525')

select * from customers;

create table orders (
    id int identity(1,1) primary key,
    customerid int,
    orderdate datetime default getdate(),
    status nvarchar(50),
    foreign key (customerid) references customers(id)
);

insert into orders (customerid, status) values 
(1, 'Completed'),
(2, 'Completed'),
(3, 'Completed'),
(4, 'Pending'),
(5, 'Pending')

select * from orders;



create table orderitems (
    id int identity(1,1) primary key,
    orderid int,
    productid int,
    quantity int,
    unitprice decimal(10,2),
    foreign key (orderid) references orders(id),
    foreign key (productid) references products(id)
);

insert into orderitems (orderid, productid, quantity, unitprice) values 
(1,2,1,49.9),
(2,3,2,3399.9),
(3,2,3,49.9),
(4,5,2,125),
(5,4,6,25);

select * from orderitems;

create table productsuppliers (
    productid int,
    supplierid int,
    primary key (productid, supplierid),
    foreign key (productid) references products(id),
    foreign key (supplierid) references suppliers(id)
);

UPDATE o
SET TotalAmount = x.Total
FROM orders o
JOIN (
    SELECT orderid, SUM(quantity * unitprice) AS Total
    FROM orderitems
    GROUP BY orderid
) x ON o.id = x.orderid;

-- 1
SELECT c.name, COUNT(o.id) TotalOrders
FROM customers c LEFT JOIN orders o ON c.id=o.customerid
GROUP BY c.name;

-- 2
SELECT c.name, SUM(oi.quantity*oi.unitprice) TotalAmount
FROM customers c
JOIN orders o ON c.id=o.customerid
JOIN orderitems oi ON o.id=oi.orderid
GROUP BY c.name
HAVING SUM(oi.quantity*oi.unitprice) > 5000;

-- 3
SELECT o.id, o.TotalAmount, SUM(oi.quantity*oi.unitprice) Calculated
FROM orders o JOIN orderitems oi ON o.id=oi.orderid
GROUP BY o.id,o.TotalAmount;

-- 4
SELECT cat.name, SUM(oi.quantity) Qty, SUM(oi.quantity*oi.unitprice) Amount
FROM categories cat
JOIN products p ON cat.id=p.categoryid
JOIN orderitems oi ON p.id=oi.productid
GROUP BY cat.name;

-- 5
SELECT *
FROM (
    SELECT c.id,c.name,cat.name Category,SUM(oi.quantity) Qty,
           ROW_NUMBER() OVER(PARTITION BY c.id ORDER BY SUM(oi.quantity) DESC) rn
    FROM customers c
    JOIN orders o ON c.id=o.customerid
    JOIN orderitems oi ON o.id=oi.orderid
    JOIN products p ON oi.productid=p.id
    JOIN categories cat ON p.categoryid=cat.id
    GROUP BY c.id,c.name,cat.name
)t WHERE rn=1;

CREATE VIEW CustomerOrderSummary
AS
WITH CategoryOrders AS (
    SELECT c.id CustomerID, cat.name CategoryName, SUM(oi.quantity) Qty
    FROM customers c
    JOIN orders o ON c.id=o.customerid
    JOIN orderitems oi ON o.id=oi.orderid
    JOIN products p ON oi.productid=p.id
    JOIN categories cat ON p.categoryid=cat.id
    GROUP BY c.id,cat.name
),
TopCategory AS (
    SELECT CustomerID, CategoryName
    FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY Qty DESC) rn
        FROM CategoryOrders
    )x WHERE rn=1
)
SELECT 
    c.id CustomerID,
    c.name CustomerName,
    COUNT(DISTINCT o.id) TotalOrders,
    ISNULL(SUM(oi.quantity*oi.unitprice),0) TotalAmount,
    tc.CategoryName MostOrderedCategory
FROM customers c
LEFT JOIN orders o ON c.id=o.customerid
LEFT JOIN orderitems oi ON o.id=oi.orderid
LEFT JOIN TopCategory tc ON c.id=tc.CustomerID
GROUP BY c.id,c.name,tc.CategoryName;


select * from CustomerOrderSummary;
