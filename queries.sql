/*
SELECT * 
FROM
(
 SELECT l.ogc_fid, l.nummer, ST_Intersection(b.geometrie, l.geometrie) as the_geom
 FROM
 (
  SELECT *
  FROM av_mopublic.liegenschaften__selbstrecht_bergwerk
  WHERE bfsnr = 2529
  AND tid = '2529000016866'
 ) as b,
 (
  SELECT *
  FROM av_mopublic.liegenschaften__liegenschaft
  WHERE bfsnr = 2529
  AND tid IN ('2529000016863','2529000016865')
 ) as l
 WHERE ST_Intersects(b.geometrie, l.geometrie)
) as z
WHERE geometrytype(the_geom) = 'POLYGON'
*/

/*

CREATE SCHEMA av_sgv_work
  AUTHORIZATION stefan;
GRANT ALL ON SCHEMA av_sgv_work TO stefan;
GRANT USAGE ON SCHEMA av_sgv_work TO mspublic;

--DROP TABLE av_sgv_work.liegen_selbst_area;
CREATE TABLE av_sgv_work.liegen_selbst_area
(
 ogc_fid SERIAL PRIMARY KEY, 
 nummer VARCHAR,
 nbident VARCHAR,
 art VARCHAR,
 bfsnr INTEGER,
 geometrie GEOMETRY(Polygon, 21781)
)
WITH (OIDS=FALSE);

GRANT ALL ON TABLE av_sgv_work.liegen_selbst_area TO stefan;
GRANT SELECT ON TABLE av_sgv_work.liegen_selbst_area TO mspublic;

CREATE INDEX idx_av_sgv_work_liegen_selbst_area_ogc_fid
  ON av_sgv_work.liegen_selbst_area
  USING btree
  (ogc_fid);
  
CREATE INDEX idx_av_sgv_work_liegen_selbst_area_art
  ON av_sgv_work.liegen_selbst_area
  USING btree
  (art);

CREATE INDEX idx_av_sgv_work_liegen_selbst_area_geometrie
  ON av_sgv_work.liegen_selbst_area
  USING gist
  (geometrie);

*/

/*
DELETE FROM av_sgv_work.liegen_selbst_area;

INSERT INTO av_sgv_work.liegen_selbst_area (nbident, nummer, geometrie, art, bfsnr)

SELECT liegen.nbident,
 CASE WHEN selbst.ogc_fid IS NULL 
  THEN liegen.nummer
  ELSE selbst.nummer
 END as nummer,
 geom,
 CASE WHEN selbst.ogc_fid IS NULL 
  THEN 'liegen'
  ELSE 'selbst'
 END as art,
 liegen.bfsnr
FROM
(
 SELECT ST_PointOnSurface(geom) as geom_point, geom
 FROM
 (
  SELECT (ST_Dump(ST_Polygonize(geom))).geom as geom
  FROM
  (
   SELECT ST_Union(geom) as geom
   FROM
   (
    SELECT ST_Boundary((geometrie)) as geom
    FROM av_mopublic.liegenschaften__selbstrecht_bergwerk
    WHERE bfsnr = 2529

    UNION

    SELECT ST_Boundary((geometrie)) as geom
    FROM av_mopublic.liegenschaften__liegenschaft
    WHERE bfsnr = 2529
   ) as a
  ) as b
 ) as c
 WHERE geometrytype(geom) LIKE '%POLYGON'
) as d
LEFT JOIN 
( 
 SELECT *
 FROM av_mopublic.liegenschaften__liegenschaft 
 WHERE bfsnr = 2529
) as liegen ON ST_Within(d.geom_point, liegen.geometrie)
LEFT JOIN 
(
 SELECT * 
 FROM av_mopublic.liegenschaften__selbstrecht_bergwerk
 WHERE bfsnr = 2529
) as selbst ON ST_Within(d.geom_point, selbst.geometrie)
WHERE ST_Area(geom) > 0.01;
*/

/*
SELECT art, nummer, nbident, ST_Union(geometrie) as geometrie
FROM av_sgv_work.liegen_selbst_area_parts
WHERE bfsnr = 2529
AND art = 'selbst'
GROUP BY nummer, nbident, art, bfsnr

UNION

SELECT art, nummer, nbident, geometrie
FROM av_sgv_work.liegen_selbst_area_parts
WHERE bfsnr = 2529
AND art = 'liegen'
*/


--DROP TABLE av_sgv_work.gebaeude_rechte;
CREATE TABLE av_sgv_work.gebaeude_rechte
(
 ogc_fid SERIAL PRIMARY KEY, 
 nummer VARCHAR,
 nbident VARCHAR,
 art VARCHAR,
 bfsnr INTEGER,
 geb_id INTEGER, 
 geometrie GEOMETRY(MultiPolygon, 21781),
 grundbuch VARCHAR,
 gemeinde VARCHAR,
 gb_gemnr INTEGER
)
WITH (OIDS=FALSE);

GRANT ALL ON TABLE av_sgv_work.gebaeude_rechte TO stefan;
GRANT SELECT ON TABLE av_sgv_work.gebaeude_rechte TO mspublic;

CREATE INDEX idx_av_sgv_work_gebaeude_rechte_ogc_fid
  ON av_sgv_work.gebaeude_rechte
  USING btree
  (ogc_fid);

CREATE INDEX idx_av_sgv_work_gebaeude_rechte_bfsnr
  ON av_sgv_work.gebaeude_rechte
  USING btree
  (bfsnr);  

CREATE INDEX idx_av_sgv_work_gebaeude_rechte_geometrie
  ON av_sgv_work.gebaeude_rechte
  USING gist
  (geometrie);
*/


SELECT gebaeude.nummer, gebaeude.art, gebaeude.nbident, gebaeude.bfsnr, gebaeude.geb_id, gebaeude.geometrie, kreise.grundbuch, kreise.gemeinde, kreise.gb_gemnr
FROM
(
 SELECT *
 FROM
 (
  SELECT rechte.nummer, rechte.art, rechte.nbident, rechte.bfsnr, bb.ogc_fid as geb_id, ST_Multi(ST_Intersection(bb.geometrie, rechte.geometrie)) as geometrie
  FROM
  (
   SELECT ogc_fid, geometrie
   FROM av_mopublic.bodenbedeckung__boflaeche
   WHERE art = 'Gebaeude'
  AND bfsnr = 2401
  ) as bb,
  (
   SELECT *
   FROM av_sgv_work.liegen_selbst_area
   WHERE bfsnr = 2401
  ) as rechte
  WHERE ST_Intersects(bb.geometrie, rechte.geometrie)
 ) as a
 WHERE geometrytype(geometrie) LIKE '%POLYGON'
) as gebaeude, 
(
 SELECT *
 FROM av_grundbuch.grundbuchkreise 
 WHERE gem_bfs = 2401
) as kreise
--WHERE kreise.gem_bfs = 2529
WHERE ST_Within(ST_PointOnSurface(gebaeude.geometrie), kreise.wkb_geometry)
AND geometrytype(gebaeude.geometrie) = 'MULTIPOLYGON'
--AND ST_Intersects(gebaeude.geometrie, kreise.wkb_geometry)
--AND ST_Distance(gebaeude.geometrie, kreise.wkb_geometry) = 0



