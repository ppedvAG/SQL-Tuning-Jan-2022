select * from kundeumsatz

--Umsatz pro Kunde

select companyname , sum(unitprice*quantity) from kundeumsatz
group by companyname

--gelbes ICON mit 2 Pfeilen-- > bedeutet Einsatz von mehr Kernen / Prozessoren

set statistics io, time on

--, CPU-Zeit = 484 ms, verstrichene Zeit = 81 ms.
--Mehr CPU Zeit als Dauer

--hat sich gelohnt.. 
--machen mehr CPUs für Abfragen Sinn?

--also : je mehr Kerne für eine ABfragen desto besser
--je mehr Prozessoren, desto größer der Verwaltungsaufwand

select companyname , sum(unitprice*quantity) from kundeumsatz
group by companyname option (maxdop 1)

-- CPU-Zeit = 297 ms, verstrichene Zeit = 286 ms.

--mit 6 Kernen gleich schnell aber weniger CPU Aufwand
select companyname , sum(unitprice*quantity) from kundeumsatz
group by companyname option (maxdop 6)

--Kostenschwellert: 5 sehr sehr klein
--Max Grad der Paral...: 0


select * from kundeumsatz where customerid like '%KI'

---Der Kostenschwellwert muss deutlich nach oben..
-- 25  ... 50

--Der SQL Server verwendet entweder 1 Prozessor oder alle!
--Allerdings : ist in Max grad der Paral. ein Wert eingestellt (nicht 0) ,dann wird dieser Wert verwendet)

--wenn eine Abfarge mehr als Kostenschwellwert geschätzt wird, dann gilt : mwehr Prozessoren

--wenn also die Kosten > 5 , dann merh Prozessoren


--das passiert auf dem Server... gilt für alle Abfragen auf jeder DB

