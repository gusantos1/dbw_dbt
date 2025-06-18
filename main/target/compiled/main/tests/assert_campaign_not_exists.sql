-- Campanhas futuras não podem existir com valor
select 
    *
from `dbw_eastus`.`gold`.`tb_sku_gold` as gold
where 1=1
AND data_campanha > current_date()
AND valor is not null