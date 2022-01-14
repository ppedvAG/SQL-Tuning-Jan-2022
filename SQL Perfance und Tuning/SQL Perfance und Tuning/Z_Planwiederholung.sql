--Pläne sollten wiederverwendbar sein
--guggste

-------------------

--BIN WIEDER DA;-)


--------------------


use northwind

select * from orders inner join customers ON orders.CustomerID=Customers.CustomerID where orderid = 10



dbcc freeproccache;
GO

select * from orders where customerID='HANAR'
go

select * from Orders where CustomerID='HANAR'
go
select * from Orders 
	where   CustomerID='HANAR'
go


 --Lösung Stored Procedures










select usecounts, cacheobjtype,[TEXT] from
	sys.dm_exec_cached_plans P
		CROSS APPLY sys.dm_exec_sql_text(plan_handle)
	where cacheobjtype ='Compiled PLan'
		AND [TEXT] not like '%dm_exec_cached_plans%'

dbcc freeproccache
select firstname, lastname, title from Employees
	where EmployeeID = 6
go
select firstname, lastname, title from Employees
	where EmployeeID = 300

select firstname, lastname, title from Employees
	where EmployeeID = 70000


select usecounts, cacheobjtype,[TEXT] from
	sys.dm_exec_cached_plans P
		CROSS APPLY sys.dm_exec_sql_text(plan_handle)
	where cacheobjtype ='Compiled PLan'
		AND [TEXT] not like '%dm_exec_cached_plans%'

 --wurde parametrisiert
 --bei komplexerreen Staments keine autoparametriesierung mehr
select * from customers c inner join  orders o on c.customerid = o.customerid 
where orderid = 10251



select * from sys.dm_db_index_usage_stats

select * from sys.dm_db_index

--Brent Ozar: sp_blitzIndex

EXEC dbo.sp_BlitzIndex @DatabaseName='Northwind', @SchemaName='dbo', @TableName='ku2';

