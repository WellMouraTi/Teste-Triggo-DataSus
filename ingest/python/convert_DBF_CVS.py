# Instalar dependência:
# pip install simpledbf pandas

from simpledbf import Dbf5
import pandas as pd

# Caminho para o arquivo DBF
caminho_dbf = "ACGRBR24.dbf"

# Ler DBF
dbf = Dbf5(caminho_dbf, codec='latin1')  # 'latin1' ou 'utf-8' conforme acentuação
df = dbf.to_dataframe()

# Salvar como CSV
caminho_csv = "ACGRBR24.csv"
df.to_csv(caminho_csv, index=False, encoding='utf-8')

print(f"Arquivo convertido com sucesso: {caminho_csv}")

