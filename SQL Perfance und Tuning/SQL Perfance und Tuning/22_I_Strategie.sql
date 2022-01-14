--Überflüssige IX
--Fehlende Indizes
--schlecht performende

select * from sys.dm_db_index_usage_stats

--indexid 0 = HEAP    1=CL IX   >1 NON CL IX


--Statistiken

--Histogramm um zu entscheiden, ob ein IX verwendet wird oder nicht



select * from ku4 where city = 'Berlin' and freight = 10