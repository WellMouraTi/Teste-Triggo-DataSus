-- Time travel:

-- selecione o data base e a coleção
use database ACIDENTES_DB;
use schema DBT_WBARROS;

-- crie uma teste e copia
create or replace table TT_DEMO as
select * from FATO_ACIDENTE_TRABALHO;

set TS_BEFORE = current_timestamp();

-- apaga 1000 ou mais linhas só para gerar histórico 
create or replace temporary table TT_IDS as
select id_acidente
from TT_DEMO
where dt_acid is not null
qualify row_number() over (order by id_acidente) <= 1000;

-- conferir quantas ficaram
select count(*) from TT_DEMO;

delete from TT_DEMO
using TT_IDS
where TT_DEMO.id_acidente = TT_IDS.id_acidente;

select 'AGORA' as quando, count(*) as linhas from TT_DEMO
union all
select 'ANTES (TT)' as quando, count(*) as linhas
from TT_DEMO at (timestamp => $TS_BEFORE);

drop table if exists TT_IDS;
drop table if exists TT_DEMO;


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

-- 3) CLUSTERING (VALIDAÇÃO)
-- Mostra a chave de cluster no DDL
select get_ddl('table','ACIDENTES_DB.DBT_WBARROS.FATO_ACIDENTE_TRABALHO');

-- Info de clustering (opcional)
select system$clustering_information('ACIDENTES_DB.DBT_WBARROS.FATO_ACIDENTE_TRABALHO');

-- Verifique se esta valido o cluster_by:

-- confere se a chave de cluster está no DDL
select get_ddl('table','ACIDENTES_DB.DBT_WBARROS.FATO_ACIDENTE_TRABALHO');

-- visão rápida
show tables like 'FATO_ACIDENTE_TRABALHO' in schema ACIDENTES_DB.DBT_WBARROS;
