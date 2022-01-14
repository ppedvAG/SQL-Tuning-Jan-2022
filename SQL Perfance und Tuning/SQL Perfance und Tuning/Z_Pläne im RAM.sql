dbcc freeproccache;
GO
select * from orders where customerID='HANAR'
go

select * from Orders where CustomerID='HANAR'
go
select * from Orders 
	where   CustomerID='HANAR'
go

--3 Pläne.. nur wg Groß und Klein und Zeilenumbruch

select usecounts, cacheobjtype,[TEXT] from
	sys.dm_exec_cached_plans P
		CROSS APPLY sys.dm_exec_sql_text(plan_handle)
	where cacheobjtype ='Compiled PLan'
		AND [TEXT] not like '%dm_exec_cached_plans%'


--wie läßt sich das Problem umgehen neue Pläne zu erstellen: --> Prozeduren


dbcc freeproccache
select firstname, lastname, title from Employees
	where EmployeeID = 6 --tinyint
go
select firstname, lastname, title from Employees
	where EmployeeID = 300 --smallint

select firstname, lastname, title from Employees
	where EmployeeID = 70000 --int


--Plan : @1  welcher Datentyp
select * from orders where orderid = 10251 --kommt ein Join .. nö

--Pläne sollte wiederverwendbar: CPU sparst, man gewinnt Zeit


while 10000
begin

	set stat... off
	set stat.. on



---go 20000  25 --I UP D = TX


--while .. 6 8 sek

declare @i as int = 50000
begin tran
while @i< 70000
	begin
		insert into ptab (nummer, spx) values (@i, 'XY')
		set @i+=1
	end
commit
end

--Transactions

begin transaction --Sperren: Niveau: Row, Page Extent, Table
ins --Sperren
up --Sperren
del --Sperrren
rollback


--Das Sperrniveau ist abhängig von der Menge der Daten und Indizes
--Zeile .. 91bytes
--300 Zeilen--> Seite 1 * 91byte
--mehr Seiten--> Block*91
--mehr blöcke --> Tabelle

--während des Änderns.. greift jemand anderer zu: nichts
--default: READ COMMITTED  






