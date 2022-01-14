--Fallbeispiele: 

select * from ku1 where id < 2

--Idee: mach ich öfter!.. schneller mit: Prozeduren, weil der Plan nach erste Aufruf kompiliert

-- exec gpdemo1 2


alter proc gpdemo1 @par1 int
as
select * from ku1 where id < @par1

set statistics io, time on

exec gpdemo1 2 --SEEK

select * from ku1 where id < 1000000 --56385 --- 2600ms CPU--- 20 Sek --56000  = ganze Tabelle

exec gpdemo1 1000000 --Seiten: 1015092 .. CPU mehr as doppelt: 5969

--Ausweg kann nur sein
--entweder auf verschiedene optimierte Prozeduren zu verwaisen (diese wurden vorher "traineriert")
create proc gpdemo1 @par1 int
as
if @par1 < 11000
exec gpdemo1aSEEK @par1
else
exec gpdemo1bSCAN @par2

--oder per Abfragespeicher auffällige Stements mit großen Abweichungen finden
--inkl Kóntrolle per Anzahl der Aufrufe 
dbcc freeproccache

exec gpdemo1 1000000

exec gpdemo1 2




--FAll 2:
--benutzerfreundliche Prozeduren... mal so mal so..
---bad !   Entweder weniger oder alle.. Der Plan muss immer korrekt bleiben

 exec gpKundensuche 'ALFKI' --ALFKI  1


 create proc gpKundensuche @kdid varchar(5)
 as
 if kdid = '%' select 'kreuzweise'
 else
 select *from customers where customerid like @kdid +'%'




 --FALL 3:
 --zusätzlichen Spalten.. werden gerne bei HEAP als Extraseiten abgelegt...
 --Forward Record count
 --müsste nicht sein.. aber diese sind immer zusätzlich zu lesen.


 dbcc showcontig('ku1') ---42189 --veraltet

 select * from ku1 where customerid like '%X' --56385  TABLE SCAN

 exec gpKundensuche '%'
 --zusätzliche Spalte ID...
 select db_id(),object_id('ku1')
 --neu:
 select * from sys.dm_db_index_physical_stats(db_id(), object_id('ku1'), NULL,NULL,'detailed')
 --forward_record_Count: 14196

 --index_Id: 0 = HEAP   1=CL IX    >1 NCL IX

 --nach CL IX : 43176!!

 --jede Tabelle mit CL IX hat nie forward record counts!!!



 --FALL 4: 
 --SQL parametrisiert gerne Abfragen um Pläne nicht neu erstellen zu müssen...
 --leider geht das nur begrenzt... (zB Join.. und schon wird nicht mehr parametrisiert)

 --Unteschied zw gesch. und tats Plan?


 select * from ku1  inner join customers c on c.customerid = ku1.customerid  where id = 10000

 --MIttel um Pläne nicht neu machen zu müssen?
 --> Prozeduren!!

 ---manchmal kann auch der DAtentyp, der für die Parametrisierung gefunden wird 
 --falsch "werden"
 select * from ku1
 
  select * from ku1  where id = 10 --tinyint 0- 255
  
  select * from ku1  where id = 3000--smallint 0- 32000

  select * from ku1  where id = 60000--int

   --oder es ist die Schreibweise, weil SQL Server Pläne als Hashwert speichert.
   --durch Groß und Kleinschreibung , oder Zeilenumbruch ändert sich ein Hashwert

  select * from customers where customerid = 'ALFKI' --4

  select * from Customers where customerid = 'ALFKI'--5

  select * from customers where Customerid = 'ALFKI' --6

  
  select * from customers 
	where Customerid = 'ALFKI' --7


	---Prozeduren

