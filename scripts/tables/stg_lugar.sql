CREATE TABLE "public".STG_LUGAR
(
  id BIGSERIAL
, pais varchar(255)
, uf varchar(255)
, cidade varchar(255)
, CONSTRAINT UC_Lugar UNIQUE (pais,uf,cidade)
)
;