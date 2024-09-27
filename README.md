Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

## Project Documentations
- Data Cleaning on Null Columns on [taxitrip data cleaning](https://github.com/hendrywijaya98/nyc_taxi_trip/blob/main/models/taxitrip_clean.sql)
  ```
  EXCEPT(VendorID, store_and_fwd_flag, RatecodeID, passenger_count,
          ehail_fee, payment_type, trip_type, congestion_surcharge), 
  IFNULL(VendorID, 0) AS VendorID, 
  IFNULL(store_and_fwd_flag, 'N') AS store_and_fwd_flag, 
  IFNULL(RatecodeID, 0) AS RatecodeID, 
  IFNULL(passenger_count, 0) AS passenger_count, 
  IFNULL(ehail_fee, 0) AS ehail_fee, 
  IFNULL(payment_type, 0) AS payment_type, 
  IFNULL(trip_type, 0) AS trip_type, 
  IFNULL(congestion_surcharge, 0) AS congestion_surcharge
  ```
- ganti value store_and_fwd_flag jadi boolean [taxitrip data cleaning](https://github.com/hendrywijaya98/nyc_taxi_trip/blob/main/models/taxitrip_clean.sql)   
  ```
  store_and_fwd_flag = 'Y' AS store_and_fwd_flag
  ```
- Macros used for additions between `total_amount`, `congesion_surcharge` and `improvement_surcharge`
  ```
  {% macro addition(amount, charge1, charge2) %}
    {{ amount }} + {{ charge1 }} + {{ charge2 }}
  {% endmacro %}
  ```
- Macros used for distance calculation
  ```
  {% macro trip_duration(end_datetime, start_datetime, part_of_time) %}
    TIMESTAMP_DIFF({{ end_datetime }}, {{ start_datetime }}, {{part_of_time}})
  {% endmacro %}
  ```
- CHALLANGE ACCEPTED ON [CURRENCY CONVERSION TO IDR](https://www.investing.com/currencies/usd-idr-historical-data) ON `taxitrip_activity.sql`
  ```
  SAFE_MULTIPLY(ROUND(SUM(fare_amount),2),16241.5) AS total_fare_idr, 
  SAFE_MULTIPLY(ROUND(SUM(extra),2),16241.5)  AS total_extra_idr, 
  SAFE_MULTIPLY(ROUND(SUM(mta_tax),2),16241.5)  AS total_mtatax_idr, 
  SAFE_MULTIPLY(ROUND(SUM(tip_amount),2),16241.5)  AS total_tip_idr, 
  SAFE_MULTIPLY(ROUND(SUM(tolls_amount),2),16241.5)  AS total_tolls_idr, 
  SAFE_MULTIPLY(ROUND(SUM(improvement_surcharge),2),16241.5)  AS total_impro_suchar_idr, 
  SAFE_MULTIPLY(ROUND(SUM(total_amount),2),16241.5)  AS total_amount_idr, 
  SAFE_MULTIPLY(ROUND(SUM(congestion_surcharge),2),16241.5)  AS total_congest_suchar_idr, 
  SAFE_MULTIPLY(ROUND(SUM(total_transac),2),16241.5)  AS total_transac_idr
  ```
- Testing on for `sources\taxi_nyc.yml` for raw data and cleaning and summarized data `schema.yml` with `dbt_utils` on `dbt_packages`
### Data Visualizations and Insight
- Monthly total passengers
  ```
  SELECT year, month, SUM(total_passenger) as total_passanger
  FROM `rapid-bricolage-344711.taxi_nyc.taxitrip_activity`
  GROUP BY year, month
  ```
  ![](https://github.com/hendrywijaya98/nyc_taxi_trip/blob/main/document_images/monthly_passanger_query.PNG)
  ![](https://github.com/hendrywijaya98/nyc_taxi_trip/blob/main/document_images/monthly_passanger_chart.PNG)
- Monthly transactions per payment type
  ```
  SELECT year, month, payment_type, SUM(total_transac_idr) as total_transact_idr
  FROM `rapid-bricolage-344711.taxi_nyc.taxitrip_activity`
  GROUP BY year, month, payment_type
  ```
  ![](https://github.com/hendrywijaya98/nyc_taxi_trip/blob/main/document_images/monthly_transact_query.PNG)
  ![](https://github.com/hendrywijaya98/nyc_taxi_trip/blob/main/document_images/monthly_trip_by_ratecode.PNG)
- Monthly trip distance per rate code
  ```
  SELECT year, month, rate_code_id, SUM(total_trip) as total_tripdist
  FROM `rapid-bricolage-344711.taxi_nyc.taxitrip_activity`
  GROUP BY year, month, rate_code_id
  ```
  ![](https://github.com/hendrywijaya98/nyc_taxi_trip/blob/main/document_images/monthly_tripdist_query.PNG)
  ![](https://github.com/hendrywijaya98/nyc_taxi_trip/blob/main/document_images/transact_by_payments.PNG)

check on my visualization on [NYC Taxi Trip report](https://lookerstudio.google.com/s/pt8Qw7h604M)

  
