{{ config(
    unique_key='SKU_COD'
)}}

select
    DISTINCT
    silver.sku,
    depara_sku.campanha AS data_campanha,
    silver.valor,
    silver.tipo
FROM {{ ref('tb_sku_silver') }} AS silver
LEFT JOIN {{ ref('depara_sku') }} AS depara_sku
ON silver.sku = depara_sku.sku
ORDER BY
    silver.sku