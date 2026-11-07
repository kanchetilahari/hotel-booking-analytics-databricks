### Hotel Booking Analytics Platform: Medallion Architecture with Lakeflow Spark Declarative Pipelines

An end-to-end Hotel Booking Analytics data engineering project built on Databricks using Lakeflow Spark Declarative Pipelines (SQL) and Medallion Architecture (Bronze → Silver → Gold).This project transforms raw hotel booking CSV data into structured, analytics-ready datasets through data ingestion, cleaning, validation, transformation and business reporting. It also includes data-quality tracking, record reconciliation and an interactive Databricks AI/BI dashboard.

## Table of Contents
1.Business Problem
2.Architecture
Pipeline Lineage
Tech Stack
Dataset
Repository Structure
Layer Details
Data Quality Rules
Reconciliation
Dashboard
How to Run
Business Requirements Coverage
Key Learnings
Future Improvements

## 1. Business Problem
A hotel group manages bookings across multiple hotels and cities. However, raw booking data contains several quality issues, including inconsistent text formatting, missing values, duplicate bookings, invalid stay dates and negative room rates.
These problems make it difficult for business managers to generate reliable reports about hotel performance, booking trends, revenue, room types and payment methods.
Goal: Build a repeatable data engineering pipeline that preserves the original booking data, cleans and validates records, creates business-ready Gold tables and provides insights through an interactive dashboard.

2. Architecture

The project follows the Medallion Architecture:

Raw CSV → Bronze → Silver → Gold → Dashboard

Layer

Purpose

Key Actions

Bronze

Preserve source data

Load CSV, retain raw records and add ingestion metadata

Silver

Improve data quality

Remove duplicates, standardize text, handle missing values and validate records

Gold

Business analytics

Generate hotel, city, monthly booking and payment summaries

Dashboard

Visualize insights

Display KPIs, revenue trends and booking performance

3. Pipeline Lineage

Object

Type

Description

bronze_hotel_bookings

Streaming table

Raw hotel booking records

silver_bookings_clean

Materialized view

Cleaned and validated booking records

silver_bookings_rejected

Materialized view

Invalid booking records with rejection reasons

gold_hotel_revenue

Materialized view

Hotel-wise revenue analysis

gold_city_performance

Materialized view

City-wise booking performance

gold_booking_trends

Materialized view

Monthly booking trends

gold_payment_analysis

Materialized view

Payment method analysis
