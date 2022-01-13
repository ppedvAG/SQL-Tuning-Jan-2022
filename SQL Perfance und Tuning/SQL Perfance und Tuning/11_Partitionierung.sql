--Partitionierung


.---1. Funktion für die Einteilung der Bereiche

-------------100]-----------------------------200]----------------------------------- int

--    1										2														3

--f(117) ==>2

create partition function fzahl(int)
as
RANGE LEFT FOR VALUES (100,200)

select $partition.fzahl(117) ---2

---2. Dateigruppen

--4 Dateigruppen : bis100  bis200  bis5000  rest

ALTER DATABASE [Northwind] ADD FILEGROUP [bis100]
ALTER DATABASE [Northwind] ADD FILE ( NAME = N'nwbis100', FILENAME = N'D:\_SQLDB\nwbis100.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB ) TO FILEGROUP [bis100]
ALTER DATABASE [Northwind] ADD FILEGROUP [bis200]
ALTER DATABASE [Northwind] ADD FILE ( NAME = N'nwbis200', FILENAME = N'D:\_SQLDB\nwbis200.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB ) TO FILEGROUP [bis200]
ALTER DATABASE [Northwind] ADD FILEGROUP [bis5000]
ALTER DATABASE [Northwind] ADD FILE ( NAME = N'nwbis5000', FILENAME = N'D:\_SQLDB\nwbis5000.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB ) TO FILEGROUP [bis5000]
ALTER DATABASE [Northwind] ADD FILEGROUP [rest]
ALTER DATABASE [Northwind] ADD FILE ( NAME = N'nwrest', FILENAME = N'D:\_SQLDB\nwrest.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB ) TO FILEGROUP [rest]



--3 Part Schema

create partition scheme schzahl
as
partition fzahl to (bis100,bis200,rest)
-----                          1          2           3

--Tabelle auf Schema legen uns ASpalte für verteilung definieren
create table parttab (id int identity, nummer int, spx char(4100)) on schZahl(nummer)



declare  @i as int = 1

begin tran
while @i <= 20000
	begin
		insert into parttab (nummer, spx) values (@i, 'XY')
		set @i+=1
		end
commit



set statistics io, time on

select * from parttab where nummer = 100 --Seiten: 100.. 0ms

select * from parttab where ID= 100 --Seiten: 20000  messbar ms 30ms

select * from parttab where nummer = 1117 ---19800 Seiten

--es passiert doch rel häufig: Abfragen auf 200 bis 5000


--neue Grenze 5000

-------------100]---------------200]----------------------------5000]---------------------------


--sobal wir die Verteilung anpassen per f().. werden die DAten auch sofort verschoben

--Tabelle, f(), scheme, Dateigruppen
--neue Dateigruppe
-
--schema anpassen
--f() anpassen

-- Tabelle: never
--zuerst das Schema
alter partition scheme schZahl next used bis5000


select $partition.fzahl(id), min(id), max(id),  count(*)
from parttab
group by $partition.fzahl(id) order by 1

--noch alles unverändert
--------100------200--------------------------5000------------------

alter partition function fzahl() split range (5000)


select * from parttab where nummer = 1117 ---statt 19800 Seiten nur noch 4800 Seiten .. knapp 5 ms statt 15

--naja.. irgendwann möchte man auch Grenzen entfernen

--Grenze 100 muss weg..
--Tabelle scheme f()  Dateigruppen
--Tabelle: never
--Dateigruppen egal, wenn man eine Grenze entfernt
--F()... muss man ändern
--schema: keine Änderung notwendig
-----x100x----200-------5000----------

alter partition function fzahl() merge range (100)
--aber wo sind die DAten tats.. bzw welche Dateigruppe verwendet man gerade


CREATE PARTITION FUNCTION [fzahl](int) AS RANGE LEFT FOR VALUES (200, 5000)
GO
CREATE PARTITION SCHEME [schzahl] AS PARTITION [fzahl] TO ([bis200], [bis5000], [rest])
GO

--Archivierung von Daten
--Tabelle Archiv muss auf der DGruppe liegen, die wir anschl switchen wollen
create table archiv (id int not null, nummer int, spx char(4100)) on rest

alter table parttab switch partition 3 to archiv

select * from archiv --alle über 5000

select * from parttab --keine über 5000


--100MB/sek 
--1000MB verschieben mit archivfunktion--sollte 10 sekunden-- dauert aber nur wenige ms

select * from parttab where id = 10


--DATUM
--Jahresweise  2021   2022  2023

create partition function fzahl(datetime)
as
RANGE LEFT FOR VALUES ('31.12.2021 23:59:59.999','',''...)


--- A bis M   N bis S    T bis Z
create partition function fzahl(varchar(50))
as
RANGE LEFT FOR VALUES ('MZZZZZZZZZZ','')

--------------------M]Maier---------------------------------------S}



--geht das ? und macht das Sinn?.. jaaaaahh
create partition scheme schzahl
as
partition fzahl to ([PRIMARY],[PRIMARY],[PRIMARY])



