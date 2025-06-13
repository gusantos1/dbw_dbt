{{ config(
    unique_key='sku'
)}}

select
    sku,
    valor,
    tipo,
    current_timestamp as ingestion_timestamp
from {{ source('neon_federation_dbw', 'tb_sku') }}