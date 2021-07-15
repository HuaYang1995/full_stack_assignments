--1.What is a result set?
-- It is just the output of the query.

--2.What is the difference between Union and Union All?
 -- Union all doesn't remove all duplicate rows, it just select all rows from all tables.
--3.What are the other Set Operators SQL Server has?
 -- Interset and Minus.
--4.What is the difference between Union and Join?
 --Union is combine rows for two or more tables, but it requires tables have the same column type.
  --Join is combine columns for two or more tables.
--5.What is the difference between INNER JOIN and FULL JOIN?
 -- Inner join will output the records that have matching values in both tables, and the full join
 -- will output the records of all join tables no matter matched or not.
--6.What is difference between left join and outer join
 -- his join returns all the rows of the table on the left side of the 
 --join and matching rows for the table on the right side of join, and the outer join returns 
 --the same with full join.
--7.What is cross join?
 --The CROSS JOIN is used to generate a paired combination of each row of the first table 
 --with each row of the second table
--8.What is the difference between WHERE clause and HAVING clause?
-- WHERE Clause is used to filter the records from the table or used while joining more than one table
--HAVING Clause is used to filter the records from the groups based on the given condition in the HAVING Clause.
--9.Can there be multiple group by columns?
-- Yes. There can be mutiple group by columns.


--write queries for following scenarios
--1.
use AdventureWorks2017
go
select count(ProductID) from Production.Product

--2.
select count(ProductSubcategoryID) from production.Product where ProductSubcategoryID is not null

--3.
select ProductSubcategoryID,count(ProductSubcategoryID) as CountedProducts from Production.Product
where ProductSubcategoryID is not null
group by ProductSubcategoryID 

--4.
select count(ProductID) from Production.Product where ProductSubcategoryID is null

--5.
select ProductID,sum(Quantity) as quantity from production.ProductInventory group by ProductID
--6.
select ProductID,sum(quantity) as TheSum from Production.ProductInventory
where LocationID=40
group by ProductID
having sum(quantity)<100

--7.
select Shelf,ProductID,sum(quantity) as TheSum from Production.ProductInventory
where LocationID=40
group by ProductID,Shelf
having sum(quantity)<100

--8.
select avg(quantity) as AverageQuant from Production.ProductInventory
where LocationID=10

--9.
select ProductID,Shelf,avg(quantity) as TheAvg from Production.ProductInventory
group by ProductID,Shelf

--10.
select ProductID,Shelf,avg(quantity) as TheAvg from Production.ProductInventory
where Shelf !='N/A'
group by ProductID,Shelf

--11.
select Color,Class,count(Color) TheCount,Avg(ListPrice) as AvgPrice from Production.Product
where Color is not null and Class is not null
group by Color, Class

--12.
select * from person.CountryRegion
select * from person.StateProvince

select c.Name as Country, p.Name as Province from person.CountryRegion c inner join person.StateProvince p
on c.CountryRegionCode=p.CountryRegionCode

--13.
select c.Name as Country, p.Name as Province from person.CountryRegion c inner join person.StateProvince p
on c.CountryRegionCode=p.CountryRegionCode where c.Name in ('Germany','Canada')

--14.
use Northwind
go
select distinct(ProductName) from orders a inner join[Order Details]  b
on a.OrderID=b.OrderID
inner join Products p
on b.productID=p.productID
where a.OrderDate > '1996-07-14'

--15.
select top 5 a.ShipPostalCode from orders a inner join[Order Details]  b
on a.OrderID=b.OrderID
inner join Products p
on b.productID=p.productID
where a.ShipPostalCode is not null
group by a.ShipPostalCode
order by count(a.shipPostalCode)

--16.
select top 5 a.ShipPostalCode from orders a inner join[Order Details]  b
on a.OrderID=b.OrderID
inner join Products p
on b.productID=p.productID
where a.ShipPostalCode is not null
and a.OrderDate > '2001-07-14'
group by a.ShipPostalCode
order by count(a.shipPostalCode)

--17.
select City,count(CustomerID) as [number of Customers] from Customers
group by City

--18.
select City,count(CustomerID) as [number of Customers] from Customers
group by City
having count(CustomerID)>10

--19.
select distinct(ContactName) from Customers c inner join Orders a
on c.CustomerID=a.CustomerID 
where a.OrderDate > '1998-01-01'

--20.
select distinct(ContactName) from Customers c inner join Orders a
on c.CustomerID=a.CustomerID 
where a.orderDate=(select top 1 OrderDate from Orders order by OrderDate DESC) 

--21.
select ContactName,count(p.ProductID) as[number of products] from Customers as c inner join Orders a
on c.CustomerID=a.CustomerID
inner join [Order Details] b
on a.orderID=b.orderID
inner join Products p
on b.ProductID=p.ProductID
group by c.ContactName

--22.
select c.CustomerID,count(p.ProductID) as[number of products] from Customers as c inner join Orders a
on c.CustomerID=a.CustomerID
inner join [Order Details] b
on a.orderID=b.orderID
inner join Products p
on b.ProductID=p.ProductID
group by c.CustomerID
having count(p.ProductID)>100

--23.
select distinct(u.CompanyName) as [Supplier Company Name] ,h.CompanyName as [Shipping Company Name] from Shippers h,Suppliers u

--24.
select a.OrderDate,p.ProductName from Products p inner join [Order Details] b
on b.ProductID=p.ProductID inner join Orders a
on b.OrderID=a.OrderID
order by a.OrderDate

--25.
select LastName,FirstName from Employees
 where Title in ( select Title from Employees group by Title having count(title)>2)

 --26.
select LastName,FirstName from Employees
where EmployeeID in (select ReportsTo from Employees group by ReportsTo having count(ReportsTo)>2)

--27.
select City, CompanyName as Name,ContactName,Relationship as Type from [Customer and Suppliers by City]

--28.
--select * from F1 inner join F2 on F1.T1=F2.T2
--result:2 3
--       2 3

--29.
--select * from F1 left join F2 on F1.T1=F2.T2
--result: 1 Null
--        2 2
--        3 3
