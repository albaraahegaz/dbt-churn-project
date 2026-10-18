# Telecom Customer Churn Analysis (dbt)

A dbt project that cleans and transforms telecom customer data to help the business understand which customers are most likely to churn and why they leave.

## Business Question

Which kinds of customers are most likely to leave, and what reasons do they give?

## Data Sources

| Source | Description |
|---|---|
| Customer churn table | Customer demographics, subscription types, charges, and churn status |
| Zip code population table | Population estimates per zip code, used to segment customers by geography |

## Project Structure

```
models/
├── staging/
│   ├── _sources.yml
│   ├── _staging.yml
│   ├── stg_customer_churn.sql
│   └── stg_zipcode_population.sql
├── intermediate/
│   └── int_customers_enriched.sql
└── marts/
    ├── _marts.yml
    ├── rpt_churn_by_dimension.sql
    └── rpt_churn_reasons.sql
```

## Model Layers

**Staging** – one model per source. Cleans column names and data types, with no business logic.
- `stg_customer_churn`
- `stg_zipcode_population`

**Intermediate** – joins the customer data with zip code population and adds derived fields.
- `int_customers_enriched`: customers enriched with a `population_segment` (small: under 10k, medium: 10k-40k, large: 40k+).

**Marts** – reporting tables for analysis.
- `rpt_churn_by_dimension`: churn rate for each customer segment (contract, internet type, payment method, offer, tenure, age, zip size, gender, marital status, paperless billing, etc.). Each row is one dimension and segment, with customer count, churned customers, and churn rate.
- `rpt_churn_reasons`: the reasons customers gave for leaving, grouped by category (Competitor, Dissatisfaction, Attitude, Price, Other), with each reason's share of all churn.

## Data Quality Tests

Tests are defined in the `.yml` files next to the models, and include:
- `unique` and `not_null` on key columns
- `not_null` on dimension, segment, and churn category columns in the reporting models

## How to Run

```bash
dbt build                                  # run all models and tests
dbt build --select +rpt_churn_by_dimension # run one report and its upstream models
dbt docs generate                          # generate documentation
```

## Setup

- **Warehouse:** Snowflake
- **Tool:** dbt Cloud
- Models build into the `DEPI_DB` database, in your development schema.

## Key Findings

_Add 2-3 findings from your reports here, for example which contract type has the highest churn rate and the top churn reason. Check these in Snowflake first:_

```sql
select * from rpt_churn_by_dimension order by churn_rate_pct desc;
select * from rpt_churn_reasons order by pct_of_all_churn desc;
```