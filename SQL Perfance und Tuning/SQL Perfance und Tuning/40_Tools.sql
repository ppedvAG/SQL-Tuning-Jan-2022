/*
QueryStore ab SQL 2016..

speichert Pl�ne und Abfragestatistiken auf Dauer (man kann Limits setzen)
hat Berichte um teuerste Abfragen zu finden
kann f�r Tuning Advisor als Worklodbasis verwendet werden
kann auch per TSQL abgefragt werden
pro DB aktivierbar.. mehr ist nicht zu tun


Profiler
vorsicht .. teuer in Anwendung
speichert wie QueryStore Anweisung... unbedingt filtern
kann f�r Tuning Advisor als Worklodbasis verwendet werden


DatabaseTuning Advisor
kann Indizes vorschlagen, aber auch L�schen empfehlen
auch Statistik Vorschl�ge
erzeugt _dta_indizes (hypothetische) .. wird der DTA ebgeschosse , dann bleiben diese unsichtbar in der Tabelle h�ngen
super f�r Mengenanalyse


SentryOne Plan Explorer
Gratis Tool f�r Pl�ne.. cool

Brent Ozar (Reihe von Scripten)
sp_blitzIndex







.-




*/