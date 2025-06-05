{{ config(
    unique_key='SKU_COD'
)}}

select
    silver.sku AS SKU_COD,
    depara_sku.sku AS SKU_NAME,
    silver.valor,
    silver.tipo
FROM {{ ref('tb_sku_silver') }} AS silver
LEFT JOIN {{ ref('depara_sku') }} AS depara_sku
ON silver.sku = depara_sku.sku
WHERE silver.SKU_COD IS NOT NULL