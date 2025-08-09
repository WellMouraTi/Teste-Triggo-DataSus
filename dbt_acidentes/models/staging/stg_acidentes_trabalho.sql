{{ config(materialized='view') }}

select
  tp_not,
  id_agravo,
  try_to_date(dt_notific) as dt_notific,
  try_to_date(dt_acid)    as dt_acid,
  try_to_date(dt_atende)  as dt_atende,
  try_to_date(dt_obito)   as dt_obito,
  cid_lesao,
  cid_acid,
  cs_sexo,
  cs_raca,
  tipo_acid,
  part_corp1,
  part_corp2,
  part_corp3,
  evolucao,
  cat,
  nu_trab,
  sg_uf,
  sg_uf_not,
  mun_acid,
  id_mn_resi,
  id_ocupa_n,
  cnae_prin,
  cnae
from {{ source('raw','acidentes_trabalho_raw') }}
