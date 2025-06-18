
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select VALOR
from `psql_neon`.`raw`.`tb_sku`
where VALOR is null



  
  
      
    ) dbt_internal_test