# yearly-calendar
Ein Ruby-Script um einen Jahreskalender zu erzeugen.

## Voraussetzungen

- Ruby
- Latex


## Nutzung

- Ordner ```Data``` anlegen.
- Event-Liste als ics Dateien einfügen
- Geburtstagsliste als CSV einfügen (Datum, Name)
- Ausführen des Ruby Scripts
- Anschließend ausführen des Ruby-Scripts
- Anschließend pdflatex


## Quellen

- Kalender TEX siehe https://github.com/rolfn/kalenderRN
- Ferientermine von https://www.schulferien.org/deutschland/ical/
- Jüdische Feiertage von Hebcal

## ToDOs

- Integration Font Awesome für Icons neben Feiertagen 
- Berechnung des Alters für Geburtstage
- Wichtigkeit der Termine (Feiertage > Wochenende > Ferien)
- HebCal erzeugt mehrfache Einträge - prüfen und ggf. auf unique bestehen


