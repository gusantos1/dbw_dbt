{% set columns = ['sku', 'valor', 'tipo'] %}

with source_data as (
    select
        sku,
        valor,
        tipo,
        {% for col in columns %}
            {{ column_has_null(col) }} as {{ col }}_has_null{{ ", " if not loop.last else "" }}
        {% endfor %}
    from {{ source('dbw_eastus', 'tb_sku') }}

)
select *
from source_data
