# Data Quality Rules – Hotel Booking Analytics

This document describes the data-quality (DQ) rules applied in the Hotel Booking Medallion pipeline, how each issue is treated, and where it is enforced.

> **Principle:** Raw hotel booking data is preserved in the Bronze Layer. Data-quality issues are identified during Silver transformations. Clean and rejected records are separated to maintain reliable data for Gold Layer analytics.

## 1. Known Issues in the Source Data

The source dataset contains hotel booking information with 1,316 ingested records.

The following data-quality dimensions are considered during processing:

| # | Issue | Description |
|---|---|---|
| 1 | Missing values | Null or missing booking information |
| 2 | Duplicate records | Repeated booking records |
| 3 | Invalid room rate | Negative room_rate values |
| 4 | Date validity | Incorrect or inconsistent booking dates |
| 5 | Booking information | Missing booking_id or guest_id |
| 6 | Numeric validity | Invalid values in nights and guests |
| 7 | Payment information | Missing payment method or payment status |
| 8 | Booking status | Missing or inconsistent booking status |
| 9 | Rescued data | Records or fields captured in _rescued_data |

*Note: These are data-quality dimensions considered for the project. Actual enforcement depends on the SQL transformation logic.*

## 2. Rules by Layer

### Bronze: Preserve Raw Data

The Bronze Layer stores raw hotel booking data ingested from CSV files using Databricks Auto Loader.

| Rule ID | Rule | Treatment |
|---|---|---|
| BRZ-01 | Preserve original source records | No business-level modification |
| BRZ-02 | Read CSV files using Auto Loader | Ingestion |
| BRZ-03 | Track source file information | Add source_file |
| BRZ-04 | Capture ingestion timestamp | Add loaded_at |
| BRZ-05 | Handle rescued data | Store _rescued_data |

### Silver: Clean, Validate and Separate

The Silver Layer performs data cleaning, validation, duplicate identification and record separation.

| Rule ID | Dimension | Rule | Treatment |
|---|---|---|---|
| SLV-01 | Completeness | Check missing booking_id | Validate |
| SLV-02 | Completeness | Check missing guest_id | Validate |
| SLV-03 | Numeric validity | room_rate must not be negative | Reject invalid records |
| SLV-04 | Date validity | Validate booking and check-in/check-out dates | Validate |
| SLV-05 | Numeric validity | Validate nights and guests | Validate |
| SLV-06 | Duplicates | Identify duplicate booking records | Identify and remove duplicates |
| SLV-07 | Data consistency | Validate booking information | Clean or reject |
| SLV-08 | Data separation | Separate valid and rejected records | Clean / Reject |

**Important:** The implemented SQL validation conditions determine which records are actually rejected. Refer to the Silver transformation SQL file for exact conditions.

### Gold: Trusted Business Analytics

The Gold Layer creates business-ready analytical datasets using Silver Layer data.

| Rule ID | Rule | Treatment |
|---|---|---|
| GLD-01 | Use cleaned booking data | Filter trusted records |
| GLD-02 | Calculate hotel-wise revenue | Aggregate |
| GLD-03 | Calculate city-wise booking performance | Aggregate |
| GLD-04 | Analyze monthly booking trends | Aggregate |
| GLD-05 | Analyze payment methods | Aggregate |
| GLD-06 | Validate analytical record counts | Reconciliation |

## 3. Clean vs. Rejected Records

| Category | Meaning | Treatment |
|---|---|---|
| Clean records | Records accepted by Silver validation | Used for Gold analytics |
| Rejected records | Records failing implemented validation rules | Stored separately |
| Duplicate records | Repeated booking records identified during processing | Removed or excluded according to implemented logic |

The project maintains two Silver Layer tables:

- `silver_bookings_clean`
- `silver_bookings_rejected`

## 4. Important Data Quality Columns

| Column | Data Type | Description |
|---|---|---|
| booking_id | STRING | Unique booking identifier |
| guest_id | STRING | Guest identifier |
| room_rate | DOUBLE | Room price validation |
| total_amount | DOUBLE | Booking amount |
| discount_amount | DOUBLE | Discount value |
| nights | INT | Number of nights |
| guests | INT | Number of guests |
| booking_status | STRING | Booking status |
| payment_status | STRING | Payment status |
| _rescued_data | STRING | Rescued data information |
| source_file | STRING | Source CSV filename |
| loaded_at | TIMESTAMP | Data ingestion timestamp |

## 5. Data Quality Results

The following results were obtained from the completed pipeline execution.

| Metric | Count |
|---|---:|
| Bronze records | 1,316 |
| Silver clean records | 1,269 |
| Silver rejected records | 21 |
| Duplicate records identified | 26 |
| Records after duplicate removal | 1,290 |

### Reconciliation

Bronze records = 1,316

Duplicate records identified = 26

Records after duplicate removal:

1,316 - 26 = 1,290

Silver records:

1,269 + 21 = 1,290

Therefore:

**1,290 = 1,269 + 21**

The record counts reconcile.

## 6. Pipeline Expectations (Lakeflow)

The project uses Databricks Lakeflow Spark Declarative Pipelines for data ingestion and transformation.

Data-quality validation is performed through SQL transformation logic.

Important validation areas include:

- Booking identifier validation
- Guest information validation
- Room rate validation
- Date validation
- Duplicate identification
- Clean and rejected record separation

Refer to the actual pipeline SQL files for implemented constraints and validation expressions.

## 7. Investigating Suspicious Records

For rejected or suspicious hotel booking records:

1. Identify the rejected booking records.
2. Compare the records with the original Bronze data.
3. Check booking_id and guest_id.
4. Examine room_rate, total_amount and discount_amount.
5. Validate booking_date, check_in_date and check_out_date.
6. Review booking_status and payment_status.
7. Identify duplicate or invalid records.
8. Document the reason for rejection.

## 8. Assumptions and Decisions

- Bronze data is retained as the raw ingestion layer.
- Silver is responsible for data cleaning and validation.
- Rejected records are stored separately.
- Gold tables support business reporting and dashboard development.
- Duplicate records are identified during Silver processing.
- Booking status and payment status are treated as separate business attributes.
- Original source data should remain available for investigation.

