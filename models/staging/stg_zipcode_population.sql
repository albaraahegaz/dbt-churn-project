select
    zip_code,
    population
from {{ source('telecom', 'telecom_zipcode_population') }}