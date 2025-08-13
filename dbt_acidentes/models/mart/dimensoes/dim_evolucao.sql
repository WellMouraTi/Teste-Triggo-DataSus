{{ config(materialized='table', transient=true) }}

select * from values
  ('1','Cura'),
  ('2','Incapacidade temporária'),
  ('3','Incapacidade parcial permanente'),
  ('4','Incapacidade total permanente'),
  ('5','Óbito por acidente de trabalho grave'),
  ('6','Óbito por outras causas'),
  ('7','Outro'),
  ('9','Ignorado')
as t(codigo, descricao)
