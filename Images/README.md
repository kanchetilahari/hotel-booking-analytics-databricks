### Hotel Booking Analytics Platform: Medallion Architecture with Lakeflow Spark Declarative Pipelines

An end-to-end Hotel Booking Analytics data engineering project built on Databricks using Lakeflow Spark Declarative Pipelines (SQL) and Medallion Architecture (Bronze → Silver → Gold).This project transforms raw hotel booking CSV data into structured, analytics-ready datasets through data ingestion, cleaning, validation, transformation and business reporting. It also includes data-quality tracking, record reconciliation and an interactive Databricks AI/BI dashboard.

## Table of Contents
1.Business Problem

2.Objectives

3.Project Architecture

4.Tech Stack

5.Dataset

6.Repository Structure

7.Layer Details

8.Dashboard

9.How to Run

10.Key Learnings

11.Future Improvements


## 1. Business Problem
A hotel group manages bookings across multiple hotels and cities. However, raw booking data contains several quality issues, including inconsistent text formatting, missing values, duplicate bookings, invalid stay dates and negative room rates.
These problems make it difficult for business managers to generate reliable reports about hotel performance, booking trends, revenue, room types and payment methods.
Goal: Build a repeatable data engineering pipeline that preserves the original booking data, cleans and validates records, creates business-ready Gold tables and provides insights through an interactive dashboard.

## 2.Objectives
- Build a data pipeline to process raw hotel booking data.
- Clean data and remove duplicate records.
- Identify and separate invalid records.
- Create analytical datasets for business insights.
- Visualize booking information through an interactive dashboard.

## 3.Project Architecture – Medallion Architecture
Your Hotel Booking Analytics project uses Medallion Architecture, which has three layers: Bronze, Silver, and Gold.
# 1. Bronze Layer – Raw Data
- The Bronze layer is the first layer of the data pipeline.
- It collects raw hotel booking data from the CSV file.
- The original data is stored in Databricks without major transformations.
- It acts as the starting point for further processing.
In simple words: Bronze stores the original hotel booking data.
# 2. Silver Layer – Cleaned Data
- The Silver layer processes the data received from the Bronze layer.
- It removes duplicate booking records.
- It cleans and standardizes data.
- It identifies invalid records and separates them into a rejected table.
- It prepares reliable data for analysis.
In simple words: Silver cleans the raw data and makes it ready for analysis.
# 3. Gold Layer – Business-Ready Data
- The Gold layer receives cleaned data from the Silver layer.
- It creates analytical summary tables.
- It provides insights into hotel revenue, city performance, booking trends, and payment analysis.
- These tables are used for business reporting and dashboards.

## 4. Tech Stack
Azure Databricks

Lakeflow Spark Declarative Pipelines

Databricks SQL

Unity Catalog

Unity Catalog Volumes

Delta Lake

Databricks AI/BI Dashboards

Genie Code

Medallion Architecture

## 5. Dataset

Dataset: hotel_bookings_raw.csv

Dataset Type: Synthetic Hotel Booking Dataset

Records: 1,316 rows

Columns: 20 source columns

The dataset contains hotel booking information covering booking dates, check-in and check-out dates, hotel details, guest information, room types, booking channels, room rates, discounts, payment details and booking status.

## 6. Repository Structure

hotel-booking-analytics-databricks/
│
├── README.md
│
├── ETL_Pipeline/
│   │
│   ├── bronze_hotel_bookings_layer/
│   │   └── Bronze_transformations/
│   │       └── bronze_hotel_bookings.sql
│   │
│   ├── silver_hotel_bookings_layer/
│   │   └── Silver_transformations/
│   │       └── silver_bookings.sql
│   │
│   └── gold_hotel_bookings_layer/
│       └── Gold_transformations/
│           └── gold_booking_analytics.sql
│
├── Images/
│   ├── architecture.png
│   ├── bronze_pipeline.png
│   ├── silver_pipeline.png
│   ├── gold_pipeline.png
│   └── hotel_booking_dashboard.png
│
├── data/
│
└── docs/
    ├── project_overview.md
    ├── data_quality_rules.md
    └── reconciliation.md

## 7. Layer Details

Bronze Layer – Raw Data Ingestion

The Bronze Layer is responsible for ingesting the original hotel booking CSV file into Databricks.

## Key Activities:

Read CSV data from a Unity Catalog Volume.

Use Auto Loader for data ingestion.

Preserve the original source records.

Add source filename metadata.

Capture data loading timestamp.

# Bronze Table:

bronze_hotel_bookings

# Source Path:

/Volumes/hospitality_catalog/bookings/raw_files/

Silver Layer – Data Cleaning and Validation

The Silver Layer transforms raw booking records into clean and validated datasets.

# Key Activities:

Remove duplicate booking records.

Trim unnecessary spaces.

Standardize text using INITCAP and TRIM.

Replace missing city values with Unknown.

Calculate missing nights using DATEDIFF.

Calculate missing total amounts using nights × room_rate.

Identify invalid stay dates.

Identify negative room rates.

Separate valid and rejected booking records.

# Silver Tables:

silver_bookings_clean

silver_bookings_rejected

Gold Layer – Business Analytics

The Gold Layer creates analytical datasets for business reporting and dashboard development.

# Gold Tables:

1. gold_hotel_revenue

Provides hotel-wise booking and revenue analysis.

2. gold_city_performance

Provides city-wise booking performance and guest analysis.

3. gold_booking_trends

Provides monthly booking trends and revenue summaries.

4. gold_payment_analysis

Provides payment method and payment status analysis.

## 8. Dashboard

An interactive Hotel Booking Analytics Dashboard was developed and published using Databricks AI/BI Dashboard and Genie Code.

Key Performance Indicators

Total Bookings

Total Revenue

Average Booking Amount

Total Unique Hotels

Dashboard Visualizations

Hotel-wise Revenue Analysis

City-wise Booking Performance

Monthly Booking Trends

Payment Method Analysis

Booking Status Analysis

Dashboard Preview

# Live Dashboard:[ Add your published Databricks dashboard URL here.
](https://dbc-3de1915a-69f2.cloud.databricks.com/dashboardsv3/01f1d9ebb3cb19d6a189a7427ae19b75/published?o=7474652173141518)

## 9. How to Run

Open your Databricks workspace.

Create or select a Unity Catalog.

Create a schema and Volume.

Upload hotel_bookings_raw.csv into the Volume.

Create a new Lakeflow Spark Declarative Pipeline.

Set the default catalog to hospitality_catalog.

Set the default schema to bookings.

Add the Bronze, Silver and Gold SQL transformation files.

Run the pipeline and verify successful execution.

Validate record counts and reconciliation results.

Query the Gold tables.

Build and publish the Databricks AI/BI dashboard.

## 10.Key Learnings

Understanding Medallion Architecture.

Working with Unity Catalog and Volumes.

Building declarative ETL pipelines using SQL.

Performing data cleaning and validation.

Handling duplicate and rejected records.

Implementing data reconciliation.

Creating business-ready analytical tables.

Building interactive dashboards using Databricks AI/BI and Genie Code.

## 11. Future Improvements

Integrate additional hotel booking data sources.

Implement automated data-quality monitoring.

Improve pipeline error handling and alerting.

Add hotel occupancy and room availability analytics.

Develop advanced customer segmentation.

Add interactive dashboard filters.

Implement scheduled pipeline refreshes.

## License

Add a suitable open-source license if you intend to distribute this project under one. Otherwise, leave the repository without a license.
