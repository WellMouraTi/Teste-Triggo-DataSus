# ACGRBR24 – Acidente de Trabalho | Snowflake + dbt (Bootcamp 2025)

Repositório do desafio final (Tema: **Acidente de Trabalho – ACGRBR24**).  
Pipeline em **Snowflake** com transformações **dbt** seguindo modelagem dimensional (staging → dimensões → fato).  
Power BI será adicionado depois (opcional).

## 🧱 Arquitetura (visão geral)

```mermaid
flowchart LR
  subgraph Raw[Camada Raw (Snowflake)]
    A[ACGRBR24] 
  end
  subgraph STG[Staging (dbt • views)]
    S1[stg_acidentes_trabalho]
  end
  subgraph DIM[Dimensões (dbt • tables)]
    D1[dim_tempo]
    D2[dim_sexo]
    D3[dim_raca]
    D4[dim_tipo_acidente]
    D5[dim_partes_corpo]
    D6[dim_evolucao]
    D7[dim_localidade]
  end
  subgraph FATO[Mart (dbt • tables)]
    F1[fato_acidente_trabalho]
  end

  A --> S1
  S1 --> D1 & D2 & D3 & D4 & D5 & D6 & D7
  S1 --> F1
  D1 & D2 & D3 & D4 & D5 & D6 & D7 --> F1
