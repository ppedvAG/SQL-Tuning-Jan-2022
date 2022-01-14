--Sperren

/*
Standardm��ig wird mit READ COMMITTED gearbeitet:
Lesen nach Commit oder Rollback

man kann allerdings das �ndern:
set transaction isolation level read uncommitted
--> trotzdem lesen ,aber den "akt" Wert


--Jedes UP INS DEL ..auch SEL setzt Sperren
--allerings wird die Sperre in TX so lange aufrecht erhalten bsi die TX zu Ende ist..

begin tran -- schrittweise
select @@TRANCOUNT --1 l�uft...
select * from kx where customerid = 'ALFKI'
update kx set city = 'Berlin' where customerid = 'ALFKI'
select * from kx where customerid = 'ALFKI'

rollback

Das Sperrniveau kann sich auf folgende Niveaus bewegen:

ROW, PAGE, EXTENT, PARTITION, TABLE, DATABASE

je mehr betroffen ist, desto h�her wird das Sperrniveau angesetzt.
also auch mehr gesperrt als notwendig!


Nur den richtigen Indizes kann das Sperrniveau gesenkt werden. Ohne Indizes
kann das Sperrniveau nur Tabelle oder evtl Partition sein


*/


-- Um Sperren zu vermeiden k�nnte man Zeilenversionierung aktivieren
--Datens�tze die ver�ndert werden, werden vor �nderung als Kopie in 
--die TempDB kopiert und mit einer Versionsnummer versehen
--Alle Lesenden bekommen die letzte Version aus der tempdb
--ein �ndern hindert nicht mehr das Lesen
--ein �ndern hindert aber immer noch das �ndern

ALTER DATABASE [dbatools] SET READ_COMMITTED_SNAPSHOT ON WITH NO_WAIT
GO

GO
ALTER DATABASE [dbatools] SET ALLOW_SNAPSHOT_ISOLATION ON
GO
