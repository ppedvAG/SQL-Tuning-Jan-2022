--Seiten und Bl�cke


/*
SQL Server speichert DS in Seiten

1 Seiten hat immer 8192bytes
1 Seite kann max 700 DS enthalten
1 DS ist beschr�nkt auf 8060 bytes bei fixen L�ngen/Datentypen
--Error Dies �berschreitet die maximal zul�ssige Gr��e f�r Tabellenzeilen von 8060 Bytes.
1 Seite hat aber auc nur 8072 bytes Nutzlast
Seiten habe auch Seitzahlen (Seite 104)
1 DS muss mit seinen fixen L�ngen in die Seite passen
nicht genutzer Platz wird trotzdem in RAM geladen , weil Seiten 1:1 in RAM kommen
8 Seiten am St�ck = Block

Seiten kommen immer 1:1 von HDD in RAM

Seite = Page    Block = Extent



in unserem Bsp:

1DS 4100bytes plus 4 bytes  etwas mehr als die H�lft einer Seite

20000 * 8kb--> 160MB

---ZIEL: weniger Seiten desto besser

--Gibts denn eine M�glichekeit Verschwendung zu finden

*/

create table t2 (id int, sp1 char(4100), sp2 char(4100))

dbcc showcontig('t1')
--- Gescannte Seiten.............................: 20000
--- Mittlere Seitendichte (voll).....................: 50.79%

---Seiten sollten m�glichst voll sein!


--Messung pro Abfrage

set statistics io, time on --nur bei Bedarf
select * from t1
--logische Lesevorg�nge: 20000, = Seiten
--, CPU-Zeit = 250 ms, verstrichene Zeit = 1894 ms.

select * from t1 where id = 100 --..auch wenn es schnell geht.. 160MB im Speicher  Indzes

--im Plan: Table SCAN

--SCAN ist immer ein komplettes Durchsuchen
--SEEK w�re idealer: herauspicken eines Datensatzes

set statistics io, time off



--Wenn wir weniger Seiten lesen m�ssen , sollte der Code besser sein...



