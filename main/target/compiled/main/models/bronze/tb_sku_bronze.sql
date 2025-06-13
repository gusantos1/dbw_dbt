

select
    sku,
    valor,
    tipo,
    current_timestamp as ingestion_timestamp
from `psql_neon`.`raw`.`tb_sku`