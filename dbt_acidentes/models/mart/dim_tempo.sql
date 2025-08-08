{{ config(materialized='table') }}

with datas as (
  select distinct dt_acid as data_evento
  from {{ ref('stg_acidentes_trabalho') }}
  where dt_acid is not null
)
select
  data_evento,
  extract(year  from data_evento) as ano,
  extract(month from data_evento) as mes,
  extract(day   from data_evento) as dia,
  to_char(data_evento,'YYYY-MM')  as ano_mes
from datas
