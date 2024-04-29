{{ config(materialized="table") }}

SELECT EXTRACT(YEAR from pickup_datetime) AS year, EXTRACT(MONTH from pickup_datetime) AS month, 
        rate_code_id, trip_type, payment_type, vendor_id, 
        ROUND(SUM(trip_distance),2)as total_trip,
        ROUND(SUM(trip_durat_sec),2)as total_durat_sec,  
        SUM(passenger_count) AS total_passenger, 
        SAFE_MULTIPLY(ROUND(SUM(fare_amount),2),16241.5) AS total_fare_idr, 
        SAFE_MULTIPLY(ROUND(SUM(extra),2),16241.5)  AS total_extra_idr, 
        SAFE_MULTIPLY(ROUND(SUM(mta_tax),2),16241.5)  AS total_mtatax_idr, 
        SAFE_MULTIPLY(ROUND(SUM(tip_amount),2),16241.5)  AS total_tip_idr, 
        SAFE_MULTIPLY(ROUND(SUM(tolls_amount),2),16241.5)  AS total_tolls_idr, 
        SAFE_MULTIPLY(ROUND(SUM(improvement_surcharge),2),16241.5)  AS total_impro_suchar_idr, 
        SAFE_MULTIPLY(ROUND(SUM(total_amount),2),16241.5)  AS total_amount_idr, 
        SAFE_MULTIPLY(ROUND(SUM(congestion_surcharge),2),16241.5)  AS total_congest_suchar_idr, 
        SAFE_MULTIPLY(ROUND(SUM(total_transac),2),16241.5)  AS total_transac_idr
FROM {{ source('taxi_nyc', 'taxitrip_clean') }} 
GROUP BY EXTRACT(YEAR from pickup_datetime), EXTRACT(MONTH from pickup_datetime), 
rate_code_id, trip_type, payment_type, vendor_id

