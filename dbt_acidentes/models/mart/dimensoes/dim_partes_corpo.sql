{{ config(materialized='table') }}

select * from values
  ('01','Olho'),
  ('02','Cabeça'),
  ('03','Pescoço'),
  ('04','Tórax'),
  ('05','Abdome'),
  ('06','Mão'),
  ('07','Membro superior'),
  ('08','Membro inferior'),
  ('09','Pé'),
  ('10','Todo o corpo'),
  ('11','Outro'),
  ('99','Ignorado')
as t(codigo, descricao)
