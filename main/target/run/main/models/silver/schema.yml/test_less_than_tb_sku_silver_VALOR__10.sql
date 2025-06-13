
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    select
        *
    from `dbw_eastus`.`silver`.`tb_sku_silver`
    where VALOR > 10

  
  
      
    ) dbt_internal_test