-- Criar database e schema para organização
CREATE DATABASE IF NOT EXISTS ACIDENTES_DB;
CREATE SCHEMA IF NOT EXISTS ACIDENTES_DB.RAW;

-- Criar file format padrão CSV
CREATE OR REPLACE FILE FORMAT csv_comma_format
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"';

-- Criar um stage para upload dos arquivos brutos
CREATE OR REPLACE STAGE acidentes_stage
    FILE_FORMAT = csv_comma_format;
