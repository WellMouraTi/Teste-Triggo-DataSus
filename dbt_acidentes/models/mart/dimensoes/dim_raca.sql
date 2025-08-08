{{ config(materialized='table') }}

select * from values
  ('1','Branca'),
  ('2','Preta'),
  ('3','Amarela'),
  ('4','Parda'),
  ('5','Indígena'),
  ('9','Ignorado')
as t(codigo, descricao)
