Allgemein
=========

**Achtung:** Flächen < 0.1 m2 wurden bei Berechnungen ignoriert.

`av_sgv_work.liegen_selbst_area_parts`: Verschnitt Liegenschaften - Selbst. dauernde Rechte. Liegt ein selbst. dauerndes Recht auf verschiedenen Liegenschaften so erscheint es jetzt mehrfach.
`av_sgv_work.liegen_selbst_area`: Mehrfach vorkommende selbst. dauernde Rechte werden wieder vereinigt.


1) liegen_selbst_area_parts.ktr: Erzeugt ein flächendeckendes 'Parzellen'-Netz mit Liegenschaften und Baurechten. Dh. die Baurechte schneiden die Liegenschaften aus und nehmen deren Platz ein.
2) liegen_selbst_area.ktr: Falls ein Baurecht auf verschiedenen Liegenschaften liegt, werden durch die erste Kettle-Transformation mehrere Polygone für dieses Baurecht erzeugt. Diese werden in diesem Schritt wieder zu einem einzigen Polygon zusammengefügt.
3) 
