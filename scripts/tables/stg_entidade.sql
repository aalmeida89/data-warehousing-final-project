CREATE TABLE "public".STG_ENTIDADE
(
  id BIGSERIAL
, categoria varchar(255)
, entidade varchar(255)
, CONSTRAINT UC_Entidade UNIQUE (categoria,entidade)
)
;