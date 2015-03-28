CREATE SCHEMA av_sgv_work
  AUTHORIZATION stefan;
GRANT ALL ON SCHEMA av_sgv_work TO stefan;
GRANT USAGE ON SCHEMA av_sgv_work TO mspublic;


--DROP TABLE av_sgv_work.liegen_selbst_area_parts;
CREATE TABLE av_sgv_work.liegen_selbst_area_parts
(
 ogc_fid SERIAL PRIMARY KEY, 
 nummer VARCHAR,
 nbident VARCHAR,
 art VARCHAR,
 bfsnr INTEGER,
 geometrie GEOMETRY(Polygon, 21781)
)
WITH (OIDS=FALSE);

GRANT ALL ON TABLE av_sgv_work.liegen_selbst_area_parts TO stefan;
GRANT SELECT ON TABLE av_sgv_work.liegen_selbst_area_parts TO mspublic;

CREATE INDEX idx_av_sgv_work_liegen_selbst_area_parts_ogc_fid
  ON av_sgv_work.liegen_selbst_area_parts
  USING btree
  (ogc_fid);
  
CREATE INDEX idx_av_sgv_work_liegen_selbst_area_parts_art
  ON av_sgv_work.liegen_selbst_area_parts
  USING btree
  (art);

CREATE INDEX idx_av_sgv_work_liegen_selbst_area_parts_geometrie
  ON av_sgv_work.liegen_selbst_area_parts
  USING gist
  (geometrie);


--DROP TABLE av_sgv_work.liegen_selbst_area;
CREATE TABLE av_sgv_work.liegen_selbst_area
(
 ogc_fid SERIAL PRIMARY KEY, 
 nummer VARCHAR,
 nbident VARCHAR,
 art VARCHAR,
 bfsnr INTEGER,
 geometrie GEOMETRY(MultiPolygon, 21781)
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


--DROP TABLE av_sgv_work.gebaeude_rechte;
CREATE TABLE av_sgv_work.gebaeude_rechte
(
 ogc_fid SERIAL PRIMARY KEY, 
 nummer VARCHAR,
 nbident VARCHAR,
 art_recht VARCHAR,
 art_geb VARCHAR,
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
