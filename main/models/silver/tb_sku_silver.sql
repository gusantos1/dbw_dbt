{% set columns = ['sku', 'valor', 'tipo'] %}

with source_data as (
    select
        DISTINCT
        sku,
        valor,
        coalesce(replace(TIPO, '-'), '') tipo,
        ingestion_timestamp
    from {{ ref('tb_sku_bronze') }}

)
select 
    *,
    {% for col in columns %}
            {{ column_has_null(col) }} as {{ col }}_has_null{{ ", " if not loop.last else "" }}
    {% endfor %}
from source_data
