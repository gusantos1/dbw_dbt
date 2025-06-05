{% macro column_has_null(column_name) %}
    (case when {{ column_name }} is null then 1 else 0 end)
{% endmacro %}
