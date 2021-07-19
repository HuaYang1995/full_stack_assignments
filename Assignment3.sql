--1.In SQL Server, assuming you can find the result by using both joins and subqueries, which one would you prefer to use and why?
-- Normally, I prefer to use the join instead of subquery. Since It is faster generally, and easy to read
--2.What is CTE and when to use it?
--CTE is Common Table Expressions.  We use it to create a recursive query.
--Substitute for a view when the general use of a view is not required; that is, you do not have to store the definition in metadata.
--Using a CTE offers the advantages of improved readability and ease in maintenance of complex queries. The query can be divided into separate, simple, logical building blocks. These simple blocks can then be used to build more complex, interim CTEs until the final result set is generated. 
--CTEs can be defined in user-defined routines, such as functions, stored procedures, triggers, or views.

--3.What are Table Variables? What is their scope and where are they created in SQL Server?
 --A table variable is a data type that can be used within a Transact-SQL batch,
 -- stored procedure, or function—and is created and defined similarly to a table, 
 --only with a strictly defined lifetime scope. 
--4.What is the difference between DELETE and TRUNCATE? Which one will have better performance and why?
 --Truncate reseeds identity values, whereas delete doesn't.
 --Truncate removes all records and doesn't fire triggers.
 --Truncate is faster compared to delete as it makes less use of the transaction log.
 --Truncate is not possible when a table is referenced by a Foreign Key 
 --or tables are used in replication or with indexed views.

--5.What is Identity column? How does DELETE and TRUNCATE affect it?
 --Identity column of a table is a column whose value increases automatically.
 -- Truncate will reseeds the values in the identity column, but the delete doesn't.
--6.What is difference between “delete from table_name” and “truncate table table_name”?
 --truncate table will pass the table name and then remove all rows.
 -- delte from table_name will remove all records from the table.

--1.
select distinct(c.City) from Customers c inner join Employees e 
on c.city = e. City where c.CustomerID is not null
and e. EmployeeID is not null

--2. use sub-query
select c.city from Customers c
where c.city not in (select e.city from Employees e)
--  do not use sub-query
select c.City from Customers c left join Employees e
on c.City=e.City where e.EmployeeID is null

--3.
select p.ProductName,sum(Quantity) as Quantity from Products p inner join [Order Details] o
on p.ProductID=o.ProductID
 group by p.ProductName

--4.
select city, sum(quantity) as quantity from Customers c left join Orders a
on c.CustomerID=a.CustomerID left join [Order Details] o
on a.OrderID=o.OrderID
group by City

--5.
select City,count(City) as count from Customers group by City
having count(City)>2

--6.
select City,count(distinct(productID)) as different_product from Customers c inner join Orders a
on c.CustomerID=a.CustomerID inner join [Order Details] o
on a.OrderID=o.OrderID 
group by city having count(distinct(productID))>2

--7.
select distinct(c.CustomerID) from Customers c inner join Orders a
on c.CustomerID=a.CustomerID inner join [Order Details] o
on a.OrderID=o.OrderID where ShipCity != c.City

--8.
select o.productID,avg(o.UnitPrice) as [average price], max(quantity) as quantity from Customers c inner join Orders a
on c.CustomerID=a.CustomerID inner join [Order Details] o
on a.OrderID=o.OrderID where o.ProductID in
(select top 5 productID from [Order Details] group by productID
order by count(ProductID) DESC) group by o.ProductID

--9.
-- use sub-query
select city from Employees e where e.city not in(select distinct(city) from Customers c inner join Orders a 
on c.CustomerID=a.CustomerID )

--do not use sub-query

select distinct e.City from Employees e
left join Customers c
on e.City = c.City
where c.City is null

--10.
select * from
(select Top 1 e.City, count(a.OrderID) count from Employees e inner join Orders a
on e.EmployeeID = a.EmployeeID
group by e.City) dt
inner join (
select Top 1 c.City, count(o.Quantity) countQuantity from [Order Details] o inner join
Orders b on o.OrderID = b.OrderID
inner join Customers c on c.CustomerID = b.CustomerID group by c.City) df
on dt.City = df.City;

--11. --we can use the group by and having count(*)>1 to find duplicated rows and then  --use the delete function to delte them from the table.--12.--select empid from employee e--where e.mgrid is not null and empid not in--(select mgrid from employee)--13.--select deptname, count(empid),--rank()over(partition by e.deptid order by count(empid) desc) rnk--from dept d inner join employee e--on d.deptid=e.deptid --group by deptname--where rnk==1--order by deptname--14.--select deptname,empid,salary from--(select d.deptname, e.empid.e.salary,--rank()over(partition by e.deptid. order by e.salary desc) rnk from dept d, employee e--where d.deptid= e.deptid)--where rnk<=3--order by deptname,rnk