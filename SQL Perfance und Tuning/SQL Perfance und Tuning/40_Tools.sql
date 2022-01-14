/*
QueryStore ab SQL 2016..

speichert Pläne und Abfragestatistiken auf Dauer (man kann Limits setzen)
hat Berichte um teuerste Abfragen zu finden
kann für Tuning Advisor als Worklodbasis verwendet werden
kann auch per TSQL abgefragt werden
pro DB aktivierbar.. mehr ist nicht zu tun


Profiler
vorsicht .. teuer in Anwendung
speichert wie QueryStore Anweisung... unbedingt filtern
kann für Tuning Advisor als Worklodbasis verwendet werden


DatabaseTuning Advisor
kann Indizes vorschlagen, aber auch Löschen empfehlen
auch Statistik Vorschläge
erzeugt _dta_indizes (hypothetische) .. wird der DTA ebgeschosse , dann bleiben diese unsichtbar in der Tabelle hängen
super für Mengenanalyse


SentryOne Plan Explorer
Gratis Tool für Pläne.. cool

Brent Ozar (Reihe von Scripten)
sp_blitzIndex







.-




*/