{{ config(materialized='view') }}

with base as (
  select *
  from {{ ref('stg_acidentes_trabalho') }}
  where dt_acid is not null
),
dedup as (
  select
    b.*,
    row_number() over (
      partition by
        dt_acid, sg_uf, sg_uf_not, mun_acid, id_mn_resi,
        cid_acid, cid_lesao, id_ocupa_n, cnae_prin, cnae,
        cs_sexo, cs_raca, tipo_acid, part_corp1, part_corp2, part_corp3,
        evolucao, cat, nu_trab
      order by dt_acid
    ) as rn
  from base b
)
select *
from dedup
where rn = 1
