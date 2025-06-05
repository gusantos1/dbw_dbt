

select
    DISTINCT
    silver.sku AS SKU_COD,
    depara_sku.sku AS SKU_NAME,
    silver.valor,
    silver.tipo
FROM `dbw_eastus`.`silver`.`tb_sku_silver` AS silver
LEFT JOIN `dbw_eastus`.`silver`.`depara_sku` AS depara_sku
ON silver.sku = depara_sku.sku
WHERE silver.sku IS NOT NULL