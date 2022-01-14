--JOIN Arten: 

select * from customers c
inner join orders o on c.CustomerID=o.CustomerID

--JOIN Arten: 
--MERGE  
--beide tabelle nur einmal durchsuchen.. dann m�ssen die Spalten sortiert sein

--NESTED LOOP JOIN 
--pro Zeile der �ussere Tabelle einen Durchlauf in dern anderen Tabelle
--�ussrere Tabelle sehr klein (bzw Ergebnis der �usseren),,,,,,,, die innerer sollte sortiert sein


--Hash JOIN
--kommt meist dann vor, wenn kein IX vorliegt
--oder die Tabellen sehr gro� sind

select * from customers c
inner merge join orders o on c.CustomerID=o.CustomerID

--Adaptive JOIN ab SQL 2017 .. kann w�hrend des Ausf�hrungsphase sich zu einem HASH oder LOOP Join entschieden
--Plan kann also wiederverwedent werden

--wer ist besser...? Plan Vergleich
select * from customers c
inner loop join orders o on c.CustomerID=o.CustomerID

select * from customers c
inner hash join orders o on c.CustomerID=o.CustomerID


--PROZEDUREN aus TAG 1

create proc gp_kundenSuche @kdid nchar(5)
as
select * from customers where @kdid = '' or Customerid like Concat(@kdid, '%')
--select * from customers where customerid like @kdid + '%'

exec gp_kundenSuche 'ALFKI'   --%  Prozedur bringt als Ergebnis aml einen oder alle Datens�tze ztur�ck
--Eigtl SEEK oder SCAN... aber das tut sie leider nicht...

--Grund f�r Prozeduren
--Login abbilden
-- Prozeduren sind schneller

--bei Proz wird der Plan beim ersten Aufruf kompiliert mit den ersten Parametern optimiert
--auch nach Neustart der selbe Plan


select * into ku4 from ku2

--NIX_ID
set statistics io, time on
--unter 11000 IX Seek mit Lookup
select * from ku4 where id < 1000000 --wird ein Table SCAN --42165,  Table SCAN


create proc gpsuchid @id int
as
select * from ku4 where id <@id


exec gpSuchId 10

exec gpSuchId 1000000 --1002235 --Tabelle hat aber nur 42000, deutlich mehr CPU


dbcc freeproccache --Vorsicht.. Gesamter Cache wird gel�scht
--ab SQL 2016 ist das besser

exec gpSuchId 50000

exec gpSuchId 10 --42000 weil immer Table Scan

exec gpSuchId 1000000 --auch hier 42000 Seiten

--Frage: was wird h�ufiger verwendet... 

--korrekter w�re

create gpKundensuche @kdid varchar(5)
as
if @kdid = ''
exec gpKundensuchealle
else
exec gpKundensuche @kdid



create proc gpdemo @par --with recompile
as
If @par= 1
select * from orders where.....--besser:exec proc1
else
select * from customers where ....--besser proc2




--Funktionen
--wenn in der where Bedingungen eine Funktion um eine Spalte gebildet wird..
--ist das grandios schelcht--> ergibt immerm einen SCAN!!!

select * from Employees where DATEDIFF(DD, BirthDate, SYSDATETIME()) > 65 * 365
select * from employees where birthdate > dateadd(yy,-65,getdate())


select * from customers where customerid like 'A%'

select * from customers where left(customerid ,1) = 'A' --immer SCAN

--TIPP: Funktion sind immer schlecht , bis das Gegenteil bewiesen wurde


--Ausf�hrungspl�ne k�nnen sehr geren im Fall von F() l�gen..
--so wird zB die F() mit sehr eringen Kosten angezeit im Plan
--wobei gerade die F() die hchsten Kosten haben m�sste

create function fRngSumme(@bestid int)
returns money
as
begin
	return (select sum(unitprice*quantity) from [Order Details] where orderid = @bestid)
end


select dbo.frngsumme(10248)



select dbo.fRngsumme(orderid),* from orders


alter table orders add RngSumme as dbo.fRngSumme(orderid)

select * from orders where rngsumme < 500


--Anwendung von Variablen .. die k�nnen vorab nicht gesch�tzt werden.. 
--evtl ist der Plan auf der Basis der falsch gesch�tzten Werte ung�nstig


-----SQL Sprache ist CaseSesnsitive , was performance betrifft
--Pl�ne werden mit einem HashWert gespeichert... der ist je nach Gro� und Keinschriebung
-- , Zeilenumbruch anders
--3 Pl�ne statt einen!!

select * from customers where customerid = 'ALFKI'


select * from customers where Customerid = 'ALFKI'

select * from customers 
						where Customerid = 'ALFKI'


--das Gleiche gitl f�r Parametereinsch�tzung..siehe dazu Planwiederholung Z_Planwiederholung.sql
select * from orders where orderid < 10---tinyint

select * from orders where orderid < 300 --smallint

select * from orders where orderid < 50000 --int


--es gibt ein Mittel: Stored Procedures





select country as Land, sum(unitprice*quantity) as Umsatz
from customers c inner join orders o on c.CustomerID= o.CustomerID
								inner join [Order Details] Od on od.OrderID=o.orderid
where country = 'USA'
group by country
order by country, umsatz


select country as Land, sum(unitprice*quantity) as Umsatz
from customers c inner join orders o on c.CustomerID= o.CustomerID
								inner join [Order Details] Od on od.OrderID=o.orderid
where c.country = 'USA' --Land nicht m�glich
	 --and Umsatz < 100 --nicht m�glich
group by country having sum(unitprice*quantity)  < 100 --geht auch hier nicht  
order by Land, umsatz



---Logischer Fluss
--tu niemals etwas mit having filtern was ein where kann
--das having hat immer nut AGG als Filter--> SELECT (Berchn. Alias)-->Order By --> TOP DISTINCT-- AUsgabe

/*
FROM--> (ALIASE TABELLEN)-->JOIN--> WHERE - AND /OR  --> GROUP BY --> HAVING









