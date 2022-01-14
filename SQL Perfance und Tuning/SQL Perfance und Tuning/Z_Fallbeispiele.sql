--Fallbeispiele: 

select * from ku1 where id < 2

--Idee: mach ich �fter!.. schneller mit: Prozeduren, weil der Plan nach erste Aufruf kompiliert

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

--oder per Abfragespeicher auff�llige Stements mit gro�en Abweichungen finden
--inkl K�ntrolle per Anzahl der Aufrufe 
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
 --zus�tzlichen Spalten.. werden gerne bei HEAP als Extraseiten abgelegt...
 --Forward Record count
 --m�sste nicht sein.. aber diese sind immer zus�tzlich zu lesen.


 dbcc showcontig('ku1') ---42189 --veraltet

 select * from ku1 where customerid like '%X' --56385  TABLE SCAN

 exec gpKundensuche '%'
 --zus�tzliche Spalte ID...
 select db_id(),object_id('ku1')
 --neu:
 select * from sys.dm_db_index_physical_stats(db_id(), object_id('ku1'), NULL,NULL,'detailed')
 --forward_record_Count: 14196

 --index_Id: 0 = HEAP   1=CL IX    >1 NCL IX

 --nach CL IX : 43176!!

 --jede Tabelle mit CL IX hat nie forward record counts!!!



 --FALL 4: 
 --SQL parametrisiert gerne Abfragen um Pl�ne nicht neu erstellen zu m�ssen...
 --leider geht das nur begrenzt... (zB Join.. und schon wird nicht mehr parametrisiert)

 --Unteschied zw gesch. und tats Plan?


 select * from ku1  inner join customers c on c.customerid = ku1.customerid  where id = 10000

 --MIttel um Pl�ne nicht neu machen zu m�ssen?
 --> Prozeduren!!

 ---manchmal kann auch der DAtentyp, der f�r die Parametrisierung gefunden wird 
 --falsch "werden"
 select * from ku1
 
  select * from ku1  where id = 10 --tinyint 0- 255
  
  select * from ku1  where id = 3000--smallint 0- 32000

  select * from ku1  where id = 60000--int

   --oder es ist die Schreibweise, weil SQL Server Pl�ne als Hashwert speichert.
   --durch Gro� und Kleinschreibung , oder Zeilenumbruch �ndert sich ein Hashwert

  select * from customers where customerid = 'ALFKI' --4

  select * from Customers where customerid = 'ALFKI'--5

  select * from customers where Customerid = 'ALFKI' --6

  
  select * from customers 
	where Customerid = 'ALFKI' --7


	---Prozeduren

