
-- mySQL  Settings
-- USE tap;

-- SQLITE System Settings
-- .header on
-- .mode column

-- Foreign key constraints are disabled by default
-- Use the foreign_keys pragma to turn them on
PRAGMA foreign_keys = 1; 

-- Tabellen in der richtigen Reihenfolge l�schen
DROP TABLE IF EXISTS status;
DROP TABLE IF EXISTS logindex;
DROP TABLE IF EXISTS sysindex;
DROP TABLE IF EXISTS keyfile;
DROP TABLE IF EXISTS logrotate;
DROP TABLE IF EXISTS namefile;

DROP TABLE IF EXISTS analysetool;

-- Tabellenstruktur f�r Tabelle analysetool ------------------------------------
CREATE TABLE analysetool (
	toolname VARCHAR(30) NOT NULL,		-- Name des registrierten Analyseprograms in Kurzform
	prgname VARCHAR(255) NOT NULL,		-- Pfad und Dateiname zum Analyseprograms
	logfile VARCHAR(255) DEFAULT NULL,	-- Pfad und Dateiname der mit diesem Analyseprograms verbunden Logdatei: Ist kein Logfile definiert wird in BLOB "logout" gespeichert
	sysfile VARCHAR(255) DEFAULT NULL,	-- Pfad und Dateiname der mit diesem Analyseprograms verbunden Ausgabedatei: Ist kein Sysfile definiert wird in BLOB "sysout" gespeichert
	logconcat BOOLEAN DEFAULT TRUE NOT NULL,-- Ja(1) bedeutet, dass  das Programm die Logdatei fortsetzen kann, Nein(0) es wir jeweils ein neues Log geschreiben und vom LOOP Programm an "logfile" angeh�ngt
	PRIMARY KEY (toolname)
);

-- Tabellenstruktur f�r Tabelle logrotate --------------------------------------
CREATE TABLE logrotate (
	loccounter INTEGER DEFAULT 1 NOT NULL,	-- Z�hler f�r "logfile" bzw. "sysfile" beginnend mit 1
	maxexecute INTEGER DEFAULT NULL,	-- Maximal Verarbeitungsschritte pro "logfile" bzw. "sysfile"
	actexecute INTEGER DEFAULT NULL,	-- Aktueller Verarbeitungsschritt
	PRIMARY KEY (loccounter)
);

-- Tabellenstruktur f�r Tabelle namefile ---------------------------------------
CREATE TABLE namefile (
	id INTEGER NOT NULL,			-- Referenz zu "keyfile"
	serverame VARCHAR(30) DEFAULT NULL,	-- Name des NAS Servers oder des zugeordneten Laufwerkbuchstabens
	filepath VARCHAR(255) DEFAULT NULL,	-- Dateipfad
	filename VARCHAR(255) DEFAULT NULL,	-- Dateiname mit Dateiextension
	PRIMARY KEY (id),
	UNIQUE (filepath, filename)
);

-- Tabellenstruktur f�r Tabelle keyfile ----------------------------------------
CREATE TABLE keyfile (
	id INTEGER NOT NULL,		-- Referenz
	md5 VARCHAR(32) NOT NULL,		-- MD5 Hashwert
	creationtime DATETIME DEFAULT NULL,	-- Entstehungszeitpunkt der Datei laut Dateisystem
	filesize LONG DEFAULT NULL,		-- Dateigr�sse in Byte
	pdate DATETIME DEFAULT NULL,		-- Zeitpunkt f�r den Abschluss der Analyse
	loccounter INTEGER DEFAULT 0,		-- Z�hler f�r "logfile" bzw. "sysfile" Logrotation beginnend mit 1
	PRIMARY KEY (md5),
	FOREIGN KEY(id) REFERENCES namefile(id),
	FOREIGN KEY(loccounter) REFERENCES logrotate(loccounter)
);

-- Tabellenstruktur f�r Tabelle status -----------------------------------------
CREATE TABLE status (
	md5 VARCHAR(32) NOT NULL,		-- MD5 Schl�ssel der TIFF Datei
	toolname VARCHAR(30) NOT NULL,		-- Name des registrierten Analyseprograms in Kurzform
	retval VARCHAR(255) DEFAULT NULL,	-- R�ckgabe Wert des Tools (Exit Status 0 = erfolgreicher Abschluss)  http://www.hiteksoftware.com/knowledge/articles/049.htm
	PRIMARY KEY (md5, toolname),
	FOREIGN KEY(md5) REFERENCES keyfile(md5),
	FOREIGN KEY(toolname) REFERENCES analysetool(toolname)
);

-- Tabellenstruktur f�r Tabelle logindex ---------------------------------------
CREATE TABLE logindex (
	md5 VARCHAR(32) NOT NULL,		-- MD5 Schl�ssel der TIFF Datei
	toolname VARCHAR(30) NOT NULL,		-- Kurzname des Tools
	logoffset INTEGER DEFAULT NULL,		-- Offset in die Ausgabedatei logfile
	logout BLOB,				-- vollst�ndige LOG Ausgabe des Analysetools
	PRIMARY KEY (md5, toolname),
	FOREIGN KEY(md5) REFERENCES keyfile(md5),
	FOREIGN KEY(toolname) REFERENCES analysetool(toolname)
);

-- Tabellenstruktur f�r Tabelle sysindex ---------------------------------------
CREATE TABLE sysindex (
	md5 VARCHAR(32) NOT NULL,		-- MD5 Schl�ssel der TIFF Datei
	toolname VARCHAR(30) NOT NULL,		-- Kurzname des Tools
	sysoffset INTEGER DEFAULT NULL,		-- Offset in die Ausgabedatei "outfile"
	sysout BLOB ,				-- vollst�ndige SystemOut Ausgabe des Analysetools
	PRIMARY KEY (md5, toolname),
	FOREIGN KEY(md5) REFERENCES keyfile(md5),
	FOREIGN KEY(toolname) REFERENCES analysetool(toolname)
);
