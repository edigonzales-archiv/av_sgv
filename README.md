Allgemein
=========

**Achtung:** Flächen < 0.1 m2 wurden bei Berechnungen ignoriert.

`av_sgv_work.liegen_selbst_area_parts`: Verschnitt Liegenschaften - Selbst. dauernde Rechte. Liegt ein selbst. dauerndes Recht auf verschiedenen Liegenschaften so erscheint es jetzt mehrfach.
`av_sgv_work.liegen_selbst_area`: Mehrfach vorkommende selbst. dauernde Rechte werden wieder vereinigt.


1) liegen_selbst_area_parts.ktr: Erzeugt ein flächendeckendes 'Parzellen'-Netz mit Liegenschaften und Baurechten. Dh. die Baurechte schneiden die Liegenschaften aus und nehmen deren Platz ein.
2) liegen_selbst_area.ktr: Falls ein Baurecht auf verschiedenen Liegenschaften liegt, werden durch die erste Kettle-Transformation mehrere Polygone für dieses Baurecht erzeugt. Diese werden in diesem Schritt wieder zu einem einzigen Polygon zusammengefügt.
3) gebaeude_rechte.ktr: 
4) gebaedue_rechte_export.ktr
5) Job: gebaeude_liegen_selbst.kjb


E-Mail an A. Lüscher
====================
* Problem Baselstrasse: Sollte jetzt zuverlässiger funktionieren. Aus dem Verschnitt Flächennetz—Gebäude resultierte eine Geometrycollection (Gebäude lag perfekt numerisch perfekt auf Grenzlinie und irgendwie eine zusätzliche seltene geometrische Bedingung). Aus dieser Geometrycollection werden neu Polygon extrahiert (ST_CollectionExtract(): kann man sich hinter die Ohren schreiben). Der Fehler lag darin, dass ich alles was nicht ein (Multi)Polygon war, ignoriert habe. Was soweit auch ok war, weil ja auch Linestrings beim Verschnitt auftreten könne. Aber eben, war nur halb die Lösung…
* Neu gibt’s eine Spalte „art_geb“ (die Spalte „art“ heisst neu „art_recht“):
 * Gebaeude
 * projektiertes_Gebaeude
 * Reservoir
 * unterirdisches Gebaeude
 *Unterstand
* -> Hab ich das richtig verstanden: Unterstand nur mit Gebäudeadressen? Alle anderen EO kann ich immer verwenden?
* Unterstand kann bissle tricky werden, z.B. beim Bahnhof Solothurn: Da liegt ein unterirdisches Gebäude MIT Gebäudeeingang unter einem Unterstand. Das fange ich jetzt ab indem ich prüfe ob der Gebäudeeingang IM Unterstand eine Höhenlage < 0 hat. Dann wird der Unterstand nicht verwendet. Das funktioniert aber trotzdem beim Bahnhof trotzdem noch nicht. Das ist so verzwickt/komplizierte Situation, das muss man wahrscheinlich händisch anschauen… Okularkontrolle. Ansonsten scheints zu funktionieren.
* Unterirdische Gebäude: Das unterirdische Gebäude kann sich mit einem Gebäude überlappen. Ist das tragisch?
