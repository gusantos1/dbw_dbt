

select
    DISTINCT
    silver.sku,
    depara_sku.campanha AS data_campanha,
    silver.valor,
    silver.tipo
FROM `dbw_eastus`.`silver`.`tb_sku_silver` AS silver
LEFT JOIN `dbw_eastus`.`silver`.`tb_sku_seed` AS depara_sku
ON silver.sku = depara_sku.sku
ORDER BY
    silver.sku