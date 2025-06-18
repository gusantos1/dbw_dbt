
    
  create or replace table `dbw_eastus`.`silver`.`tb_sku_silver`
  
  (
    
      sku string,
    
      valor decimal(10,2),
    
      tipo string,
    
      ingestion_timestamp timestamp,
    
      valor_has_null int,
    
      tipo_has_null int
    
    
  )

  
  using delta
  
  
  
  
  
  
  

  