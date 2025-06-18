{{ config(
    unique_key='sku'
)}}

{% set meses = {
    "Janeiro": "January",
    "Fevereiro": "February",
    "Março": "March",
    "Abril": "April",
    "Maio": "May",
    "Junho": "June",
    "Julho": "July",
    "Agosto": "August",
    "Setembro": "September",
    "Outubro": "October",
    "Novembro": "November",
    "Dezembro": "December"
} %}

select
    DISTINCT
    silver.sku,
    depara_sku.campanha AS nome_campanha,
    to_date(
        case
            {% for pt, en in meses.items() %}
                when split(depara_sku.campanha, ' ', -1)[1] like '{{ pt }}/%' then
                    replace(split(depara_sku.campanha, ' ', -1)[1], '{{ pt }}', '{{ en }}')
            {% endfor %}
            else null
        end,
        'MMMM/yy'
    ) data_campanha,
    silver.valor,
    silver.tipo
FROM {{ ref('tb_sku_silver') }} AS silver
LEFT JOIN {{ ref('depara_sku') }} AS depara_sku
ON silver.sku = depara_sku.sku
ORDER BY
    silver.sku