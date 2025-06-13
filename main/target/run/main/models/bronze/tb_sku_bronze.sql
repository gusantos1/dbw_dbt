-- back compat for old kwarg name
  
  
  
  
  
  
      
          
          
      
  

    merge
    into
        `dbw_eastus`.`bronze`.`tb_sku_bronze` as DBT_INTERNAL_DEST
    using
        `tb_sku_bronze__dbt_tmp` as DBT_INTERNAL_SOURCE
    on
        
              DBT_INTERNAL_SOURCE.sku <=> DBT_INTERNAL_DEST.sku
          
    when matched
        then update set
            *
    when not matched
        then insert
            *

