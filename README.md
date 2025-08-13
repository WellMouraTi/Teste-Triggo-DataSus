# ACGRBR24 – Acidente de Trabalho | Snowflake + dbt (Bootcamp 2025)

Repositório do desafio final (Tema: **Acidente de Trabalho – ACGRBR24**).  
Pipeline construído em **Snowflake**, com transformações e modelagem dimensional via **dbt**.  
> O painel em Power BI é opcional e pode ser adicionado posteriormente.

---

## 🧱 Arquitetura do Pipeline

Este projeto segue uma arquitetura moderna de dados, dividida em quatro camadas principais:

- **Raw (Snowflake)**: Dados brutos carregados diretamente da fonte.
- **Staging (dbt/views)**: Limpeza e padronização dos dados.
- **Dimensões (dbt/tables)**: Tabelas dimensionais que descrevem os atributos dos acidentes.
- **Mart (dbt/tables)**: Tabela fato que consolida os dados para análise.

```mermaid
flowchart LR
  subgraph RAW[Camada Raw Snowflake]
    A[ACGRBR24]
  end

  subgraph STG[Staging (dbt / views)]
    S1[stg_acidentes_trabalho]
  end

  subgraph DIM[Dimensões (dbt / tables)]
    D1[dim_tempo]
    D2[dim_sexo]
    D3[dim_raca]
    D4[dim_tipo_acidente]
    D5[dim_partes_corpo]
    D6[dim_evolucao]
    D7[dim_localidade]
  end

  subgraph MART[Mart (dbt / tables)]
    F1[fato_acidente_trabalho]
  end

  A --> S1
  S1 --> D1
  S1 --> D2
  S1 --> D3
  S1 --> D4
  S1 --> D5
  S1 --> D6
  S1 --> D7
  S1 --> F1
  D1 --> F1
  D2 --> F1
  D3 --> F1
  D4 --> F1
  D5 --> F1
  D6 --> F1
  D7 --> F1
