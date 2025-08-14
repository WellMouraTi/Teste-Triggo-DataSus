{{ config(materialized='view') }}

select
  tp_not,
  id_agravo,
  try_to_date(dt_notific)  as dt_notific,
  try_to_date(dt_acid)     as dt_acid,
  try_to_date(dt_atende)   as dt_atende,
  try_to_date(dt_obito)    as dt_obito,
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

  -- normalização de sg_uf (ruídos -> NULL, IBGE -> sigla, senão apenas upper/trim)
  case
    when upper(trim(sg_uf)) in ('', 'NI', 'N/I', 'IGN', 'IGNORADO', 'ND', 'NA', 'BR', 'EX', '99') then null
    when regexp_like(trim(sg_uf), '^[0-9]{2}$') then
      case trim(sg_uf)
        when '11' then 'RO'
        when '12' then 'AC'
        when '13' then 'AM'
        when '14' then 'RR'
        when '15' then 'PA'
        when '16' then 'AP'
        when '17' then 'TO'
        when '21' then 'MA'
        when '22' then 'PI'
        when '23' then 'CE'
        when '24' then 'RN'
        when '25' then 'PB'
        when '26' then 'PE'
        when '27' then 'AL'
        when '28' then 'SE'
        when '29' then 'BA'
        when '31' then 'MG'
        when '32' then 'ES'
        when '33' then 'RJ'
        when '35' then 'SP'
        when '41' then 'PR'
        when '42' then 'SC'
        when '43' then 'RS'
        when '50' then 'MS'
        when '51' then 'MT'
        when '52' then 'GO'
        when '53' then 'DF'
        else null
      end
    else upper(nullif(trim(sg_uf), ''))
  end as sg_uf,

  -- (opcional) normalização equivalente para sg_uf_not
  case
    when upper(trim(sg_uf_not)) in ('', 'NI', 'N/I', 'IGN', 'IGNORADO', 'ND', 'NA', 'BR', 'EX', '99') then null
    when regexp_like(trim(sg_uf_not), '^[0-9]{2}$') then
      case trim(sg_uf_not)
        when '11' then 'RO'
        when '12' then 'AC'
        when '13' then 'AM'
        when '14' then 'RR'
        when '15' then 'PA'
        when '16' then 'AP'
        when '17' then 'TO'
        when '21' then 'MA'
        when '22' then 'PI'
        when '23' then 'CE'
        when '24' then 'RN'
        when '25' then 'PB'
        when '26' then 'PE'
        when '27' then 'AL'
        when '28' then 'SE'
        when '29' then 'BA'
        when '31' then 'MG'
        when '32' then 'ES'
        when '33' then 'RJ'
        when '35' then 'SP'
        when '41' then 'PR'
        when '42' then 'SC'
        when '43' then 'RS'
        when '50' then 'MS'
        when '51' then 'MT'
        when '52' then 'GO'
        when '53' then 'DF'
        else null
      end
    else upper(nullif(trim(sg_uf_not), ''))
  end as sg_uf_not,

  mun_acid,
  id_mn_resi,
  id_ocupa_n,
  cnae_prin,
  cnae
from {{ source('raw','acidentes_trabalho_raw') }}
