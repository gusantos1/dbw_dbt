

with source_data as (
    select
        DISTINCT
        sku,
        valor,
        coalesce(replace(TIPO, '-'), '') tipo,
        ingestion_timestamp
    from `dbw_eastus`.`bronze`.`tb_sku_bronze`

)
select 
    *,
    
            
    (case when sku is null then 1 else 0 end)
 as sku_has_null, 
    
            
    (case when valor is null then 1 else 0 end)
 as valor_has_null, 
    
            
    (case when tipo is null then 1 else 0 end)
 as tipo_has_null
    
from source_data