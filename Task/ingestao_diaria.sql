-- garante structures usadas pela ingestão
create or replace file format ACIDENTES_DB.RAW.csv_datasus
  type = csv
  field_delimiter = ';'
  skip_header = 1
  field_optionally_enclosed_by = '"'
  null_if = ('', 'NULL')
  encoding = 'ISO-8859-1';

create or replace stage ACIDENTES_DB.RAW.acidentes_stage
  file_format = ACIDENTES_DB.RAW.csv_datasus;

-- TASK: roda todo dia às 02:00 BRT
create or replace task TASK_INGEST_ACIDENTES_DAILY
  warehouse = <SEU_WH>
  schedule = 'USING CRON 0 2 * * * America/Sao_Paulo'
as
copy into ACIDENTES_DB.RAW.acidentes_trabalho_raw
from @ACIDENTES_DB.RAW.acidentes_stage/ACGRBR24.csv
file_format = (format_name = ACIDENTES_DB.RAW.csv_datasus)
on_error = CONTINUE;

-- habilita a task
alter task TASK_INGEST_ACIDENTES_DAILY resume;

-- ver histórico da task 
select *
from table(information_schema.task_history(
  scheduled_time_range_start=>dateadd('hour', -24, current_timestamp()),
  result_limit=>50
))
order by scheduled_time desc;
