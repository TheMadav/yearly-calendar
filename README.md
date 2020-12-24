# yearly-calendar
Ein Ruby-Script um einen Jahreskalender zu erzeugen.

## Voraussetzungen

- Ruby
- pdfLatex

## Nutzung

- Datei ```birthday_example.csv```in Ordner ```data``` umbenennen in ```birthday.csv```
- Geburtstagsliste als CSV einfügen (Datum, Name, FontAwesome Icon), siehe Beispieldatei
- Ausführen des Bash-skripts calendar.sh
- config.YAML anpassen, um weitere Quellen anzupassen


## Konfiguration detailliert

| Name | Beschreibung  | Beispiel
|:--|:--|:--|
| Title | Titel der Quelle, wird für das Eventfile benötigt | birthdays |
|url | URL des ICS-Files, wenn im Internet verfügbar  |https://www.schulferien.eu/downloads/ical4.php?land=HE&type=0&year=2021 |
| file |Lokale Datei  | ./data/birthdays.csv |
| color | Farbe, die Events im Kalender haben soll  | Black!20 |
| period | Handelt es sich um Zeiträume, also mehrere Tage hintereinander (```true```=Zeitraum). Standardmäßig wird ```false`` angenommen | true/false |
| calcDifference | Soll der Unterschied zu heute berechnet werden, bspw. für das Alter von Geburtstagen? Standardmäßig wird ```false``` angenommen | true/false |
| icon | Das Standard-Icon (Font Awesome) für einen Import (wird bei lokalen CSV nicht berücksichtigt, da dort Icon pro Zeile angegeben werden kann | \faBirthdayCake |

## Details
### Calc Difference

- Wenn in der CSV die Jahreszahl größer als das aktuelle Jahr ist, wird kein Alter berechnet

## Quellen

- Kalender TEX siehe https://github.com/rolfn/kalenderRN
- Ferientermine von https://www.schulferien.eu

## ToDOs

- Wichtigkeit der Termine (Feiertage > Wochenende > Ferien)
- Standard-Icon auch für lokale CSV berücksichtigen, kann ja überschrieben werden

## Lizenz

MIT Lizenz gilt nicht für die Tex-Dateien, diese stehen unter CC-BY-SA, siehe https://github.com/rolfn/kalenderRN
