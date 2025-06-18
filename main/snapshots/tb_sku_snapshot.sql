-- Similar ao Change Data Feed do Databricks, o dbt snapshot permite capturar alterações em tabelas ao longo do tempo. 
{% snapshot tb_sku_snapshot %}
    {{
        config(
            target_schema='silver',
            unique_key='sku',
            strategy='check',
            check_cols=['valor', 'tipo']
        )
    }}
    
    select
        sku,
        valor,
        tipo
    from {{ ref('tb_sku_bronze') }}
    
    {% endsnapshot %}
