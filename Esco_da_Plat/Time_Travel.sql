-- cópia de trabalho
create or replace table TT_DEMO as
select * from FATO_ACIDENTE_TRABALHO;

-- 1) salva o timestamp "antes"
set TS_BEFORE = current_timestamp();

-- conferir quantas ficaram
select count(*) from TT_DEMO;

-- 3) apaga essas 1000 linhas usando join
delete from TT_DEMO
using TT_IDS
where TT_DEMO.id_acidente = TT_IDS.id_acidente;

-- 4) Depois compare com Time Travel:
select 'AGORA' as quando, count(*) as linhas from TT_DEMO
union all
select 'ANTES (TT)' as quando, count(*) as linhas
from TT_DEMO at (timestamp => $TS_BEFORE);
