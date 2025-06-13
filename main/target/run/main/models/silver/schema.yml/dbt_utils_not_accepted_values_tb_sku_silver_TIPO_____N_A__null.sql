
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
with all_values as (

    select distinct
        TIPO as value_field

    from `dbw_eastus`.`silver`.`tb_sku_silver`

),

validation_errors as (

    select
        value_field

    from all_values
    where value_field in (
        '-','N/A','null'
        )

)

select *
from validation_errors


  
  
      
    ) dbt_internal_test