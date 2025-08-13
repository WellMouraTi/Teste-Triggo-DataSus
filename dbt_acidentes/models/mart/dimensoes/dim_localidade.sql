{{ config(materialized='table', transient=true) }}

select distinct
  upper(trim(sg_uf))           as uf,
  try_to_number(mun_acid)      as cod_municipio
from {{ ref('stg_acidentes_trabalho') }}
where sg_uf is not null
