--Indizes

---typischen Workload mit Abfragen des Tages
--Abfragespeicher
--Profiler


/*
--CLUSTERED INDEX  gruppierter
gibt nur 1 mal pro Tabelle..
zuerst festlegen!!! 
Bereichsabfragen
PK oft als CL IX eindeutig verschwendet
--kann man inEntwurfsasnsicht ändern


--NON CLUSTERD INDEX nicht grupp.

--bis zu 1000mal pro Tabelle
gut bei Abfragen mit rel. wenig Ergebniszeilen 1%..nicht fix

----------------------------------------------

! zusammengesetzter IX (max 16 Spalten, max 900bytes)
! IX mit eingeschl Spalten (ca 1000 Spalten)
! gefilterter IX
! abdeckender IX -- der ideale IX zur ABfrage kein Lookup kein Scan
ind Sicht --Das Ergebnis der Sicht wird indiziert 
part IX
realer hypoth. IX
! eindeutiger IX
----------------------------------------------
Columnstore IX (gr und nicht gr)




Entscheidend ist das where  > < = between like !=

NON CL 
Kopie von Daten
ca 1000 NON CL machbar für eine Tabelle

NON CL IX ist besonders gut bei wenigen Ergebnissen
--je mehr desto schlechter

Was ist wenig? 
Faktisch kann das auch unter 1 % sein.. aber auch 90%

typische Spalten : ID PK
schlechte Spalten : Religion Geschlecht



CL IX = Tabelle in sortierter Form
logischerweise nur 1mal pro Tabelle


*/
select * into Ku2 from KundeUmsatz

alter table ku2 add id int identity

set statistics io, time on

--bisher kein IX
--TABLE SCAN
select id from ku2 where id = 100 --56217-- 180ms 50ms


--NIX_ID
select id from ku2 where id = 100  --3 Seiten 0 ms


--IX SEEK mit Lookup.. ab ca 10800 wird Tabele Scan eingesetzte unter 1 %
select id, freight from ku2 where id < 10900  

select id from ku2 where id < 800000 --ohne Nachschlagen auch mit 900000 ohne Looku mit IX SEEK


--wir wollen nicht anrufen-- idee Lookup vermeiden , indem wir die INfo in IX mitreinnehmen

--zusammengesetzter IX
--NIX_ID_FR
select id, freight from ku2 where id <100 -- statt 104 nur 3 Seiten
--alles wurde besser....
select id, freight from ku2 where id < 10900  

--immer dann , wenn eine (SELECT) Spalten im IX  nicht enthalten ist, 
--dann Lookup..
--Idee: alle Spalten rein.. 
--blöde Idee:  zusammengestezter IX kann nur 16 Spalten haben oder 900byte
--es gibt eh was besseres
select id, freight, city from ku2 where id < 10900  


--IX mit eingeschlossenen Spalten
select id, freight, city from ku2 where id < 10900  
--where: ID   --> Schlüsselspalten
--SELECT: id, freight, city  --einescghlossenen Spalten


--IX mit eingeschl Spalten kann ca 1000 Spalten haben

select country, city, sum(unitprice*quantity)
from ku2
where freight < 100 or EmployeeID = 2
group by country , city


--NIX

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20220114-103541] ON [dbo].[Ku2]
(	[Freight] ASC
)INCLUDE([City],[Country],[UnitPrice],[Quantity]) 
GO

CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[Ku2] ([Freight])
INCLUDE ([City],[Country],[UnitPrice],[Quantity])


USE [Northwind]

GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20220114-103819] ON [dbo].[Ku2]
(
	[Freight] ASC,
	[EmployeeID] ASC
)
INCLUDE([City],[Country],[UnitPrice],[Quantity])


CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[Ku2] ([EmployeeID],[Freight]) --Alphabetisch
INCLUDE ([City],[Country],[UnitPrice],[Quantity])
GO

GO




--CL IX: immer zuerst überlegen ... beim Anlegen der Tabelle
--CL IX ist gut bei Bereichsabfrage

--Tabelle Best

select * from best --CL IX SCAN.. woher kommt der CL IX?
--vom PK


select * from orders
insert into customers (customerid, CompanyName) values ('ppedv', 'Fa ppedv')



select country, count(*) from ku2
group by country

create view vdemo
as
select country, count(*) as Anzahl from ku2
group by country


select * from vdemo

--aber .. geht fast nie. count_big ist Pflicht, schemabing, eindeutige Zeilen. und und und




create or alter view vdemo with schemabinding --man muss sehr genau arbeiten
as
select country, count_big(*) as Anzahl from dbo.ku2
group by country



select * into ku3 from ku2

select top 3 * from ku3
--Aggregate where

--Summe Preis  pro Land, die wo freight < 1


--NIX:  NIX_FR_i_CYUP
select country, sum(unitprice) from ku2 where freight <1 group by country;
GO
CREATE NONCLUSTERED INDEX [NIXXY]
ON [dbo].[Ku2] ([Freight])
INCLUDE ([Country],[UnitPrice])
GO


select country, sum(unitprice) from ku3 where freight <1 group by country;
GO


select country, sum(unitprice) from ku3 where customerid = 'ALFKI' group by country;


--statt 550MB nur 4,3 MB

--a) stimmt b ) stimmt nicht

--es ist a)... dann kann es nur Kompression sein

--nochmal komprimiert -- 3 MB

--Auch im RAM

