-- Compilado e documentado, mas não executado por dbt run.
with topfour as (
    select
        sku,
        valor
    from `dbw_eastus`.`gold`.`tb_sku_gold`
    where valor is not null
    order by valor desc
    limit 4
)
select
    sku,
    valor
from topfour