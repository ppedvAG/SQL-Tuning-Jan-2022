--Sperren

--Sperrnieau: Zeile (IX), Seite (IX),Block(IX), Partition, Tabelle, DB
--es wird Schritt für Schritt gesperrt

select * into kunden from customers


begin tran
select @@TRANCOUNT
update kunden set city = 'Paris' where customerid = 'ALFKI'
update orders
update Employees


commit
rollback
