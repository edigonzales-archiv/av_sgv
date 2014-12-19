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
