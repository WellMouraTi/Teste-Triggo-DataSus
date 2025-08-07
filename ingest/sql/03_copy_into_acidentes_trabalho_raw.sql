COPY INTO acidentes_trabalho_raw
FROM @acidentes_stage/ACGRBR24.csv
FILE_FORMAT = (FORMAT_NAME = csv_comma_format);
