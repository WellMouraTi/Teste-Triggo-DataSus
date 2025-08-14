#  ACGRBR24 – Acidente de Trabalho | Snowflake + dbt (Bootcamp 2025)

Repositório do desafio final (Tema: **Acidente de Trabalho – ACGRBR24**)  
Pipeline construído em **Snowflake**, com transformações e modelagem dimensional via **dbt**

---

##  Coleta e Ingestão de Dados (DataSUS)

Nesta etapa, foi realizada a coleta, preparação e ingestão dos dados do **SINAN – ACGRBR (Acidente de Trabalho Grave)** – ano de 2024 no **Snowflake**, seguindo boas práticas de pipeline de dados e simulando um *data lake* na camada de **stage interno**.

###  Coleta dos dados

1. Acessar o portal do **SINAN – DataSUS** e realizar o download do conjunto de dados **ACGRBR – 2024**  
2. Baixar também os **arquivos auxiliares para tabulação**, que contêm:
   - Conversor de arquivos `.DBC` para `.DBF`
   - Dicionários de dados e layouts para interpretação dos campos
3. Documentação utilizada:
   - [Dicionário de Dados – Acidente de Trabalho Grave (DRT)](https://portalsinan.saude.gov.br/images/documentos/Agravos/DRT%20Acidente%20Trabalho%20Grave/DIC_DADOS_DRT_Acidente_Trabalho_grave_v5.pdf)
   - **DIC_DADOS_NET – Notificação Individual** (arquivo local)

###  Conversão para CSV

Para permitir a leitura dos dados no Snowflake, foi necessário converter o formato original (`.DBF`) para `.CSV`:

1. Utilizar o conversor do DataSUS para transformar `.DBC` em `.DBF`
2. Executar o script Python [`convert_DBF_CVS.py`](ingest/python/convert_DBF_CVS.py) com **pandas** e **simpledbf**
3. O arquivo resultante `ACGRBR24.csv` foi salvo localmente

###  Ingestão no Snowflake

1. Criação de banco, schema, formato de arquivo e stage interno  
   → [`01_create_stage_and_format.sql`](ingest/sql/01_create_stage_and_format.sql)
2. Upload do CSV para o stage interno (via SnowSQL ou interface)
3. Carga dos dados para a tabela RAW  
   → [`02_copy_into_acidentes_trabalho_raw.sql`](ingest/sql/02_copy_into_acidentes_trabalho_raw.sql)  
   → [`03_copy_into_acidentes_trabalho_raw.sql`](ingest/sql/03_copy_into_acidentes_trabalho_raw.sql)

---

##  Arquitetura da Modelagem

Foi adotada a modelagem **Star Schema**:

###  Tabela Fato: `fato_acidente_trabalho`

Contém as ocorrências de acidentes de trabalho, com chaves substitutas (`id_acidente` via `md5_hex`) e medidas como:

- `qtd_trabalhadores_evento`
- `dt_acid`, `cid_acid`, `cid_lesao`
- `sg_uf`, `mun_acid`
- `tipo_acid`, `evolucao`, `cat`

###  Tabelas Dimensão

- `dim_tempo` — Datas dos eventos
- `dim_localidade` — UF e município do acidente
- `dim_sexo` — Código e descrição do sexo
- `dim_raca` — Raça/cor
- `dim_tipo_acidente` — Classificação do acidente
- `dim_partes_corpo` — Partes do corpo atingidas
- `dim_evolucao` — Situação final do caso

---

##  Pipeline no dbt

Modelagem dividida em três camadas:

- **Staging (`stg_*`)**  
  Padronização de campos (datas com `try_to_date`, códigos em uppercase, `trim`)  
  Seleção de campos relevantes  
  Fonte: `source('raw', 'acidentes_trabalho_raw')`

- **Intermediate (`int_*`)**  
  Normalização, enriquecimento, exclusão de registros inconsistentes

- **Mart (`fato_*`, `dim_*`)**  
  Junção com dimensões  
  Geração de chaves substitutas (`md5_hex`)  
  Deduplicação com `row_number()`  
  Materialização: `table` para fato, `view` para dimensões

---

##  Testes Implementados

Utilizando `dbt tests`, `dbt_utils` e `dbt_expectations`:

- **Qualidade de dados**
  - `not_null` para campos obrigatórios
  - `unique` para chaves substitutas
  - `accepted_values` conforme dicionário DataSUS
  - `expect_column_values_to_be_between` para validar intervalos de datas

- **Validação de integridade**
  - Conferência entre códigos do fato e dimensões

---

##  Recursos Avançados do Snowflake

###  Time Travel

Consulta de objetos como estavam em ponto anterior no tempo  
Demo:
- Cópia de `fato_acidente_trabalho` → `TT_DEMO`
- Registro de timestamp “ANTES”
- Remoção de 1.000 linhas
- Comparação de contagem AGORA vs ANTES  
→ [`time_travel.sql`](platform/time_travel.sql)

###  Zero-Copy Clone

Clone instantâneo sem duplicação de dados  
Atenção: se origem é `TRANSIENT`, clone também deve ser `TRANSIENT`  
→ [`zero_copy.sql`](platform/zero_copy.sql)

###  Clustering

Definição de chaves de cluster para otimizar filtros e partições

---

##  Transformação e Modelagem com dbt

Transformação dos dados brutos do DataSUS em modelo dimensional otimizado para análise  
Permite insights sobre frequência, local, causas e consequências dos acidentes

---

##  Orquestração e Automação

### Ferramenta: DBT Cloud

Orquestração via job agendado para execução automática da pipeline

#### Comandos executados

- `dbt source freshness` — Verifica atualização das tabelas fonte
- `dbt build` — Executa modelos e testes
- `dbt docs generate` — Gera documentação dos modelos e testes

#### Agendamento

- Frequência: Diária
- Horário: 03:00 AM (BRT)

#### Resultado

- Atualização automática das tabelas no schema `mart`
- Testes executados a cada carga
- Documentação disponível via link público do DBT Cloud
