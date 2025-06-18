
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    SKU as unique_field,
    count(*) as n_records

from `dbw_eastus`.`silver`.`tb_sku_silver`
where SKU is not null
group by SKU
having count(*) > 1



  
  
      
    ) dbt_internal_test