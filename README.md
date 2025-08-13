# ACGRBR24 – Acidente de Trabalho | Snowflake + dbt (Bootcamp 2025)

Repositório do desafio final (Tema: **Acidente de Trabalho – ACGRBR24**).  
Pipeline em **Snowflake** com transformações **dbt**, modelagem dimensional (staging → dimensões → fato).  
> O painel em Power BI é opcional e pode ser adicionado depois.

---

## 🧱 Arquitetura (visão geral)

```mermaid
flowchart LR
  A[Raw Data] --> S1[Staging]
  S1 --> D1[Dimensão Local]
  S1 --> D2[Dimensão CBO]
  S1 --> D3[Dimensão CID]
  S1 --> D4[Dimensão Acidente]
  S1 --> D5[Dimensão Pessoa]
  S1 --> D6[Dimensão Empresa]
  S1 --> D7[Dimensão Tempo]
  S1 --> F1[Fato Acidente]
  D1 --> F1
  D2 --> F1
  D3 --> F1
  D4 --> F1
  D5 --> F1
  D6 --> F1
  D7 --> F1
