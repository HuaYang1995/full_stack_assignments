--1.
use AdventureWorks2017
go
select ProductID,Name,Color,ListPrice from Production.Product

--2.
select ProductID,Color,ListPrice from Production.Product where ListPrice=0

--3.
select ProductID,Color,ListPrice from Production.Product where Color is null

--4.
select ProductID, Color, ListPrice from Production.Product where Color is not null

--5.
select ProductID, Color, ListPrice from Production.Product
where Color is not null and listPrice>0

--6.
select Name,Color from Production.Product where color is not null

--7.
select 'NAME: '+ Name + ' - - COLOR: '+ Color AS [Name And Color] from Production.Product 
where Color is not null

--8.
select ProductID,Name from Production.Product where ProductID > 400 and ProductID< 500

--9.
select ProductID,Name,Color from Production.Product where Color in ('black','blue')

--10.
select * from Production.Product where Name like 'S%'

--11.
select Name,ListPrice from Production.Product order by Name 

--12.
select Name,ListPrice from Production.Product where Name like 'A%' or Name like 'S%' order by Name 

--13.
select Name from Production.Product where Name not like 'SPOK%' and Name like'SPO%' order by Name
--14.
select distinct Color from Production.Product where Color is not null order by Color DESC 

--15.
select distinct ProductSubcategoryID, Color from Production.Product 
where ProductSubcategoryID is not null and Color is not null

--16.
SELECT ProductSubCategoryID
      , LEFT([Name],35) AS [Name]
      , Color, ListPrice 
FROM Production.Product
WHERE Color IN ('Red','Black') 
      AND ListPrice BETWEEN 1000 AND 2000 
      OR ProductSubCategoryID = 1
ORDER BY ProductID 

--17. Sorry I did not find the proper order fro this table.

select  top 7 ProductSubcategoryID,Name,Color,ListPrice from Production.Product
where ProductSubcategoryID is not null
AND Name like '%[0-9]' 
AND ProductSubcategoryID<=14 
AND ListPrice=1431.5
union
select ProductSubcategoryID,Name,Color,ListPrice from Production.Product
where ProductSubcategoryID is not null
AND Name like '%[0-9]' 
AND ProductSubcategoryID=12
AND ListPrice=1364.5
union
select ProductSubcategoryID,Name,Color,ListPrice from Production.Product
where ProductSubcategoryID is not null
AND Name like '%[0-9]' 
AND ProductSubcategoryID=2
AND ListPrice=1700.99
union
select  ProductSubcategoryID,Name,Color,ListPrice from Production.Product
where ProductSubcategoryID is not null
AND Name like '%[0-9]' 
AND ProductSubcategoryID=1
AND ListPrice=539.99
order by ProductSubcategoryID DESC


