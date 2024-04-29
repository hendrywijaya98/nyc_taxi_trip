{% macro trip_duration(end_datetime, start_datetime, part_of_time) %}
    TIMESTAMP_DIFF({{ end_datetime }}, {{ start_datetime }}, {{part_of_time}})
{% endmacro %}