select
    churn_category,
    churn_reason,
    count(*)                                              as churned_customers,
    round(100.0 * count(*) / sum(count(*)) over (), 1)    as pct_of_all_churn,
    round(avg(tenure_in_months), 1)                       as avg_tenure_months,
    round(avg(monthly_charge), 2)                         as avg_monthly_charge
from {{ ref('int_customers_enriched') }}
where is_churned
group by churn_category, churn_reason