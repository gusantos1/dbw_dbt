

with source_data as (
    select
        sku,
        valor,
        tipo,
        
            
    (case when sku is null then 1 else 0 end)
 as sku_has_null, 
        
            
    (case when valor is null then 1 else 0 end)
 as valor_has_null, 
        
            
    (case when tipo is null then 1 else 0 end)
 as tipo_has_null
        
    from `dbw_eastus`.`bronze`.`tb_sku`

)
select *
from source_data