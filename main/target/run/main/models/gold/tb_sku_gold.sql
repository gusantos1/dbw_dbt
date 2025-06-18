
      
  
  
  create or replace view `dbw_eastus`.`gold`.`tb_sku_gold`
  
  as (
    select
    DISTINCT
    silver.sku,
    depara_sku.campanha AS nome_campanha,
    to_date(
        case
            
                when split(depara_sku.campanha, ' ', -1)[1] like 'Janeiro/%' then
                    replace(split(depara_sku.campanha, ' ', -1)[1], 'Janeiro', 'January')
            
                when split(depara_sku.campanha, ' ', -1)[1] like 'Fevereiro/%' then
                    replace(split(depara_sku.campanha, ' ', -1)[1], 'Fevereiro', 'February')
            
                when split(depara_sku.campanha, ' ', -1)[1] like 'Março/%' then
                    replace(split(depara_sku.campanha, ' ', -1)[1], 'Março', 'March')
            
                when split(depara_sku.campanha, ' ', -1)[1] like 'Abril/%' then
                    replace(split(depara_sku.campanha, ' ', -1)[1], 'Abril', 'April')
            
                when split(depara_sku.campanha, ' ', -1)[1] like 'Maio/%' then
                    replace(split(depara_sku.campanha, ' ', -1)[1], 'Maio', 'May')
            
                when split(depara_sku.campanha, ' ', -1)[1] like 'Junho/%' then
                    replace(split(depara_sku.campanha, ' ', -1)[1], 'Junho', 'June')
            
                when split(depara_sku.campanha, ' ', -1)[1] like 'Julho/%' then
                    replace(split(depara_sku.campanha, ' ', -1)[1], 'Julho', 'July')
            
                when split(depara_sku.campanha, ' ', -1)[1] like 'Agosto/%' then
                    replace(split(depara_sku.campanha, ' ', -1)[1], 'Agosto', 'August')
            
                when split(depara_sku.campanha, ' ', -1)[1] like 'Setembro/%' then
                    replace(split(depara_sku.campanha, ' ', -1)[1], 'Setembro', 'September')
            
                when split(depara_sku.campanha, ' ', -1)[1] like 'Outubro/%' then
                    replace(split(depara_sku.campanha, ' ', -1)[1], 'Outubro', 'October')
            
                when split(depara_sku.campanha, ' ', -1)[1] like 'Novembro/%' then
                    replace(split(depara_sku.campanha, ' ', -1)[1], 'Novembro', 'November')
            
                when split(depara_sku.campanha, ' ', -1)[1] like 'Dezembro/%' then
                    replace(split(depara_sku.campanha, ' ', -1)[1], 'Dezembro', 'December')
            
            else null
        end,
        'MMMM/yy'
    ) data_campanha,
    silver.valor,
    silver.tipo
FROM `dbw_eastus`.`silver`.`tb_sku_silver` AS silver
LEFT JOIN `dbw_eastus`.`silver`.`tb_sku_seed` AS depara_sku
ON silver.sku = depara_sku.sku
ORDER BY
    silver.sku
  )


    