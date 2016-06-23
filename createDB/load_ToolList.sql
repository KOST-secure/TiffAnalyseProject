-- SQLITE System Settings
.header on
.mode column

/* Tabellenstruktur f�r Tabelle analysetool ------------------------------------
	toolname 	Name des registrierten Analyseprogramms in Kurzform
	prgfile 	Pfad und Dateiname zum Analyseprogramms
	prgparam 	Parameter des Analyseprogramms mit Wildcards %file% und %log%
	tmplog 		Tempor�re Logdatei: ersetzt Wildcards  %log% beim Ausf�hren des Analyseprogramms, Fehlen meint keine Log Datei schreiben
	logfile 	Pfad und Dateiname der mit diesem Analyseprogramms verbunden Logdatei: Ist kein Logfile definiert wird in LOB "logout" gespeichert
	sysfile 	Pfad und Dateiname der mit diesem Analyseprogramms verbunden Ausgabedatei: Ist kein Sysfile definiert wird in LOB "sysout" gespeichert
*/

-- Testsettings f�r Logrotation
-- INSERT INTO logrotate (logcounter, maxexecute) VALUES (1, 100000);

DELETE FROM analysetool;

INSERT INTO analysetool (toolname,prgfile,prgparam,tmplog,logfile,sysfile) VALUES (
	'file',
	'/usr/bin/file',
	'-b -i %file%',
	'',
	'',
	'log/file_sys'
);

SELECT * FROM analysetool;
