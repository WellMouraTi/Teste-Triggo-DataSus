-- 3) CLUSTERING (VALIDAÇÃO)
-- Mostra a chave de cluster no DDL
select get_ddl('table','ACIDENTES_DB.DBT_WBARROS.FATO_ACIDENTE_TRABALHO');

-- Info de clustering (opcional)
select system$clustering_information('ACIDENTES_DB.DBT_WBARROS.FATO_ACIDENTE_TRABALHO');

-- 4) Verifique se esta valido o cluster_by:

-- confere se a chave de cluster está no DDL
select get_ddl('table','ACIDENTES_DB.DBT_WBARROS.FATO_ACIDENTE_TRABALHO');

-- visão rápida
show tables like 'FATO_ACIDENTE_TRABALHO' in schema ACIDENTES_DB.DBT_WBARROS;
