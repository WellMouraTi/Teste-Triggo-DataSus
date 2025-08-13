{{ config(
    materialized='table',
    cluster_by=['dt_acid','sg_uf']
) }}


with base as (
  select *
  from {{ ref('stg_acidentes_trabalho') }}
  where dt_acid is not null
),

-- mantém só 1 linha por combinação de atributos do evento
dedup as (
  select b.*
  from base b
  qualify row_number() over (
    partition by
      dt_acid,
      sg_uf,
      sg_uf_not,
      mun_acid,
      id_mn_resi,
      cid_acid,
      cid_lesao,
      id_ocupa_n,
      cnae_prin,
      cnae,
      cs_sexo,
      cs_raca,
      tipo_acid,
      part_corp1,
      part_corp2,
      part_corp3,
      evolucao,
      cat,
      nu_trab
    order by dt_acid
  ) = 1
)

select
  /* chave substituta determinística (sempre não-nula) */
  md5_hex(
    coalesce(to_varchar(dt_acid),'') || '|' ||
    coalesce(sg_uf,'')               || '|' ||
    coalesce(sg_uf_not,'')           || '|' ||
    coalesce(to_varchar(mun_acid),'')|| '|' ||
    coalesce(to_varchar(id_mn_resi),'') || '|' ||
    coalesce(cid_acid,'')            || '|' ||
    coalesce(cid_lesao,'')           || '|' ||
    coalesce(to_varchar(id_ocupa_n),'') || '|' ||
    coalesce(cnae_prin,'')           || '|' ||
    coalesce(cnae,'')                || '|' ||
    coalesce(to_varchar(cs_sexo),'') || '|' ||
    coalesce(to_varchar(cs_raca),'') || '|' ||
    coalesce(to_varchar(tipo_acid),'') || '|' ||
    coalesce(to_varchar(part_corp1),'') || '|' ||
    coalesce(to_varchar(part_corp2),'') || '|' ||
    coalesce(to_varchar(part_corp3),'') || '|' ||
    coalesce(to_varchar(evolucao),'') || '|' ||
    coalesce(to_varchar(cat),'')     || '|' ||
    coalesce(to_varchar(nu_trab),'')
  ) as id_acidente,

  -- chaves e medidas
  nu_trab                                            as qtd_trabalhadores_evento,
  dt_acid,
  cid_lesao,
  cid_acid,
  sg_uf,
  sg_uf_not,
  mun_acid,
  id_mn_resi,
  id_ocupa_n,
  cnae_prin,
  cnae,

  -- dimensões codificadas
  b.cs_sexo,
  ds_sexo.descricao         as sexo_desc,

  b.cs_raca,
  dr.descricao              as raca_desc,

  b.tipo_acid,
  dta.descricao             as tipo_acidente_desc,

  b.part_corp1,
  dpc1.descricao            as parte_corpo1_desc,
  b.part_corp2,
  dpc2.descricao            as parte_corpo2_desc,
  b.part_corp3,
  dpc3.descricao            as parte_corpo3_desc,

  b.evolucao,
  dev.descricao             as evolucao_desc,

  b.cat

from dedup b
left join {{ ref('dim_sexo') }}          ds_sexo on ds_sexo.codigo  = b.cs_sexo
left join {{ ref('dim_raca') }}          dr      on dr.codigo       = b.cs_raca
left join {{ ref('dim_tipo_acidente') }} dta     on dta.codigo      = b.tipo_acid
left join {{ ref('dim_partes_corpo') }}  dpc1    on dpc1.codigo     = b.part_corp1
left join {{ ref('dim_partes_corpo') }}  dpc2    on dpc2.codigo     = b.part_corp2
left join {{ ref('dim_partes_corpo') }}  dpc3    on dpc3.codigo     = b.part_corp3
left join {{ ref('dim_evolucao') }}      dev     on dev.codigo      = b.evolucao
