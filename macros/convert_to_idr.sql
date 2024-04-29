{% macro convert_to_idr(transaction_col, curr_val = 16241.5) %}
    SAFE_MULTIPLY({{ transaction_col }}, {{ curr_val }})
{% endmacro %}