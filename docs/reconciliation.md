# Data Reconciliation – Hotel Booking Analytics

This document describes the data reconciliation process performed in the Hotel Booking Medallion pipeline. It validates record counts across Bronze and Silver layers to ensure data consistency and completeness.

> **Principle:** Every record entering the transformation process should be accounted for as a clean record, rejected record, or identified duplicate according to the implemented pipeline logic.

## 1. Reconciliation Overview

Data reconciliation is performed to verify that records are correctly processed during data ingestion, cleaning, validation and transformation.

The project uses the following layers:

- Bronze Layer – Raw hotel booking data ingestion.
- Silver Layer – Data cleaning, duplicate identification and validation.
- Gold Layer – Business-ready analytical datasets.

## 2. Record Count Summary

The following counts were obtained from the Databricks pipeline execution.

| Layer / Metric | Record Count |
|---|---:|
| Bronze Layer | 1,316 |
| Silver Clean Records | 1,269 |
| Silver Rejected Records | 21 |
| Duplicate Records Identified | 26 |

## 3. Bronze to Silver Reconciliation

### Step 1: Bronze Record Count

Total records ingested into the Bronze Layer:

**Bronze Records = 1,316**

### Step 2: Duplicate Records

Duplicate records identified during the validation process:

**Duplicate Records = 26**

### Step 3: Records After Duplicate Removal

Formula:

Records After Duplicate Removal = Bronze Records - Duplicate Records

Calculation:

1,316 - 26 = 1,290

### Step 4: Silver Layer Record Count

The Silver Layer contains:

- Clean Records = 1,269
- Rejected Records = 21

Total Silver Records:

1,269 + 21 = 1,290

## 4. Reconciliation Result

| Reconciliation Metric | Count |
|---|---:|
| Bronze Records | 1,316 |
| Less: Duplicate Records | 26 |
| Expected Silver Records | 1,290 |
| Actual Clean Records | 1,269 |
| Actual Rejected Records | 21 |
| Total Silver Records | 1,290 |
| Difference | 0 |

**Reconciliation Status: SUCCESS**

The expected and actual Silver record counts match.

## 5. Reconciliation Formula

Expected Silver Records:

Bronze Records - Duplicate Records

1,316 - 26 = 1,290

Actual Silver Records:

Clean Records + Rejected Records

1,269 + 21 = 1,290

Difference:

Expected Silver Records - Actual Silver Records

1,290 - 1,290 = 0

## 6. SQL Queries Used for Validation

### Bronze Record Count

```sql
SELECT COUNT(*) AS bronze_count
FROM hospitality_catalog.bookings.bronze_hotel_bookings;
```

### Silver Clean Record Count

```sql
SELECT COUNT(*) AS silver_clean_count
FROM hospitality_catalog.bookings.silver_bookings_clean;
```

### Silver Rejected Record Count

```sql
SELECT COUNT(*) AS silver_rejected_count
FROM hospitality_catalog.bookings.silver_bookings_rejected;
```

### Duplicate Record Count

```sql
SELECT COUNT(*) AS duplicate_records
FROM (
    SELECT booking_id
    FROM hospitality_catalog.bookings.bronze_hotel_bookings
    GROUP BY booking_id
    HAVING COUNT(*) > 1
) duplicates;
```

## 7. Gold Layer Validation
The Gold Layer contains four analytical tables:

| Gold Table | Business Purpose |
|---|---|
| gold_hotel_revenue | Hotel-wise revenue analysis |
| gold_city_performance | City-wise booking performance |
| gold_booking_trends | Monthly booking trend analysis |
| gold_payment_analysis | Payment method analysis |

These tables provide aggregated datasets for business intelligence and dashboard reporting.

## 8. Final Reconciliation Summary

The Hotel Booking Analytics pipeline successfully processed the source records through Bronze and Silver layers.

Key results:
- 1,316 records ingested into Bronze.
- 26 duplicate records identified.
- 1,269 clean records generated.
- 21 rejected records generated.
- 1,290 records accounted for in Silver.
- Record count difference: 0.
The reconciliation results demonstrate that the Bronze-to-Silver record counts balance according to the reported pipeline metrics.


