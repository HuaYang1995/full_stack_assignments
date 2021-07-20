--1.What is View? What are the benefits of using views?
 --A view is a virtual table whose contents are defined by a query. --Like a real table, a view consists of a set of named columns and rows of data --benefit:
 -- Views can simplify how users work with data. You can define frequently used joins,
 -- projections, UNION queries, and SELECT queries as views so that users do not have to specify 
 --all the conditions and qualifications every time an additional operation is performed on 
 --that data 
 --Views can act as aggregated tables, where the database engine aggregates data
--2.Can data be modified through views?
 -- Yes, we can modify data through views, but it impacts the table as well

--3.What is stored procedure and what are the benefits of using it?
 --A stored procedure groups one or more Transact-SQL statements into a logical unit, stored -- as an object in a SQL Server database  --Unlike user-defined functions or views, when a stored procedure is executed for the first time 
 --(since the SQL Server instance was last started), SQL determines the most optimal query access 
 --plan and stores it in the plan memory cache. SQL Server can then reuse the plan on subsequent 
 --executions of this stored procedure.
 --Plan reuse allows stored procedures to provide fast and reliable performance  --compared to non-compiled ad hoc query equivalents  -- stored prodcedure can lead faster execution and help centralize the transact-SQL code in the data tier
--4.What is the difference between view and stored procedure?
 -- A view is a virtual table and the stored procedure groups one or more transact-sql statements into
 -- a logical unit as a object.
--5.What is the difference between stored procedure and functions?
 -- stored procedure groups transact-act sql staments into a logical unit. It can be applied multiple
 -- times and can use to query but not calculation.
 -- Function can be only used in a SQL statement, mostly in a select statement,  -- or representing a data or a dataset. -- Creates a user-defined function in SQL Server and Azure SQL Database. A user-defined function  -- is a Transact-SQL or common language runtime (CLR) routine that accepts parameters,  -- performs an action
--6.Can stored procedure return multiple result sets?
 -- Yes stored prodcedure can return multiple result sets, because it is sub routines, segment of 
 --SQL statements and contain in and out parameters or even both.

--7.Can stored procedure be executed as part of SELECT Statement? Why?
 --Yes. Store procedure can be executed as part of SELECT statement, because stored procedure
 --can return result sets which can be used as sub-query.
--8.What is Trigger? What types of Triggers are there?
 --Triggers are a special type of stored procedure  --that get executed (fired) when a specific event happens. --We have DML Triggers, DDL Triggers, LOGON Triggers
--9.What are the scenarios to use Triggers?
 --For example, if any attribute are delete,update,insert into the table,the trigger can be called
 --to show result sets or do other statements.
--10.What is the difference between Trigger and Stored Procedure?
 --Sometimes they can have the same effects in special cases. The sp groups sql statments as a logical unit 
 -- Triggers are a special type of stored procedure that get executed (fired) when a specific event happens. --trigger will run automatically when various events happen but the stored procedure need to be called 
 --mannually.



--Write queries for following scenarios
--1.Lock tables Region, Territories, EmployeeTerritories and Employees.
-- Insert following information into the database. In case of an error, no changes should be made
-- to DB.
--a.A new region called “Middle Earth”;
--b.A new territory called “Gondor”, belongs to region “Middle Earth”;
--c.A new employee “Aragorn King” who's territory is “Gondor”.
insert into Region(RegionID,RegionDescription) values(5,'Middle Earth')
insert into Territories values(66666,'Gondor',5)
insert into Employees(LastName,FirstName) values('Aragorn','King')
insert into EmployeeTerritories values(10,66666)


--2.Change territory “Gondor” to “Arnor”.
Update Territories
set TerritoryDescription='Arnor'
where TerritoryID=66666

--3.Delete Region “Middle Earth”. (tip: remove referenced data first)
--(Caution: do not forget WHERE or you will delete everything.) 
--In case of an error, no changes should be made to DB. Unlock the tables mentioned in question 1.
Delete from EmployeeTerritories
where TerritoryID=66666

Delete from Territories
where RegionID=5

delete from Region 
where RegionID=5

--4.Create a view named “view_product_order_[your_last_name]”, 
--list all products and total ordered quantity for that product.

create view view_product_order_Yang as
select p.ProductName, Count(o.Quantity) as Quantity from Products p inner join
[Order Details] o
on o.ProductID = p.ProductID
group by p.ProductName;

select * from view_product_order_Yang


--5.Create a stored procedure “sp_product_order_quantity_[your_last_name]” 
--that accept product id as an input and total quantities of order as output parameter.

create proc sp_product_order_quantity_Yang
@productID int, 
@quantity  int output
as
begin
 select @productID =[Order Details].ProductID,
 @quantity=[Order Details].Quantity from [Order Details]
 where [Order Details].ProductID=@productID
end

--6.Create a stored procedure “sp_product_order_city_[your_last_name]” that accept
--product name as an input and top 5 cities that ordered most that product combined
--with the total quantity of that product ordered from that city as output.

create proc sp_product_order_city_Yang
@prodID int,
@Shipcity varchar(30) output
as
begin
select @prodID=dttt.productID,@shipcity=dttt.ShipCity from
(select * from
(select dt.productID,dt.ShipCity,Quantity, dense_rank() over (partition by dt.productID order by dt.Quantity Desc)rnk from
(select o.productID,a.shipCity,sum(quantity) as Quantity from Orders a inner join [Order Details] o
on a.OrderID= o.OrderID group by o.ProductID,a.ShipCity) as dt) dtt
where dtt.rnk<=5)dttt
end

declare @shipcity varchar(30)
Exec sp_product_order_city_Yang 25,@shipCity OUT
print @shipCity

--7.Lock tables Region, Territories, EmployeeTerritories and Employees.
--Create a stored procedure “sp_move_employees_[your_last_name]” 
--that automatically find all employees in territory “Tory”; 
--if more than 0 found, insert a new territory “Stevens Point” 
--of region “North” to the database, and then move those employees to “Stevens Point”.

create proc sp_move_employees_Yang
@empID int
as
begin
select @empID=count(emp.employeeID) from 
(select e.employeeID,t.TerritoryDescription from Employees e inner join EmployeeTerritories et
on e.EmployeeID=et.EmployeeID inner join Territories t
on et.TerritoryID=t.TerritoryID where t.TerritoryID='Troy')emp
group by emp.TerritoryDescription
if @empID is not null 
 insert into Territories values(66666,'steven point',3)
end

--8.Create a trigger that when there are more than 100 employees in territory “Stevens
--Point”, move them back to Troy. (After test your code,) remove the trigger. Move those
--employees back to “Troy”, if any. Unlock the tables.

create trigger trigger_update_yang on territories for update
as
select dt.quantity from
(select e.employeeid,count(t.TerritoryDescription) as quantity from Territories t
join employeeterritories et on t.TerritoryID=et.TerritoryID
join Employees e on et.EmployeeID=e.EmployeeID
where t.TerritoryDescription='stevens point'
group by e.EmployeeID
having count(t.TerritoryDescription)>100)dt
if dt.quantity is not null
begin
update Territories
set TerritoryDescription='Tory' 
where TerritoryDescription='stevens point'
end

--9.Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has
--two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1,
--Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody
--Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a
--new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay.
--If any error occurred, no changes should be made to DB. (after test) Drop both tables
--and view.

create table people_yang(id int,name varchar(20),cityid int)
create table city_yang(cityid int,city varchar(20))
insert into people_yang(id,name,cityid)values(1,'Aaron Rodgers',2)
insert into people_yang(id,name,cityid)values(2,'Russell Wilson',1)
insert into people_yang(id,name,cityid)values(3,'Jody Nelson',2)
insert into city_yang(cityid,city)values(1,'Settle')
insert into city_yang(cityid,city)values(2,'Green Bay')

create view Packers_hua_yang as
select p.id, p.name from people_yang p inner join city_yang c on p.cityid=c.cityid
where c.city='Green bay'

drop table people_yang
drop table city_yang
drop view Packers_hua_yang



--10. Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a
--new table “birthday_employees_your_last_name” and fill it with all employees that
--have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not
--be affected

create proc sp_birthday_employees_yang
as
begin
create table  birthday_employees_your_yang (Id int)
insert into birthday_employees_your_yang values(11111)
end

--11.


--12.
--I can use the CHECKSUM TABLE and compare the results.
-- checksum table table_1,table_2
--or use Select * from table1 except select * from table2.
--SELECT count (1)
--    FROM table_a a
--    FULL OUTER JOIN table_b b 
--        USING (<list of columns to compare>)
--    WHERE a.id IS NULL
--        OR b.id IS NULL ;

