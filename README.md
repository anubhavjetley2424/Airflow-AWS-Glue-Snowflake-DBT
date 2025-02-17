# Airflow - AWS Glue - Snowflake - DBT

# Project Setup:
## Snowflake Setup
- Create Snowflake account (you can try with the free tier) and make sure to choose AWS as your cloud integration
- Create new dataset within the PUBLIC schema
- create tables for sg_christmas_playlist, sg_christmas_movies, sg_christmas_sales, sg_christmas_weather in CHRISTMAS_DATA database and PUBLIC schema
- Run ```SELECT SYSTEM$ALLOWLIST();``` in Snowflake SQL Notebook, get private link to get hostname and port for snowflake (reference) to connect your snowflake with your AWS Glue ETL later

# AWS Setup
- Create IAM ROLE in AWS for AWS for secret manager, s3 and AWS Glue
- Create AWS Secret Manager for snowflake credentials. Choose Other type of secret and fill this key with :
   'KEY = sfUser, Value = your snowflake login username'
   'KEY = sfPassword, Value = your snowflake login password'

- Create S3 bucket name it as 'christmas-project-data'
- Create AWS Glue Crawler and AWS Glue Data Catalog, connect crawler to s3 bucket that data is stored in.
- Create a Snowflake connection in Data Catalog, entering the hostname and port number identified within the 'SELECT SYSTEM$ALLOWLIST();' command
- Create ETL JOBs in AWS Glue and connect data from source AWS Data Catalog (Source) to Snoflake (Target) to pass data tables

# Docker Setup
Within the docker-compose.yml, enter the required credentials :
- SPOTIFY_CLIENT_ID: <SPOTIFY CLIENT ID>
- SPOTIFY_CLIENT_SECRET: <SPOTIFY CLIENT SECRET>
- WEATHER_API_KEY: <WEATHER API KEY>
- AWS_REGION_NAME: <AWS REGION NAME>
- AWS_SECRET_ACCESS_KEY: <AWS SECRET ACCESS KEY>
- AWS_ACCESS_KEY_ID: <AWS ACCESS KEY ID>

# DBT Setup
Change some variable with your snowflake database configuration in dbt_transform/profiles.yml
```
dbt_transform:
  outputs:
    dev:
      account: <your account>
      database: <your database>
      password: <your snowflake password>
      role: <your snowflake role>
      schema: <your snowflake schema>
      threads: 1
      type: snowflake
      user: <your snowflake username>
      warehouse: <your snowflake warehouse name>
  target: dev
```

# Running Architecture
1. 'docker-compose up --build -d'
2. Create and run AWS Glue Crawler and Data Catalog, add Snowflake credentials and create connection
3. Create and run AWS Glue ETL Job for each table
4. Run DBT using this command :
    - cd dbt_transform
    - docker build -t dbt-docker -f dbt-dockerfile .
    - docker run dbt-docker dbt run
