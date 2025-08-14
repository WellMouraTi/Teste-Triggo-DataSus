{{ config(
    materialized='table',
    cluster_by=['dt_acid','sg_uf']
) }}

select
  /* chave substituta determinística (sempre não-nula) */
  md5_hex(
    coalesce(to_varchar(b.dt_acid),'')        || '|' ||
    coalesce(b.sg_uf,'')                      || '|' ||
    coalesce(b.sg_uf_not,'')                  || '|' ||
    coalesce(to_varchar(b.mun_acid),'')       || '|' ||
    coalesce(to_varchar(b.id_mn_resi),'')     || '|' ||
    coalesce(b.cid_acid,'')                   || '|' ||
    coalesce(b.cid_lesao,'')                  || '|' ||
    coalesce(to_varchar(b.id_ocupa_n),'')     || '|' ||
    coalesce(b.cnae_prin,'')                  || '|' ||
    coalesce(b.cnae,'')                       || '|' ||
    coalesce(to_varchar(b.cs_sexo),'')        || '|' ||
    coalesce(to_varchar(b.cs_raca),'')        || '|' ||
    coalesce(to_varchar(b.tipo_acid),'')      || '|' ||
    coalesce(to_varchar(b.part_corp1),'')     || '|' ||
    coalesce(to_varchar(b.part_corp2),'')     || '|' ||
    coalesce(to_varchar(b.part_corp3),'')     || '|' ||
    coalesce(to_varchar(b.evolucao),'')       || '|' ||
    coalesce(to_varchar(b.cat),'')            || '|' ||
    coalesce(to_varchar(b.nu_trab),'')
  ) as id_acidente,

  /* chaves e medidas */
  b.nu_trab                                        as qtd_trabalhadores_evento,
  b.dt_acid,
  b.cid_lesao,
  b.cid_acid,
  b.sg_uf,
  b.sg_uf_not,
  b.mun_acid,
  b.id_mn_resi,
  b.id_ocupa_n,
  b.cnae_prin,
  b.cnae,

  /* dimensões codificadas + descrições */
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

from {{ ref('int_acidentes_trabalho') }} b
left join {{ ref('dim_sexo') }}          ds_sexo on ds_sexo.codigo  = b.cs_sexo
left join {{ ref('dim_raca') }}          dr      on dr.codigo       = b.cs_raca
left join {{ ref('dim_tipo_acidente') }} dta     on dta.codigo      = b.tipo_acid
left join {{ ref('dim_partes_corpo') }}  dpc1    on dpc1.codigo     = b.part_corp1
left join {{ ref('dim_partes_corpo') }}  dpc2    on dpc2.codigo     = b.part_corp2
left join {{ ref('dim_partes_corpo') }}  dpc3    on dpc3.codigo     = b.part_corp3
left join {{ ref('dim_evolucao') }}      dev     on dev.codigo      = b.evolucao
