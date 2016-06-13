TiffAnalyseProject
--------------------
TIFF ist zurzeit eine offene Spezifikation von Adobe, jedoch kein ISO-Standard. Das Ziel des Vorhabens ist, die theoretisch getroffenen Überlegungen, die zu einer erweiterten TIFF Baseline ISO Recommendation führen sollten, auf eine fundierte Analyse  echter archivischer Daten zu stützen.

#### Skript installieren  

Vorbedingung: sqlite www.sqlite.org und alle Analyseprogramme sind installiert.   
Folgende Schritte müssen ausgeführt werden:  

1. Script Package in einem Ordner mit entsprechenden Rechten (create/execute) installieren.  

2. In Script load_ToolList.sql die entsprechenden Analyseprogramme und Log Dateien eintragen (siehe Beispiele load_ToolList.sql)  

3. Mit Script create_TAP.bat eine neue Datenbank anlegen   
   usage: create_TAP.bat path/dbname.db
 
4. Mit inloop.exe alle Dateien einlesen und in die Datenbank schreiben.  
   inloop.exe kann mit mehreren Startordnern mehrfach aufgerufen werden  
   usage: iniloop.exe folder database  

5. Mit runloop.exe die Verarbeitung starten  
   usage: runloop.exe [options] database  

runloop.exe kann mit Ctrl-C unterbrochen oder beendet werden.  

Es empfiehlt sich, zu Beginn runloop.exe nach kurzer Zeit abzubrechen und zu kontrollieren, ob alle aufgerufenen Analysetools in gewünschter Art und Weise arbeiten und die entsprechenden LOG Dateien geschrieben werden. Die entstandenen Testergebnisse können mit clean_TAP.bat wieder aus der Datenbank entfernt werden, ohne dass die bereits gelesenen Dateiinformationen verloren gehen. Achtung, LOG Dateien müssen manuell gelöscht werden.  

Zwischendurch, wenn auch nicht gleichzeitig, ist es auch möglich mit iniloop.exe weiter Dateien in die Datenbank einzufügen.  
