with customers as (

    select * from {{ ref('int_customers_enriched') }}

),

segments as (

    select 'Contract' as dimension, contract as segment, is_churned from customers
    union all select 'Internet type', internet_type, is_churned from customers
    union all select 'Payment method', payment_method, is_churned from customers
    union all select 'Last offer', offer, is_churned from customers
    union all select 'Tenure group', tenure_group, is_churned from customers
    union all select 'Age group', age_group, is_churned from customers
    union all select 'Zip population size', population_segment, is_churned from customers
    union all select 'Gender', gender, is_churned from customers
    union all select 'Marital status', case when is_married then 'Married' else 'Not married' end, is_churned from customers
    union all select 'Paperless billing', case when has_paperless_billing then 'Yes' else 'No' end, is_churned from customers
    union all select 'Premium tech support', case when has_premium_tech_support then 'Yes' else 'No' end, is_churned from customers

)

select
    dimension,
    segment,
    count(*)                                                       as customers,
    sum(case when is_churned then 1 else 0 end)                    as churned_customers,
    round(100.0 * sum(case when is_churned then 1 else 0 end)
          / count(*), 1)                                           as churn_rate_pct
from segments
group by dimension, segment