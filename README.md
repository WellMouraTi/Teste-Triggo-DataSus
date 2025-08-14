#  ACGRBR24 – Acidente de Trabalho | Snowflake + dbt (Bootcamp 2025)

Repositório do desafio final do Bootcamp 2025.  
Tema: **Acidente de Trabalho – ACGRBR24**  
Pipeline construído em **Snowflake**, com transformações e modelagem dimensional via **dbt**.

---

##  Coleta e Ingestão de Dados (DataSUS)

Nesta etapa, foi realizada a coleta, preparação e ingestão dos dados do **SINAN – ACGRBR (Acidente de Trabalho Grave)** referentes ao ano de **2024**, simulando um *data lake* na camada de **stage interno** do Snowflake.

###  Coleta dos Dados

1. Acesse o portal do **SINAN – DataSUS** e baixe o conjunto de dados **ACGRBR – 2024**.
2. Baixe também os **arquivos auxiliares para tabulação**, que incluem:
   - Conversor de arquivos `.DBC` para `.DBF`
   - Dicionários de dados e layouts
3. Documentação utilizada:
   - [Dicionário de Dados – Acidente de Trabalho Grave (DRT)](https://portalsinan.saude.gov.br/images/documentos/Agravos/DRT%20Acidente%20Trabalho%20Grave/DIC_DADOS_DRT_Acidente_Trabalho_grave_v5.pdf)
   - **DIC_DADOS_NET – Notificação Individual** (arquivo local)

###  Conversão para CSV

Para ingestão no Snowflake, os dados foram convertidos de `.DBF` para `.CSV`:

1. Use o conversor do DataSUS para transformar `.DBC` em `.DBF`.
2. Execute o script Python [`convert_DBF_CVS.py`](ingest/python/convert_DBF_CVS.py) para converter `.DBF` → `.CSV`.
   - Utiliza **pandas** e **simpledbf**
3. O arquivo resultante `ACGRBR24.csv` foi salvo localmente.

###  Ingestão no Snowflake

1. Criação de banco, schema, formato de arquivo e stage interno  
   → [`01_create_stage_and_format.sql`](ingest/sql/01_create_stage_and_format.sql)
2. Upload do CSV para o stage interno (via SnowSQL ou interface)
3. Carga dos dados para a tabela RAW  
   → [`02_copy_into_acidentes_trabalho_raw.sql`](ingest/sql/02_copy_into_acidentes_trabalho_raw.sql)

---

##  Arquitetura da Modelagem

Foi adotado o modelo **Star Schema**, com:

###  Tabela Fato: `fato_acidente_trabalho`

Contém as ocorrências de acidentes, com medidas e chaves substitutas (`id_acidente` via `md5_hex`).  
Campos principais:
- `qtd_trabalhadores_evento`
- `dt_acid`, `cid_acid`, `cid_lesao`
- `sg_uf`, `mun_acid`
- `tipo_acid`, `evolucao`, `cat`

###  Tabelas Dimensão

| Tabela             | Descrição                                 |
|--------------------|--------------------------------------------|
| `dim_tempo`        | Datas dos eventos                         |
| `dim_localidade`   | UF e município do acidente                |
| `dim_sexo`         | Código e descrição do sexo                |
| `dim_raca`         | Raça/cor                                  |
| `dim_tipo_acidente`| Classificação do acidente                 |
| `dim_partes_corpo` | Partes do corpo atingidas                 |
| `dim_evolucao`     | Situação final do caso                    |

---

##  Pipeline no dbt

Dividido em três camadas:

- **Staging (`stg_*`)**  
  Padronização de campos, seleção de atributos relevantes.

- **Intermediate (`int_*`)**  
  Normalização, enriquecimento, exclusão de registros inconsistentes.

- **Mart (`fato_*`, `dim_*`)**  
  Junção com dimensões, geração de chaves substitutas, deduplicação, materialização (`table` para fato, `view` para dimensões).

---

##  Testes Implementados

Utilizando `dbt tests`, `dbt_utils` e `dbt_expectations`:

- **Qualidade de dados**  
  `not_null`, `unique`, `accepted_values`, `expect_column_values_to_be_between`

- **Validação de integridade**  
  Conferência entre códigos da fato e dimensões

---

##  Recursos Avançados do Snowflake

###  Time Travel

Permite consultar objetos em estados anteriores.  
Demo: remoção de 1.000 linhas e comparação de contagem antes/depois.  
→ [`time_travel.sql`](platform/time_travel.sql)

###  Zero-Copy Clone

Clone instantâneo sem duplicação de dados.  
Atenção à durabilidade (`TRANSIENT` vs `PERMANENT`).  
→ [`zero_copy.sql`](platform/zero_copy.sql)

###  Clustering

Definição de chaves de cluster para otimizar filtros e partições.

---

##  Transformação e Modelagem com dbt

Transformação dos dados brutos do DataSUS em modelo dimensional otimizado para análise.  
Permite insights sobre frequência, local, causas e consequências dos acidentes.

---

##  Orquestração e Automação

### Ferramenta: DBT Cloud

- **Job agendado** executa:
  - `dbt source freshness`
  - `dbt build`
  - `dbt docs generate`

### Agendamento

- Frequência: Diária
- Horário: 03:00 AM (BRT)

### Resultado

- Atualização automática das tabelas no schema `mart`
- Testes executados a cada carga
- Documentação disponível via link público do DBT Cloud
