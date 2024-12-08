USE AdventureWorks2019

--1
/*
Write a query that displays information about products that have not been purchasedin the 
Orders table. Show: ProductID, Name (ProductName), Color, ListPrice, Size. Sort the report 
by ProductID.
*/

SELECT p.ProductID, p.name as Name , p.Color , p.ListPrice, p.Size
FROM  [Production].[Product] AS p LEFT JOIN [Sales].[SalesOrderDetail] AS S
ON s.ProductID = p.ProductID 
where s.ProductID is null
order by p.ProductID

go

--2
/*
Write a query that displays information about customers who have not placed any orders. 
Show CustomerID, LastName of the customer, and sort the report by CustomerID in ascending order. 
If the customer has no LastName or FirstName, display 'Unknown' instead of the name
*/

with cte 
as 
(select c.CustomerID
from [Sales].[Customer] as c
left join[Sales].[SalesOrderHeader] AS S
on s.CustomerID= c.CustomerID
where s.CustomerID is null
)
select C.CustomerID, ISNULL(P.LastName, 'Unknown') as lastName, ISNULL(P.FirstName, 'Unknown') as FirstName
from cte as c  LEFT JOIN [Person].[Person] as p
ON C.CustomerID = P.BusinessEntityID
order by c.CustomerID
 


go

--3
/*
"Write a query that displays the details of the 10 customers who have placed the most orders. 
Show CustomerID, FirstName, LastName, and the number of orders placed by the customers, 
sorted in descending order
*/

with orders
as
(
select TOP 10 S.CUSTOMERID , count(*) as CountOfOrders
From [Sales].[SalesOrderHeader] AS S
GROUP BY S.CustomerID
ORDER BY 2 DESC
)
select o.CustomerID, p.FirstName, p.LastName, CountOfOrders
from orders as o  inner join [Sales].[Customer] as c
on o.CustomerID= c.CustomerID
inner JOIN [Person].[Person] as p
ON C.PersonID = P.BusinessEntityID

go

--4
/*
Write a query that displays information about employees and their job titles 
(FirstName, LastName, JobTitle, HireDate), along with the number of employees
who hold the same job title as the employee
*/

select p.FirstName, p.LastName, JobTitle, HireDate, 
	count(JobTitle)over(partition by jobtitle order by jobtitle) as CountOfTilte
from [HumanResources].[Employee] as e
inner join [Person].[Person] as p
	on e.BusinessEntityID = p.BusinessEntityID

go

--5
/*
Write a query that displays for each customer the date of their most recent order and the date 
of the order before that. Display: SalesOrderID, CustomerID, LastName, FirstName, the date of 
the most recent order, and the date of the order before that
*/

with Orders
as
(
	select s.SalesOrderID, s.CustomerID, OrderDate as LastOrder ,  
	LEAD(OrderDate)over(partition by customerid order by orderdate desc) as PreviousOrder,
	rank()over(partition by customerid order by orderdate desc) as rnk 
	From [Sales].[SalesOrderHeader] as s 
)
	SELECT  o.SalesOrderID, o.CustomerID,LastName ,FirstName ,LastOrder,  PreviousOrder
	FROM ORDERS as o  
	inner join [Sales].[Customer] as c
		on o.CustomerID= c.CustomerID
	inner join [Person].[Person] as p
		ON C.PersonID = P.BusinessEntityID
	where rnk =1 
	order by CustomerID

	go

--6
/*
Write a query that displays the total value of products in the most expensive order for each year.
The query should show which customers the orders belong to. 
Display: Order Date Year, Order Number, Customer's Last Name and First Name, and the total value
of the order
*/

with orders as (
	select sod.SalesOrderID, sum(sod.OrderQty* sod.UnitPrice*(1-sod.UnitPriceDiscount)) as total, YEAR(OrderDate) AS YEAR , CustomerID
	from [Sales].[SalesOrderDetail] as sod 
	inner join [Sales].[SalesOrderHeader] as SOH
		ON SOH.SalesOrderID = SOD.SalesOrderID
	group by sod.SalesOrderID , YEAR(OrderDate), CustomerID
),
max_order as (
	SELECT YEAR , SalesOrderID, 
	rank()over(partition by year order by total desc) as rnk 
	FROM orders
	GROUP BY YEAR, SalesOrderID, total
)
	select o.Year,o.SalesOrderID,p.LastName, p.FirstName, format (total, 'N1') as Total
	from orders as o
		inner join max_order as m
	on o.SalesOrderID = m.SalesOrderID
		inner join [Sales].[Customer] as c
	on c.CustomerID = o.customerid
		inner join [Person].[Person] as p
	on p.BusinessEntityID = c.PersonID
	where rnk =1
	
	go

--7
/*
Display the number of orders made in each month of the year using a matrix
*/
select *
from(select month(OrderDate) as Month, year (OrderDate) as year,SalesOrderID
from [Sales].[SalesOrderHeader]) as o
pivot(COUNT(SalesOrderID) for year in ([2011],[2012],[2013],[2014]))as pvt
order by month

go

--8
/*
Write a query that displays the total value of products in orders for each month of the year, 
as well as the cumulative total for each year. Make sure the report is visually clear. 
Include a row highlighting the yearly total.
*/

with sum_price as (
	select 
		year(orderdate) as Year,
		month(orderdate) as Month ,
		sum(UnitPrice) as Sum_Price  
	from [Sales].[SalesOrderHeader] as soh 
	inner join [Sales].[SalesOrderDetail] as sod
		on soh.SalesOrderID = sod.SalesOrderID
	group by year(orderdate), month(orderdate) 
),
cum_sum as(
	select *,
		sum(sum_price)over(partition by year order by year, month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as CumSum
	from sum_price
)
select 
	cast(Year as varchar) as Year, 
	cast(Month as varchar) as	Month, 
	round(sum_price,2) as Sum_Price, 
	round(cumsum,2) as CumSum
from cum_sum
union
select 
	cast(Year as varchar) as Year,  
	'grand_total', 
	Null, 
	round (sum(sum_price)over (partition by year order by year), 2)
from sum_price
union 
select
	'total all', null, Null, round (sum(sum_price),2)
from sum_price
order by year, cumsum, Month

go

--9
/*
Write a query that displays employees by their hire date within each department, 
from the most recently hired to the longest employed. Display the following columns: 
Department Name, Employee ID, Full Name, Hire Date, Employee's tenure in the company (in months), 
Full Name and Hire Date of the employee hired before them, 
and the number of days between the employee's hire date and the employee hired before them
*/

with Employees
as
(
	select e.BusinessEntityID as [Employee'sId]  , concat(p.FirstName, ' ', p.LastName) as [Employee'sFullName] ,
	DATEDIFF(Mm, HireDate, getdate()) as Seniority, HireDate
	from [HumanResources].[Employee] as e inner join [Person].[Person] as p
		on p.BusinessEntityID = e.BusinessEntityID
),
dep
as
(
	select d.name as DepartmentName, [Employee'sId],  [Employee'sFullName], e.HireDate, E.Seniority,
	lag([Employee'sFullName])over(partition by d.name order by hiredate) as PreviuseEmpName,
	lag(hiredate)over(partition by d.name order by hiredate) as PreviuseEmpHDate
	from Employees as e inner join [HumanResources].[EmployeeDepartmentHistory] as dh
		on[Employee'sId] = dh.BusinessEntityID
	inner join [HumanResources].[Department] as d
	on d.DepartmentID = dh.DepartmentID
)
select *, DATEDIFF(dd, previuseEmpHDate ,hiredate) as DiffDays
from dep
order by DepartmentName, hiredate desc

go

--10
/*
Write a query that displays details of employees who work in the same department and were hired 
on the same date. The employee details should be listed for each combination of hire date and 
department number, sorted by the hire dates in descending order
*/

select hireDate, DepartmentID, string_agg(concat(dh.BusinessEntityID,' ', p.LastName, ' ', p.FirstName), ',') as TeamEmployees
from [HumanResources].[Employee] as e inner join [Person].[Person] as p
	on p.BusinessEntityID = e.BusinessEntityID
inner join [HumanResources].[EmployeeDepartmentHistory] as dh
	on e.BusinessEntityID = dh.BusinessEntityID
where EndDate is null
group by hireDate, DepartmentID
order by hireDate desc

