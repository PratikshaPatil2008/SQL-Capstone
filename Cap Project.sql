--CAP- PROJECT

--SCENARIO
--You are hired as a Junior Data Analyst for a retial company
--that sells electronics and accessories
--your manager wants you to analyse sales and customer data using SQL in SSMS

create database Project;
use project;


create table Customers(
	CustomerID INT PRIMARY KEY,
	FirstName VARCHAR(100),
	LastName VARCHAR(100),
	City VARCHAR(100),
	JoinDate DATE
);

Insert into Customers values
(1,'John','Doe','Mumbai','2024-01-05'),
(2,'Alice','Smith','Delhi','2024-02-15'),
(3,'Bob','Brown','Bangalore','2024-03-20'),
(4,'Sara','White','Delhi','2024-01-25'),
(5,'Mike','Black','Chennai','2024-02-10');



 select * from Customers;

 CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate DATE,
    Product VARCHAR(50),
    Quantity INT,
    Price INT
);

INSERT INTO Orders VALUES
(101, 1, '2024-04-10', 'Laptop', 1, 55000),
(102, 2, '2024-04-12', 'Mouse', 2, 800),
(103, 1, '2024-04-15', 'Keyboard', 1, 1500),
(104, 3, '2024-04-20', 'Laptop', 1, 50000),
(105, 4, '2024-04-22', 'Headphones', 1, 2000),
(106, 2, '2024-04-25', 'Laptop', 1, 52000),
(107, 5, '2024-04-28', 'Mouse', 1, 700),
(108, 3, '2024-05-02', 'Keyboard', 1, 1600);


select * from Customers;
select * from orders;
 

 --Part A: Basic Queries

 --1) Get the list of all cudtomers from mumbai
 select * from Customers where city = 'mumbai';
--Sara And John are from mumbai

 --2) show all orders for laptops
 select * from Orders where product = 'Laptop';
 --There are 3 orders placed for laptop

 --3) find the total no of orders placed
 select count(*) AS TotalOrders from orders;
 --there of 8 orders are placed

 --* find price between 50000 and 80000
 select * from orders where price between 50000 and 80000;
 --there are 3 customers who shoped between 50k to 80k

--* find products with price > 10000
select * from orders where price > 10000;
 --there are 3 customers who shoped between > 10k


 --Part b: Joins

 --4)get full name of customer and their product order
 select c.firstname + '' + c.lastname AS FullName, o.product
 from Customers c join Orders o
 on c.CustomerID = o.CustomerID;

 --5) Find customers who not placed any order
 select c.customerid, o.orderid
 from Customers c join orders o                                                     --by joins
 on c.CustomerID = o.CustomerID
 where o.OrderID is null;

 select * from Customers                                                            --by subquery
 where CustomerID not in (select distinct customerid from orders);


 --Part C: Aggregation

 --6) Find the total revenue from all orders
 select sum(price * quantity) as totalrevenue
 from orders;

 --7) find total quantity of mouse sold
 select sum(quantity) as TotalRevenue
 from Orders;


 --Part D: Group By
 
 --8) show total sales amount per customer
 select c.firstname, sum(o.quantity * o.price) as SALES
 from Customers c join orders o 
 on c.CustomerID = o.CustomerID
 group by c.FirstName;

 --9) show no of orders per city
 select c.city, count(o.orderid) as Orders
 from Customers c join Orders o
 on c.CustomerID = o.CustomerID
 group by c.City;


 --Part E: Subquery and case

 --10)find customer who spent more than 50k
select c.* from Customers c
where c.CustomerID in (
    select CustomerID from orders
    group by CustomerID
    having sum(price) > 50000);


--11) write a query to display each order with a lable:
--'high value' if price > 50000
--'low value' else

select orderid,price,
case
    when price > 50000 then 'high value'
    else 'low value'
end as ValueLable
from orders;

--Part F: Window Function

--12) find running total of revenue by order date
select orderid, orderdate, price,
    sum(price) over (order by orderdate) as runningrevenue
from orders;


--13) Assign a row no to each customer id order by order date(oldest first)
select orderID, customerID, OrderDate, Price,
    row_number() over (partition by CustomerID ORDER by orderdate) As RowNum
    from orders;


--*) Assign row_number to each customer id order by price
select orderID, customerID, OrderDate, Price,
    row_number() over (partition by CustomerID ORDER by price) As RowNum
    from orders;


--14) Use rank to rank order by price (high to low)
select orderID, customerID, Price,
    rank() over (order  by price desc) as PriceRank
from orders;


--*) Use rank to rank order by quantity (high to low)
select orderID, customerID, Quantity,
    rank() over (order  by quantity desc) as QuantityRank
from orders;


--15) Use dense rank to rank orders by price (high to low) --explain diff with rank
select orderID, customerID, Price,
    dense_rank() over (order  by price desc) as PriceRank
from orders;

update Orders                                            
set price = 55000
where price = 52000;

select * from Orders;


--16) find customer who placed more by 1 order by using having
select customerid, count(orderid) as totalorders
from orders
group by CustomerID
having count(orderid) > 1;