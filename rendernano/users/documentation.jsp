<%@page import="povwww.*"%>
<%@ page 
 contentType="text/html; charset=ISO-8859-1"
%> 
<%@ taglib uri="/taglibs/nanoTag.tld" prefix="nano" %>
<html>
<head>
	<title>image3d Dokument</title>
	<link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
<h1>image3d Dokumentation</h1> 
<p>
<em> Die vollst&auml;ndige Dokumentation als PDF herunterladen:</em> <a href="image3d-docu.pdf">image3d-docu.pdf</a>
</p>
<p>
Image3d wurde urspr&uuml;nglich als Dienst f&uuml;r in mikroskopischen Bereichen arbeitende 
Wissenschaftler konzipiert. Die Welt der Molek&uuml;le und Atome, die durch spezielle 
Mikroskope eingefangen wird, sollte durch die Berechnung von Reliefbildern intuitiver 
wahrnehmbar und attraktiver werden. Im Zuge der Entwicklung zeigte sich jedoch, dass 
sich diese Methode der Visualisierung auch in einem makroskopischen Bereich nutzen 
l&auml;sst: durch die Anwendung lassen sich sowohl Atom- als auch Berglandschaften 
visualisieren. Mit Image3d l&auml;sst sich mit wenigen Mausklicks aus jedem Bild, 
das H&ouml;heninformationen enth&auml;lt, ein Reliefbild generieren. Image3d l&auml;sst sich 
f&uuml;r jede Gruppierung, die Bedarf an der Visualisierung ihrer (Bild-)Daten hat, 
einsetzen.
</p>
<h2>Kurzanleitung</h2>
<p>
Die Webanwendungen sind unter den folgenden Adressen verf&uuml;gbar:<br>

Image3d: http://image3d.epistemis.com<br>

F&uuml;r das Einloggen kann der Gastzugang genutzt werden. Ein entsprechender Button findet sich auf den Startseiten.

</p>
<p>
<b>Dateimanager</b><br>
Direkt nach dem Einloggen befinden Sie sich in ihrem pers&ouml;nlichen  Dateimanager.<br>
<br>
Wenn Sie Image 3D zum ersten Mal besuchen, erhalten Sie eine pers&ouml;nliche ID. 
Diese Identifikation wird in einem Cookie gespeichert und erm&ouml;glicht Ihnen das 
Verwalten von eigenen Daten auf dem Server. In der linken Spalte wir ihre 
pers&ouml;nliche ID (z.B. aaonnncn11719868212 62 mit 20 Ziffern) angezeigt.  Am besten 
kopieren oder notieren Sie sich ihre ID.<br>
<br>
Falls Sie auf ihre Daten von einem anderen Rechner zugreifen m&ouml;chten, k&ouml;nnen Sie 
ihre notierte ID im Feld in der linken Spalte eingeben.<br>
<br>
<img src="../images/dateimanager.jpg" alt="Dateimanager">
<br>
Falls Sie ihre Daten in einer Gruppe gemeinsam nutzen wollen, k&ouml;nnen Sie ihre ID den 
anderen Mitgliedern der Gruppe bekannt geben. Damit haben alle Mitglieder das Recht 
in ihrem Konto zu arbeiten.<br>
<br>

Beim ersten Besuch befinden sich f&uuml;nf Dateien in ihrem Konto. Durch einen Klick auf 
das gelbe Zahnrad gelangen Sie in den Render-Editor<br>
<br>

Eigene Daten k&ouml;nnen unten in der mittleren Spalte auf ihr Konto geladen werden. 
In der rechten Spalte befinden sich bereits erstellte Reliefbilder.<br>
</p>
<p>
<b>Render-Editor</b><br>
Im Render-Editor k&ouml;nnen Sie die Parameter zur Erstellung dreidimensionale Reliefbilder 
w&auml;hlen. Mit dem Knopf <b>Ausf&uuml;hren</b> wird der Auftrag auf dem Server gestartet. Nach ca.
 2 Sekunden erhalten Sie das Reliefbild.<br>
<br>
Die Parameter k&ouml;nnen optimieren werden, bis ihnen die Darstellung gef&auml;llt. Die 
erstellten Reliefbilder werden im Dateimanager in der rechten Spalte gespeichert.<br>
<br>
 <img src="../images/rendereditor.jpg" alt="RenderEditor">
<br>
<b>Kurzerkl&auml;rung zu den Parametern</b><br>
Distance:  Abstand von Kameraposition zur Oberfl&auml;che<br>
CameraPosition: Relative Kameraposition, z.B. <em>oben links</em> oder <em>oben im Zentrum</em><br>
Background: Hintergrundfarbe<br>
CameraBrigthness: Helligkeit der Lichtquelle (z.B. 0.5 schwaches Licht, 3.5 helles Licht)<br>
ColorPattern: verschiedene Farbverl&auml;ufe<br>
AmbientLight: Umgebungslicht <br>
ZFactor: &uuml;berh&ouml;hung oder Skalierung des Reliefs (z.B. 0.5 flache Oberfl&auml;che) <br>
Rotation: Drehung der Oberfl&auml;che<br>
ImageSize: Format des erstellten Bildes<br>
<br>
</p>

<p>
<b>Kompatibilit&auml;t</b><br>
Wir sind bem&uuml;ht, die Webanwendungen mit s&auml;mtlichen Browsern und auf allen g&auml;ngigen 
Betriebssystemen kompatibel zu halten. Es kann jedoch nicht a priori ausgeschlossen 
werden, dass gewisse Systeme unsere Anwendung nicht fehlerfrei darstellen. Bitte 
melden Sie Probleme oder Fehler von image3d an:<br> 
info@epistemis.com<br>
<br>
Nachfolgend eine Liste, die Betriebssystem-Browserkombinationen enth&auml;lt, die von 
uns getestet wurden und die die Webanwendungen korrekt darstellen.<br>
<br>
Microsoft Windows:<br>
	Internet Explorer 6.0<br>
	Mozilla 1.7<br>
	Netscape 7.2<br>
	Firefox 1.5<br>
	Firefox 2.0<br>
<br>

Apple OS X:<br>
	Safari 2.0<br>
	Firefox 1.5<br>
	Firefox 2.0<br>
<br>
Linux (Fedora Core 4)<br>
	Mozilla 1.7<br>
	Firefox 1.5<br>
<br>

Bitte beachten Sie, dass f&uuml;r die Nutzung von image3d Cookies aktiviert sein m&uuml;ssen. 
Sollte Ihr Browser aufgrund der Sicherheitseinstellungen keine Cookies akzeptieren, 
k&ouml;nnen Sie die Applikation nicht nutzen.<br>
<br>
</p>


<hr class="doc">

<nano:copyright/>
</body>
</html>