--A und B sind identisch
--Tabelle A   10000
--Tabelle B    100000

--Abfrage-- immer 10 Zeilen 
--Auf A schneller sein als auf B


--Salamitaktik
--

--Tabelle Umsatz wird grüßer und größer

--Idee: U2022 U2021 U2020 U2019  Umsatz wurde  gelöscht

select * from umsatz where...--muss wieder gehen?



--PARRITIONIERTE SICHT

create table u2022 (id int identity, jahr int, spx int)
create table u2021 (id int identity, jahr int, spx int)
create table u2020 (id int identity, jahr int, spx int)
create table u2019 (id int identity, jahr int, spx int)

create view Umsatz
as
select *  from u2022
UNION ALL -- keine Suche nach doppelten
select * from u2021
UNION ALL
select * from u2020
UNION ALL
select * from u2019


--Schneller: Plan

select * from umsatz
select * from umsatz where jahr = 2021
select * from umsatz where id = 2021


--bisher kein Verbesserung

--aber mit Check Constraints wirds besser

ALTER TABLE dbo.u2019 ADD CONSTRAINT
	CK_u2019 CHECK (jahr=2019)

	ALTER TABLE dbo.u2020 ADD CONSTRAINT
	CK_u2020 CHECK (jahr=2020)

	ALTER TABLE dbo.u2021 ADD CONSTRAINT
	CK_u2021 CHECK (jahr=2021)

	ALTER TABLE dbo.u2022 ADD CONSTRAINT
	CK_u2022 CHECK (jahr=2022)

select * from umsatz
select * from umsatz where jahr = 2021
select * from umsatz where id = 2021


--Am besten nur für Archive verwenden ... bzw Daten die nich tmehr geändert!


--Sichten : SELECT  .....
--INS UP DEL.. aber das geht nur wenn Pflichtfelder beachtet oder wenn Join enthalten


insert into umsatz (jahr, spx) values (2020,100)
--Primärschlüssel für die [Northwind].[dbo].[u2022] Fehler
--PK muss eindeutig über die Sicht sein


-- da die [Northwind].[dbo].[u2022]-Tabelle eine IDENTITY-Einschränkung aufweist.

insert into umsatz (jahr, spx) values (2020,100)--error

insert into umsatz (id,jahr, spx) values (1,2020,100)--jetzt gehts.. aber das Ding ist eigtl unrbauchbar

--Anwendungsfall: Archivtabellen

--ekelhaft und kompliziert



--Partitionierung


--VorausstzungDateigruppe

ALTER DATABASE [Northwind] ADD FILEGROUP [HOT]
GO
ALTER DATABASE [Northwind] ADD FILE ( NAME = N'nwindHotData', FILENAME = N'D:\_SQLDB\nwindHotData.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB ) TO FILEGROUP [HOT]
GO


create table t3 (id int) on HOT






