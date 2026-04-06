# Forecourt-Analytics-ETL
An end-to-end local ETL pipeline using MySQL to ingest, clean, and centralize retail forecourt data (fuel, shop, valet, and shifts) for Power BI visualization.

# Forecourt Analytics: Local ETL & BI Pipeline

## Overview
This project is a localized data engineering and analytics solution designed for a forecourt business (gas station, retail shop, and valet services). It takes disconnected operational data scattered across multiple CSV spreadsheets and builds a robust, automated ETL (Extract, Transform, Load) pipeline into a centralized MySQL database. 

The resulting "Single Source of Truth" database is then connected directly to Power BI to generate interactive business intelligence dashboards, allowing management to track daily fuel volume, retail category performance, valet efficiency, and employee shift metrics in one place.

## Tech Stack
* **Database:** MySQL Community Server 8.0 / MySQL Workbench
* **Languages:** SQL (Data Definition, Data Manipulation)
* **Visualization:** Microsoft Power BI
* **Data Sources:** Flat files (.csv)

## System Architecture
The pipeline follows a structured 4-step local architecture:
1. **Data Source:** Raw operational data is collected into seven distinct CSV files (`summary.csv`, `Shop_week.csv`, `fuels.csv`, `valet.csv`, `shop_data.csv`, `shift_data.csv`, `other_sales.csv`).
2. **Ingestion Engine:** Automated SQL `LOAD DATA INFILE` scripts pull the data into the database, bypassing manual data entry.
3. **Storage & Staging:** Data is loaded into flexible `VARCHAR(255)` staging tables within the `ForecourtAnalytics` database to prevent strict-mode import crashes and ensure 100% data capture.
4. **Analytics Layer:** Power BI connects directly to the MySQL staging tables to build interactive relational models and dashboards.

## Key Technical Solutions
Building this pipeline required navigating several real-world database administration hurdles:
* **Overriding Strict Security (Error 1290):** Successfully navigated MySQL's `--secure-file-priv` restrictions by routing all raw data through the designated hidden `ProgramData/Uploads/` secure directory.
* **Resolving Column Mismatches (Error 1261):** Managed strict-mode ingestion errors by aligning CSV structures with table columns and dynamically handling empty data slots.
* **Fixing Encoding Crashes (Error 1300):** Resolved UTF-8 import failures caused by Excel-generated special characters (like currency symbols) by enforcing `CHARACTER SET latin1` during the load sequence.

## Repository Contents
* `/sql_scripts` - Contains the `.sql` files for database creation, staging table generation, and data loading.
* `/sample_data` - (Optional) Contains anonymized or sample `.csv` files matching the database schema for testing.
* `Forecourt_Dashboard.pbix` - The Power BI dashboard file containing the data model and visualizations.

## How to Run This Project Locally

### Step 1: Database Setup
Open MySQL Workbench and run the initial setup script to create the database and staging tables:
```sql
CREATE DATABASE ForecourtAnalytics;
USE ForecourtAnalytics;
-- Run the CREATE TABLE scripts for stage_fuels, stage_shop_data, etc.
