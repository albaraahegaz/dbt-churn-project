with customers as (

    select * from {{ ref('stg_customer_churn') }}

),

population as (

    select * from {{ ref('stg_zipcode_population') }}

)

select
    c.*,
    p.population as zip_population,

    case
        when p.population < 10000 then 'Small zip (under 10k)'
        when p.population < 40000 then 'Medium zip (10k-40k)'
        else 'Large zip (40k+)'
    end as population_segment,

    case
        when c.tenure_in_months <= 12 then '0-12 months'
        when c.tenure_in_months <= 24 then '13-24 months'
        when c.tenure_in_months <= 48 then '25-48 months'
        else '49+ months'
    end as tenure_group,

    case
        when c.age < 30 then 'Under 30'
        when c.age < 50 then '30-49'
        when c.age < 65 then '50-64'
        else '65+'
    end as age_group

from customers c
left join population p
    on c.zip_code = p.zip_code