{{ config(
   materialized="table"
) }}

SELECT COL0 AS Type, COL1 AS Name, COL2 AS Description, COL3 AS Link, COL4 AS OWNER, COL5 AS IMAGE
FROM {{ source('staging', 'sg_christmas_playlist') }}
QUALIFY ROW_NUMBER() OVER (ORDER BY COL0) > 1


