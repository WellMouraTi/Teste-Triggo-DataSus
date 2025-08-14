-- 3) CLUSTERING (VALIDAÇÃO)
-- Aplicação no projeto (via dbt): definimos cluster_by na fato, caminho e codigo abaixo.
-- models/mart/fatos/fato_acidente_trabalho.sql
--{{ config(
--  materialized='table',
--  cluster_by=['dt_acid','sg_uf']
--) }}

-- Rode o modelo (se a tabela já existia, use full-refresh):
-- dbt run --full-refresh --select fato_acidente_trabalho

-- Mostra a chave de cluster no DDL
select get_ddl('table','ACIDENTES_DB.DBT_WBARROS.FATO_ACIDENTE_TRABALHO');

-- Info de clustering (opcional)
select system$clustering_information('ACIDENTES_DB.DBT_WBARROS.FATO_ACIDENTE_TRABALHO');

-- 4) Verifique se esta valido o cluster_by:

-- confere se a chave de cluster está no DDL
select get_ddl('table','ACIDENTES_DB.DBT_WBARROS.FATO_ACIDENTE_TRABALHO');

-- visão rápida
show tables like 'FATO_ACIDENTE_TRABALHO' in schema ACIDENTES_DB.DBT_WBARROS;
