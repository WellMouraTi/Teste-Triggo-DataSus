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