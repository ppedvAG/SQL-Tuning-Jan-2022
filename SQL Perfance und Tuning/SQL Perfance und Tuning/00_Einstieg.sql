--Aufgabe:

--1.) lege eine DB mit Namen Test an.. am besten per TSQL

create database testdb

--2.) 
use northwind
select * from customers

--Feld: Customerid: nchar(5)..

select * from customers where customerid = 'ALFKI'

--besser mit Store d Procedure...--Feld: Customerid: nchar(5)..

exec gp_KundenSuche 'ALFKI' -- 1

exec gp_KundenSuche 'A' -- 4

exec gp_KundenSuche  '%'-- Alle. entweder mit % suche oder ohne Angabe des Parameters


create proc gp_kundenSuche @kdid nchar(5)
as
select * from customers where @kdid = '' or Customerid like Concat(@kdid, '%')
select * from customers where customerid like @kdid + '%'


alter proc gp_kundenSuche @kdid nvarchar(5) = '%'
as
select * from customers where @kdid = '' or Customerid like Concat(@kdid, '%')
select * from customers where customerid like @kdid + '%'


--klappt!

--3.)  Suche alle Angestellten, die im Rentenalter sind.. ab 65 oder älter
select * from employees

--Var1:
select * from Employees where DATEDIFF(DD, BirthDate, SYSDATETIME()) > 65 * 365


--Var2.. Mit Variable
declare @GebDatum datetime
select @gebdatum = dateadd(yy,-65, getdate())
select @GebDatum

select * from employees where birthdate < @GebDAtum

--var3
select * from employees where birthdate < dateadd(yy,-65, getdate())




