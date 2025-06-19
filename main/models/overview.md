<!---
Documentado em
https://docs.getdbt.com/docs/build/documentation#setting-a-custom-overview
-->

{% docs __overview__ %}

##### Documentação customizada em: [/models/overview.md](https://github.com/gusantos1/dbw_dbt/blob/main/main/models/overview.md)

# Visão Geral do Projeto

Este projeto dbt realiza o versionamento histórico da tabela SKU com snapshots,
aplica transformações SQL sobre dados brutos e garante qualidade com testes e validações.

## Camadas

- **Bronze**: ingestão inicial (dados crus)
- **Silver**: snapshots e enriquecimentos
- **Gold**: modelos prontos para consumo analítico

## Ferramentas utilizadas

- dbt Core
- Databricks (SQL Warehouse)
- VS Code + dbt Power User
- Poetry + Taskipy

## Time responsável

Engenharia de Dados
{% enddocs %}