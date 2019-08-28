Microservices provide functionality via APIs. APIs purely express what systems do, and are therefore highly valuable business assets. Designing high-quality, long-lasting APIs has become. Our strategy emphasizes developing lots of internal and also public APIs for our external business partners.

With this in mind, we’ve defined "API Principles" with the following key statements:

1. Every Team / Application publishes it's main capabilities over an API with a high [maturity](maturity/maturity.md)
2. APIs can be [synchronous](synchronousdesign/synchronousdesign.md) or [asynchronous](asynchronousdesign/asynchronousdesign.md)
3. All of these APIs must fulfill the principles described on this site

Architekturprinzipien der SBB
=============================

## Gestaltungsprinzipien mit Bezug zu Schnittstellen
[Interner Link auf die Gestaltungsprinzipien](https://sbb.sharepoint.com/teams/384/EA-eSpace/02_Querschnitt/06_Architekturprinzipien/GEP_Gestaltungsprinzip.pdf)

### Architektur und Teamschnitt bilden eine Einheit
Architektur und der Schnitt der Entwicklungsteams bilden eine Einheit. Wo Anwendungen von mehr als einem Team entwickelt werden, folgt der
Schnitt unserer Anwendungen dem Schnitt der Entwicklungsteams (und umgekehrt). Das Entwicklungsteam steht dabei im Zentrum unserer
Überlegungen ... Teamübergreifende Schnittstellen betrachten wir immer wie anwendungsübergreifende Schnittstellen.

### Wir bauen tolerante Schnittstellen
Wir gestalten unsere Abhängigkeit von Schnittstellen so gering wie möglich und wir vermeiden strikte Abhängigkeiten auf Schnittstellenversionen,
um eine über das fachlich unvermeidbare hinausgehende Kopplung von Releases zu verhindern.

Wir gestalten Veränderungen von Schnittstellen so lange wie möglich ab- und aufwärtskompatibel. Wir erwarten und prüfen nur Dinge, die
wirklich notwendig sind. Soweit möglich verarbeiten wir auch fehlerhafte Anfragen und Antworten. Unsere Schnittstellen verhalten sich robust bei
sich verändernden Latenzen und Ausfällen von Umsystemen.

### Wir bauen unsere Anwendungen aus Services mit einer definierten Aufgabe
... Jeder Service hält seine eigenen Daten und hat nur Zugriff auf seine eigenen Datenspeicher und die Schnittstellen anderer Services. Es
existieren keine Anwendungs/Service übergreifende Datenspeicher (Datenbanken) ...

## Bereitstellungsprinzip mit Bezug zu Schnittstellen
[Interner Link auf die Bereitstellungsprinzipien](https://sbb.sharepoint.com/teams/384/EA-eSpace/02_Querschnitt/06_Architekturprinzipien/BEP_Bereitstellungsprinzip.pdf)
... Falls ein Geschäftsbedarf mit einer bestehenden Anwendung abgedeckt werden kann, verwenden wir diese wieder (Reuse) ...

## Daten- und Integrationsprinzipien mit Bezug zu Schnittstellen
[Interner Link auf die Daten- und Integrationsprinzipien](https://sbb.sharepoint.com/teams/384/EA-eSpace/02_Querschnitt/06_Architekturprinzipien/DIP%20Daten-%20und%20Integrationsprinzip.pdf)

### Wir teilen und nutzen die Daten der SBB über definierte und zweckmässige Schnittstellen
Definiert und zweckmässig bedeutet: Schnittstellen sind abnehmerorientiert und leicht zu verwenden (z.B. dokumentiert, versioniert, Verrechnung geklärt). Wir bauen Schnittstellen robust und soweit als möglich fehlertolerant.

Wir machen unsere Schnittstellen offen zugänglich und dokumentieren sie offen zugänglich. Unsere Schnittstellen sind im Konzern grundsätzlich frei verfügbar, sofern sich dies mit den Schutzbedürfnissen der Daten vereinbaren lässt.

Das Integrationsverfahren (z.B. synchron, asynchron, Datenreplikation) leitet sich aus den funktionalen und nicht funktionalen
Anforderungen ab. Wir beachten dabei die Best Practices unserer Integrationsarchitektur (siehe dazu "Das Integrationsverfahren
der SBB").

Es werden nur die notwendigen Daten übertragen: z.B. Anzahl Sätze, Anzahl Attribute.

Wir legen einen Datenmaster pro Geschäftsdatentyp fest. Wo es für einen Geschäftsdatentypen schon einen Datenmaster gibt, verwenden wir die Daten als Slave. Das heisst wir verändern resp. ergänzen die Daten direkt beim Datenmaster und verändern resp. ergänzen die bezogenen Daten nicht. Daten, die wir von einem Datenmaster beziehen geben wir nicht an andere Anwendungen weiter. Wir dokumentieren den Datenmaster pro Geschäftsdatentyp in der EA-DB.

Bei mangelnder Datenqualität verbessern wir die Daten an der Quelle zusammen mit dem Datenowner. Dies gilt beispielsweise auch für die Ergänzung (und Erfassung) zusätzlicher Attribute oder der technischen Verbesserung der Schnittstelle.

Wir gehen mit Daten sorgfältig um. Bei der Bereitstellung und Nutzung der Daten beachten wir deren Schutzbedarf (z.B.
Datenschutzregeln).

### Wo vorhanden, nutzen wir die Basisservices der SBB
Bevor wir eine neue Schnittstelle bauen, prüfen wir ob es für die Nutzung der benötigten Daten einen Basisservice gibt. Ist ein Basisservice verfügbar, nutzen wir diesen.

Wir führen die verfügbaren Basisservices (z.B. Kundenfahrplan) im SBB Service Repository und halten diese Dokumentation
aktuell.

### Wir führen Datenredundanzen nur aufgrund besonderer Anforderungen ein.
Die Anforderungen für die Einführung von Datenredundanz sind: hohe Verfügbarkeit eines Gesamtsystems, Performance eines Gesamtsystems oder die Integration einer Anwendung, das keine passenden Online-Zugriffe erlaubt (z.B. Legacy, Batchsysteme, Standardsoftware).

Nur wenn sich die Anforderungen nicht anders realisieren lassen führen wir kontrollierte Redundanzen ein. Vorher prüfen wir, ob teilweise reduzierte (nichtfunktionale) Anforderungen für das Geschäft tragbar sind (z.B. bei einem Ausfall eines Umsystems läuft unsere Anwendung eingeschränkt weiter). Wir prüfen vorher auch technische Massnahmen wie z.B. ein Caching (nicht persistent) von Daten oder asynchroner Datenbezug.

Falls wir eine Datenredundanz einführen, managen wir diese: Der Abgleich der Datenkopien wird technisch und nicht organisatorisch durchgeführt. Damit stellen wir sicher dass
er effizient erfolgt und langfristig gewährleistet werden kann. Dabei ist sicherzustellen, dass Datenkopien eine definierte, auf die Anforderungen ausgerichtete Aktualität (bzw. Gültigkeit) aufweisen.
Wir beziehen Daten an der Quelle und geben diese nicht weiter an andere Anwendungen. Wir ändern von uns redundant gehaltene Daten an der Quelle.

Conventions Used in These Guidelines
====================================

### Requirement level
The requirement level keywords "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" used in this document (case insensitive) are to be interpreted as described in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

### API Consumer vs. Provider
*Consumer* is used as a synonym for API Consumers (also known as clients of an API) and is referring the team which implements the client. On the other hand, we use *Provider* as a synonym for *API Provider*, referring the team maintaining the API.
