{{ config(materialized='table') }}

select * from values
  ('M','Masculino'),
  ('F','Feminino'),
  ('I','Ignorado')
as t(codigo, descricao)