




    with grouped_expression as (
    select
        
        
    
  


    

    

length(regexp_extract(TIPO, '^[A-Za-z]{1}$', 0))


 > 0
 as expression


    from `psql_neon`.`raw`.`tb_sku`
    

),
validation_errors as (

    select
        *
    from
        grouped_expression
    where
        not(expression = true)

)

select *
from validation_errors




