{{ config(materialized='table') }}

WITH taxi_trip AS (
  SELECT 
      * EXCEPT(VendorID, store_and_fwd_flag, RatecodeID, passenger_count, 
      ehail_fee, payment_type, trip_type, congestion_surcharge), 
      IFNULL(VendorID, 0) AS VendorID, 
      IFNULL(store_and_fwd_flag, 'N') AS store_and_fwd_flag, 
      IFNULL(RatecodeID, 0) AS RatecodeID, 
      IFNULL(passenger_count, 0) AS passenger_count, 
      IFNULL(ehail_fee, 0) AS ehail_fee, 
      IFNULL(payment_type, 0) AS payment_type, 
      IFNULL(trip_type, 0) AS trip_type, 
      IFNULL(congestion_surcharge, 0) AS congestion_surcharge 
FROM {{ source('taxi_nyc', 'taxi_tripdata') }} 
), clean_taxi AS  (
  SELECT * EXCEPT(store_and_fwd_flag), 
      store_and_fwd_flag = 'Y' as store_and_fwd_flag 
FROM taxi_trip 
) SELECT 
        VendorID AS vendor_id, lpep_pickup_datetime AS pickup_datetime, lpep_dropoff_datetime AS dropoff_datetime, 
        store_and_fwd_flag AS store_forward_flag, RatecodeID AS rate_code_id, PULocationID AS pickup_loc_id, 
        DOLocationID AS dropoff_loc_id, passenger_count, trip_distance, 
        {{ trip_duration('lpep_dropoff_datetime', 'lpep_pickup_datetime', 'second' )}} AS trip_durat_sec,
        fare_amount, extra, mta_tax, tip_amount, 
        tolls_amount, ehail_fee, improvement_surcharge, total_amount, payment_type, trip_type, 
        congestion_surcharge, 
        {{ addition('total_amount', 'improvement_surcharge', 'congestion_surcharge') }} AS total_transac
FROM clean_taxi WHERE EXTRACT(YEAR FROM lpep_pickup_datetime) = 2021