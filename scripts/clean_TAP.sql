
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
-- DROP TABLE IF EXISTS namefile;
-- DROP TABLE IF EXISTS analysetool;

-- Tabellenstruktur f�r Tabelle logrotate --------------------------------------
CREATE TABLE logrotate (
	logcounter INTEGER DEFAULT 0 NOT NULL,	-- Z�hler f�r Logratation "logfile" bzw. "sysfile" 
	maxexecute INTEGER DEFAULT 10000,	-- Maximal Verarbeitungsschritte pro "logfile" bzw. "sysfile"
	PRIMARY KEY (logcounter)
);

-- Tabellenstruktur f�r Tabelle keyfile ----------------------------------------
CREATE TABLE keyfile (
	md5 VARCHAR(32),			-- MD5 Hashwert
	creationtime DATETIME DEFAULT NULL,	-- Entstehungszeitpunkt der Datei laut Dateisystem
	filesize LONG DEFAULT NULL,		-- Dateigr�sse in Byte
	pdate DATETIME DEFAULT NULL,		-- Zeitpunkt f�r den Abschluss der Analyse
	logcounter INTEGER DEFAULT 1,		-- Z�hler f�r "logfile" bzw. "sysfile" Logrotation beginnend mit 1
	mimetype VARCHAR(255) DEFAULT NULL,	-- Internet Media Type, auch MIME-Type aufgrund der Magic Number
	PRIMARY KEY (md5),
	FOREIGN KEY(md5) REFERENCES md5(namefile)
	FOREIGN KEY(logcounter) REFERENCES logrotate(logcounter)
);

-- Tabellenstruktur f�r Tabelle status -----------------------------------------
CREATE TABLE status (
	md5 VARCHAR(32) NOT NULL,		-- MD5 Schl�ssel der TIFF Datei
	toolname VARCHAR(30) NOT NULL,		-- Name des registrierten Analyseprogramms in Kurzform
	retval VARCHAR(255) DEFAULT NULL,	-- R�ckgabe Wert des Tools (Exit Status 0 = erfolgreicher Abschluss)  http://www.hiteksoftware.com/knowledge/articles/049.htm
	PRIMARY KEY (md5, toolname),
	FOREIGN KEY(md5) REFERENCES keyfile(md5),
	FOREIGN KEY(toolname) REFERENCES analysetool(toolname)
);

-- Tabellenstruktur f�r Tabelle logindex ---------------------------------------
CREATE TABLE logindex (
	md5 VARCHAR(32) NOT NULL,		-- MD5 Schl�ssel der TIFF Datei
	toolname VARCHAR(30) NOT NULL,		-- Kurzname des Tools
	logoffset INTEGER DEFAULT 0,		-- Offset in die Ausgabedatei analysetool.logfile
	loglen INTEGER DEFAULT 0,		-- L�nge des Logausgabe
	logout BLOB,				-- vollst�ndige LOG Ausgabe des Analysetools
	PRIMARY KEY (md5, toolname),
	FOREIGN KEY(md5) REFERENCES keyfile(md5),
	FOREIGN KEY(toolname) REFERENCES analysetool(toolname)
);

-- Tabellenstruktur f�r Tabelle sysindex ---------------------------------------
CREATE TABLE sysindex (
	md5 VARCHAR(32) NOT NULL,		-- MD5 Schl�ssel der TIFF Datei
	toolname VARCHAR(30) NOT NULL,		-- Kurzname des Tools
	sysoffset INTEGER DEFAULT 0,		-- Offset in die Ausgabedatei analysetool.sysfile
	syslen INTEGER DEFAULT 0,		-- L�nge des Konsolenausgabe
	sysout BLOB ,				-- vollst�ndige SystemOut Ausgabe des Analysetools: stderr & stdout
	PRIMARY KEY (md5, toolname),
	FOREIGN KEY(md5) REFERENCES keyfile(md5),
	FOREIGN KEY(toolname) REFERENCES analysetool(toolname)
);
