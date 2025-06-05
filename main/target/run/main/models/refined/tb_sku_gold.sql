-- back compat for old kwarg name
  
  
  
  
  
  
      
          
          
      
  

    merge
    into
        `dbw_eastus`.`gold`.`tb_sku_gold` as DBT_INTERNAL_DEST
    using
        `tb_sku_gold__dbt_tmp` as DBT_INTERNAL_SOURCE
    on
        
              DBT_INTERNAL_SOURCE.SKU_COD <=> DBT_INTERNAL_DEST.SKU_COD
          
    when matched
        then update set
            *
    when not matched
        then insert
            *

