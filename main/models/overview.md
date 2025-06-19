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


<!--- dbt_utils -->
{% docs __dbt_utils__ %}
# Macros utilitárias
Este projeto dbt utiliza amplamente este conjunto de macros utilitárias, em especial:
- `surrogate_key` para criação de chaves substitutas
- `test_equality` para comparar modelos
- `pivot` para transposição de colunas em linhas


👉 [Documentação oficial](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/)
{% enddocs %}


<!--- dbt_spark -->
{% docs __dbt_spark__ %}
# Integração com Spark
Este pacote oferece compatibilidade entre o dbt e o Apache Spark, permitindo que as transformações sejam executadas em clusters Spark ou Databricks.

👉 [Documentação oficial](https://docs.getdbt.com/docs/core/connect-data-platform/spark-setup)
{% enddocs %}


<!--- dbt_date -->
{% docs __dbt_date__ %}
# Manipulação de datas
Este pacote fornece macros para facilitar o trabalho com datas em SQL, como:
- Geração de calendários (`dbt_date.get_date_dimension`)
- Criação de períodos (`week`, `month`, `quarter`, etc.)
- Conversões e comparações entre datas

👉 [Documentação oficial](https://github.com/calogica/dbt-date)
{% enddocs %}


<!--- dbt_expectations -->
{% docs __dbt_expectations__ %}
# Testes inspirados no Great Expectations
Este pacote permite escrever testes de dados mais descritivos e flexíveis. Ideal para garantir qualidade de dados além dos testes padrão do dbt.

👉 [Documentação oficial](https://hub.getdbt.com/metaplane/dbt_expectations/latest/)
{% enddocs %}
