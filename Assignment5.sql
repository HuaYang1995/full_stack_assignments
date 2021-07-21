Answer following questions
--1.What is an object in SQL?
--SQL objects are schemas, journals, catalogs, tables, aliases, views, indexes,
--constraints, triggers, masks, permissions, sequences, stored procedures, user-defined functions,
--user-defined types, global variables, and SQL packages. SQL creates and maintains these objectsas system objects.
--2.What is Index? What are the advantages and disadvantages of using Indexes?
--3.What are the types of Indexes?
--4.Does SQL Server automatically create indexes when a table is created? If yes, under which constraints?
--5.Can a table have multiple clustered index? Why?
--6.Can an index be created on multiple columns? Is yes, is the order of columns matter?
--7.Can indexes be created on views?
--8.What is normalization? What are the steps (normal forms) to achieve normalization?
--It follows the rule: decide the first norm, then second norm, then third norm, then BC norm.
--each step must satisfy the previous step conditions.
--9.What is denormalization and under which scenarios can it be preferable?
--Database Normalization is a process of organizing data to minimize redundancy (data duplication),-- which in turn ensures data consistency. Move redundant data to separate table-- It is preferable when there are many tables with complicated relations.
--10.How do you achieve Data Integrity in SQL Server?
--11.What are the different kinds of constraint do SQL Server have?
--12.What is the difference between Primary Key and Unique Key?
--Unique can accept one null value but parimary key doesn’t accept any.
--One table can have multiple unique constraint but only one primary key
--Primary key will sort the data by default but unique key will not sort the data
--Primary key will by default create clustered index and unique keyy will create non clustered index.

--13.What is foreign key?
--A FOREIGN KEY is a field (or collection of fields) in one table,
-- that refers to the PRIMARY KEY in another table. 

--14.Can a table have multiple foreign keys?
-- Yes, a table can have multiple foreign keys, since they can refer to different tables.

--15.Does a foreign key have to be unique? Can it be null?
-- Since primary key is unique and not null, so the foreign key must match a non-null key.
--Then, it can not be null as well

--16.Can we create indexes on Table Variables or Temporary Tables?

--17.What is Transaction? What types of transaction levels are there in SQL Server?
--Transactions are a logical unit of work, Transcation is a single recoveral executes either:
--Completely or not at all
--Types:Read uncommitted, read committed, repeatablle read, Serialziable.


--Write queries for following scenarios

--1.Write an sql statement that will display the name of each customer and the 
--sum of order totals placed by that customer during the year 2002

use JulyBatch
Create table customer(cust_id int,  iname varchar (50))
create table [order] (order_id int,cust_id int,amount money,order_date smalldatetime)
select c.iname,sum(o.amount) from customer c inner join
on c.cust_id=o.cust_id
where year(order_date)=2002


--2.  The following table is used to store information about company’s personnel:
--write a query that returns all employees whose last names  start with “A”.
Create table person (id int, firstname varchar(100), lastname varchar(100)) 

select * from person where lastname like 'A%'

--3. The information about company’s personnel is stored in the following table:
--The filed managed_id contains the person_id of the employee’s manager.
--Please write a query that would return the names of all top managers
--(an employee who does not have  a manger, and the number of people
-- that report directly to this manager.
Create table person(person_id int primary key, manager_id int null, name varchar(100)not null)
select dt.name, count(*) from person p
left join
(select * from person p where manager_id is null) dt
on p.person_id= dt.manager_id
group by dt.name

--4.  List all events that can cause a trigger to be executed.

--Insert, Update, Delete that modify data on a table or view.

--5. Generate a destination schema in 3rd Normal Form. 
-- Include all necessary fact, join, and dictionary tables, 
--and all Primary and Foreign Key relationships.  The following assumptions can be made:
--a. Each Company can have one or more Divisions.
--b. Each record in the Company table represents a unique combination 
--c. Physical locations are associated with Divisions.
--d. Some Company Divisions are collocated at the same physical of Company Name and Division Name.
--e. Contacts can be associated with one or more divisions and the address,
-- but are differentiated by suite/mail drop records.status of each association 
--should be separately maintained and audited.

create table company (company_id int primary key, company_name varchar(20) not null)

create table divisions(division_name varchar(20), company_id int foreign key references
company(company_id),location varchar(20))

create table Contacts(Contacts_id int primary key,division_name varchar(20),phy_address varchar(20),
constraint UC_Ccontacts unique(division_name,phy_address))

create table Contacts_address(contacts_id int foreign key references Contacts(contacts_id),
suit_id int, mail varchar(20))


