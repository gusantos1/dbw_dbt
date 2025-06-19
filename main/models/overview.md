<!---
Documentado em
https://docs.getdbt.com/docs/build/documentation#setting-a-custom-overview
-->

{% docs __overview__ %}

##### Documentação customizada em: [/models/overview.md](http://localhost:8080/#!/overview/main)

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