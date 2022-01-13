--Tabelle t1 hat 20000 Seiten

--Ziel.. weniger Seiten lesen

--aber bei jeden SCAN.. 20000 Seiten

select * from t1 where sp1 like '%X%' --wird immer ein SCAN sein

--Wenn schon SCAN, dann weniger Seiten

--Ohne Code anzupassen oder mit Code anpassen

--mit Code anpassen Lösung
--statt char(4100) .. sp1 als varchar(4100)  !

--CRM.. Tabelle Kunden hatte ca 300 Spalten
--Kunden 100 Sp und KundenSonstiges 200


/*
1 MIO DS a 4100bytes    
1DS = 1 Seiten
1 MIO * 8kb ==> 8 GB ----> auf HDD und RAM


1 MIO 4000 + 1 MIO mit 100
pro Seite 2 DS -- 500000 Seiten ... 4 GB
pro Seite 80DS -- 12500 Seiten -- 110 MB

statt 8 GB HDD  RAM      4,1 GB HDD und Ram

*/


--OHNE CODE

--Tabelle komprimieren
-- Zeilenkompression 
--Leerstellen am Ende werden entfernt.. und die kleineren Zeilen in weniger Seiten zusammenfassen
--Seitenkompression  
--zuerst Zeilenkomression
--Präfixkompression


-- Fall t1:  20000 DS  mit 160MB   20000 Seiten


*/

select * into t2 from t1-- geht schnell weil ein Bacth bzw 1 TX

USE [Northwind]
ALTER TABLE [dbo].[t1] REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = PAGE
)

--vor Kompression
--20000 Seiten 
--250ms CPU
--1800 ms Dauer
-- RAM 160MB

--nach Kompression
--Seiten weniger 
--CPU mehr
--Dauer: kann mehr oder weniger 
--RAM: weniger 

--client bekommt das Zeug immer so, als wäre es nie komprimiert worden!!

set statistics io, time on
select * from t1

--CPU sogar gleich geblieben.. weniger CPU für IO Zgriff, dafür mehr für Dekompression

--Kompression macht man für andere Daten/Tabellen

--ich würde mit ca 40% bis 60% Kompression rechnen

--Ideal für Archivtabelle oder Tabellen , die eher seltener abgefragt werden