{{ config(
   materialized="table"
) }}

SELECT 
    * EXCLUDE(Votes),
    CAST(
        CASE 
            WHEN votes = '' THEN '0' 
            ELSE REPLACE(votes, ',', '') 
        END AS NUMBER
    ) AS Votes
FROM {{ source('staging', 'sg_christmas_movies') }}