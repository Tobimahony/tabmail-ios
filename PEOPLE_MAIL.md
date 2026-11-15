# People Mail: erster eigenständiger Simulator-Test

Entwicklungszweig: `people-mail/standalone-start`, auf Basis von TabMail
`a07854a77c957240215e35639c63950e8a979b4a`.

Dies ist eine interne Testfassung, kein fertiger People-Mail-Client. Sie ist
nicht mit Lisem AI Ltd verbunden und wird nicht von ihr unterstützt.
Die MPL-2.0 und die Hinweise der Drittanbieter bleiben erhalten.

## Verhalten

- `PEOPLE_MAIL_LOCAL` ist in `project.yml` aktiviert und gilt auch für die
  Notification Extension. `Shared/PeopleMailMode.swift` enthält die gemeinsame
  Einstellung.
- Beim Start erscheint die vorhandene Kontoeinrichtung direkt, ohne TabMail-
  Anmeldung, Tour, KI-Einwilligung oder TabMail-spezifische Altersprüfung.
- Zum ersten Test werden IMAP und iCloud angeboten. Gmail/Microsoft werden
  ausgeblendet, bis eigene OAuth-Anwendungen eingerichtet und geprüft sind.
- Direkte Mailprovider bleiben erhalten; Konten werden nicht automatisch angelegt.
- Vorhandene TabMail-Sitzungen werden nicht als aktive Sitzung verwendet.
- KI-Aufrufe und die Anforderung einer APNs-Registrierung sind deaktiviert.
- Die konfigurierten TabMail-Dienste (API, Push, Auth, Sync, Templates, Billing,
  Feedback, Receipt-Webhook sowie die NSE-Fallbacks) zeigen auf einen reservierten
  `.invalid`-Host. Versehentliche Dienstaufrufe können so keinen TabMail-Server
  erreichen. Das ist noch kein vollständiger Netzwerk-Audit aller Funktionen.

## Auf dem Mac bauen

Xcode zuvor stoppen, dann im Terminal:

```sh
cd ~/Developer/people-mail-ios
git fetch origin
git switch --track origin/people-mail/standalone-start
./Scripts/xcodegen.sh
open TabMail.xcodeproj
```

`Secrets.xcconfig` bleibt lokal erhalten. Im Schema `TabMail` einen iPhone-
Simulator wählen und mit Cmd-R bauen. Den früher gesetzten Tour-Haltepunkt
kann man deaktivieren.

Zur gezielten Prüfung der Dienstkonfiguration (Simulatornamen ggf. anpassen):

```sh
xcodebuild -project TabMail.xcodeproj -scheme TabMail \
  -destination 'platform=iOS Simulator,name=iPhone 18 Pro' \
  -only-testing:TabMailTests/PeopleMailModeTests test
```

## Noch zu prüfen und umzusetzen

- Diese Änderungen konnten im Linux-Arbeitsbereich nur statisch geprüft werden.
  Xcode-Build, neue Unit-Tests und echte Kontoverbindungen sind noch nicht geprüft.
- Zuerst den Kontoeinrichtungsbildschirm im Simulator prüfen, danach ein bewusst
  gewähltes IMAP-Konto verbinden und Empfang, Ordner, Gelesenstatus sowie SMTP testen.
- Personenansicht, Feeds und People-Mail-Metadatensynchronisierung fehlen.
- Noch enthaltene TabMail-KI-/Abo-/Anmeldeseiten sind für diesen Test nicht nutzbar.
  Sie werden im nächsten Schritt aus der Oberfläche entfernt.
- Die Testfassung verwendet vorerst dieselbe Bundle-ID und App Group wie der
  Ausgangsclient. Deshalb nur im Entwicklungssimulator verwenden. Vor einer
  Installation auf dem echten iPhone werden Kennungen, App Group, Logos und
  weitere sichtbare Marken vollständig auf People Mail umgestellt.
- Kein Pushdienst und keine geräteübergreifende Metadatensynchronisierung.

## Rückkehr zur unveränderten Grundlage

```sh
git switch main
./Scripts/xcodegen.sh
```

Die lokalen Mail- und Simulator-Daten werden dabei nicht automatisch gelöscht.
