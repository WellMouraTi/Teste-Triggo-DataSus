-- Zero copy cloning:

-- OBS: se a origem for TRANSIENT, o clone também deve ser TRANSIENT.
-- Verifique antes no Snowflake: 
--   select get_ddl('table','ACIDENTES_DB.DBT_WBARROS.FATO_ACIDENTE_TRABALHO');

-- Se a fato for TRANSIENT:
create or replace transient table FATO_ACIDENTE_TRABALHO_CLONE
clone FATO_ACIDENTE_TRABALHO;

-- Se a fato for PERMANENT (use esta em vez da de cima):
-- create or replace table FATO_ACIDENTE_TRABALHO_CLONE
-- clone FATO_ACIDENTE_TRABALHO;

select
  (select count(*) from FATO_ACIDENTE_TRABALHO)        as original,
  (select count(*) from FATO_ACIDENTE_TRABALHO_CLONE) as clone;

drop table if exists FATO_ACIDENTE_TRABALHO_CLONE;