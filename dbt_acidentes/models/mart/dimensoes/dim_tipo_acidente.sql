{{ config(materialized='table', transient=true) }}

select * from values
  ('1','Típico'),
  ('2','Trajeto'),
  ('9','Ignorado')
as t(codigo, descricao)