--DB Design

/*
Prim�rschl�ssel  --  Beziehung--   Fremdschl�ssel
Normalform 1.NF 2.NF 3.NF...
1NF 
in keiner Zelle d�rfen mehr als ein Wert enthalten sein.. atomar--gut f�r Indizes

2NF .
hast du einen Prim�rschl�ssel (DS eindeutig)..

3 NF
ausserhalb des Prim�rschl�ssel d�rfen keine Wechselbeziehungen mehr vorhanden sein

Normalisierug versucht Redundanz vermeiden, aber ist langsam
Redundanz aber ist schnell

#temp Tabellen sind redundante Daten


SHOP

Kunden 1MIO
KdId				INT
FamName		nvarchar(50)
VorName		nvarchar(50)  OTTO  4 * 2
GebDatum		date
PLZ					char(5)
Ort					nvarchar(50)
Strasse			nvarchar(50)
Land				nvarchar(50)




Produkte
PrId
Bezeichnung
Preis				money od decimal(5,2)


Bestellung  2 MIO
BId
KdId
Lieferkosten
Bdatum		date
RngSumme 100  Trigger ..ist aber langsam.. 
--per SP Bi Logik und direkten Zugriff auf Tabelle Details verbietet


BestDetails 4MIO 
BDId
Bid
PrId
Menge  10---15
Preis








Das Argument, dass nvarchar oder datetime kaum was ausmacht, die paar bytes mehr oder weniger ist doch egal..
die HDD ist gro� genug

--!!!!!!! DIE DATEN WERDEN 1:1 VON DER HDD IN RAM GELADEN  !!!

--weniger auf der HDD-- desto weniger CPU --> desto geringer RAM Verbrauch





*/

select * from customers

create table t1(
								id int identity
							,	spx char(4100)
							)

insert into t1
select 'XY'
GO 20000

--Wie gro� sollte die Tabelle sein? --> 20000 mal 4 kb ==> 80MB.. hat aber 160MB !! ??




--Das Elend der DAtentypen: datetime

select * from orders where year(orderdate) =1997 --408

select * from orders where orderdate between '1.1.1997' and '31.12.1997 23:59:59.999'

datetime ist ungenau auf ca 2 bis  3 ms
