{{ config(materialized='table', transient=true) }}

select * from values
  ('M','Masculino'),
  ('F','Feminino'),
  ('I','Ignorado')
as t(codigo, descricao)