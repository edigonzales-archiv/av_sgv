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
