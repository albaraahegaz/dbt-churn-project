with source as (

    select * from {{ source('telecom', 'telecom_customer_churn') }}

)

select
    customer_id,
    gender,
    age,
    try_to_boolean(married::varchar)                              as is_married,
    number_of_dependents,
    city,
    zip_code,
    latitude,
    longitude,
    number_of_referrals,
    tenure_in_months,
    coalesce(nullif(offer, 'None'), 'No offer')                   as offer,

    try_to_boolean(phone_service::varchar)                        as has_phone_service,
    coalesce(avg_monthly_long_distance_charges, 0)                as avg_monthly_long_distance_charges,
    coalesce(try_to_boolean(multiple_lines::varchar), false)      as has_multiple_lines,

    try_to_boolean(internet_service::varchar)                     as has_internet_service,
    coalesce(nullif(internet_type, 'None'), 'No internet')        as internet_type,
    coalesce(avg_monthly_gb_download, 0)                          as avg_monthly_gb_download,
    coalesce(try_to_boolean(online_security::varchar), false)     as has_online_security,
    coalesce(try_to_boolean(online_backup::varchar), false)       as has_online_backup,
    coalesce(try_to_boolean(device_protection_plan::varchar), false) as has_device_protection,
    coalesce(try_to_boolean(premium_tech_support::varchar), false)   as has_premium_tech_support,
    coalesce(try_to_boolean(streaming_tv::varchar), false)        as has_streaming_tv,
    coalesce(try_to_boolean(streaming_movies::varchar), false)    as has_streaming_movies,
    coalesce(try_to_boolean(streaming_music::varchar), false)     as has_streaming_music,
    coalesce(try_to_boolean(unlimited_data::varchar), false)      as has_unlimited_data,

    contract,
    try_to_boolean(paperless_billing::varchar)                    as has_paperless_billing,
    payment_method,

    monthly_charge,
    (monthly_charge < 0)                                          as has_negative_monthly_charge,
    total_charges,
    total_refunds,
    total_extra_data_charges,
    total_long_distance_charges,
    total_revenue,

    customer_status,
    (customer_status = 'Churned')                                 as is_churned,
    churn_category,
    churn_reason

from source