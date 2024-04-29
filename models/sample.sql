{{ config(materialized='table') }}

SELECT *
FROM {{ source('taxi_nyc','taxi_tripdata') }}