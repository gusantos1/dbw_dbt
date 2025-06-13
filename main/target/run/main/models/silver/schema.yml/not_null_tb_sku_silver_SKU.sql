
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select SKU
from `dbw_eastus`.`silver`.`tb_sku_silver`
where SKU is null



  
  
      
    ) dbt_internal_test