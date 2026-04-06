-- ==============================================================================
-- PHASE 1: DATABASE INITIALIZATION
-- ==============================================================================
CREATE DATABASE IF NOT EXISTS ForecourtAnalytics;
USE ForecourtAnalytics;

-- ==============================================================================
-- PHASE 2: UNIVERSAL STAGING TABLES (Loading Docks)
-- 25 VARCHAR columns absorb ANY CSV structure perfectly without failing.
-- ==============================================================================
DROP TABLE IF EXISTS stage_shop_week, stage_fuels, stage_valet, stage_shop_data, stage_summary, stage_shift_data, stage_other_sales;

CREATE TABLE stage_shop_week (C1 VARCHAR(255), C2 VARCHAR(255), C3 VARCHAR(255), C4 VARCHAR(255), C5 VARCHAR(255), C6 VARCHAR(255), C7 VARCHAR(255), C8 VARCHAR(255), C9 VARCHAR(255), C10 VARCHAR(255), C11 VARCHAR(255), C12 VARCHAR(255), C13 VARCHAR(255), C14 VARCHAR(255), C15 VARCHAR(255), C16 VARCHAR(255), C17 VARCHAR(255), C18 VARCHAR(255), C19 VARCHAR(255), C20 VARCHAR(255), C21 VARCHAR(255), C22 VARCHAR(255), C23 VARCHAR(255), C24 VARCHAR(255), C25 VARCHAR(255));
CREATE TABLE stage_fuels       LIKE stage_shop_week;
CREATE TABLE stage_valet       LIKE stage_shop_week;
CREATE TABLE stage_shop_data   LIKE stage_shop_week;
CREATE TABLE stage_summary     LIKE stage_shop_week;
CREATE TABLE stage_shift_data  LIKE stage_shop_week;
CREATE TABLE stage_other_sales LIKE stage_shop_week;

-- ==============================================================================
-- PHASE 3: RAW DATA EXTRACTION (Force Windows \r\n line endings)
-- ==============================================================================
LOAD DATA INFILE 'C:/Users/PRANAV/database_project/Shop_week.csv' INTO TABLE stage_shop_week FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;
LOAD DATA INFILE 'C:/Users/PRANAV/database_project/fuels.csv' INTO TABLE stage_fuels FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;
LOAD DATA INFILE 'C:/Users/PRANAV/database_project/valet.csv' INTO TABLE stage_valet FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;
LOAD DATA INFILE 'C:/Users/PRANAV/database_project/shop_data.csv' INTO TABLE stage_shop_data FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;
LOAD DATA INFILE 'C:/Users/PRANAV/database_project/summary.csv' INTO TABLE stage_summary FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;
LOAD DATA INFILE 'C:/Users/PRANAV/database_project/shift_data.csv' INTO TABLE stage_shift_data FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;
LOAD DATA INFILE 'C:/Users/PRANAV/database_project/other_sales.csv' INTO TABLE stage_other_sales FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

-- ==============================================================================
-- PHASE 4: TRANSFORMATION & CLEANING (The Core Logic)
-- ==============================================================================

-- 4.1 Clean Shop Daily
DROP TABLE IF EXISTS clean_shop_daily;
CREATE TABLE clean_shop_daily AS 
SELECT 
    TRIM(C2) AS Exact_Date, 
    CASE 
        WHEN LOWER(C1) LIKE '%mon%' THEN 'Monday' WHEN LOWER(C1) LIKE '%tue%' THEN 'Tuesday' 
        WHEN LOWER(C1) LIKE '%wed%' THEN 'Wednesday' WHEN LOWER(C1) LIKE '%thu%' THEN 'Thursday' 
        WHEN LOWER(C1) LIKE '%fri%' THEN 'Friday' WHEN LOWER(C1) LIKE '%sat%' THEN 'Saturday' 
        WHEN LOWER(C1) LIKE '%sun%' THEN 'Sunday' ELSE 'Other' 
    END AS Clean_Day, 
    CAST(NULLIF(REPLACE(TRIM(C3), ',', ''), '') AS DECIMAL(10,2)) AS Total_Sales 
FROM stage_shop_week 
WHERE C1 IS NOT NULL AND LOWER(C1) NOT LIKE '%tot%';

-- 4.2 Clean Fuel Sales
DROP TABLE IF EXISTS clean_fuel_sales;
CREATE TABLE clean_fuel_sales AS 
SELECT 
    TRIM(C2) AS Exact_Date, 
    CASE 
        WHEN LOWER(C1) LIKE '%mon%' THEN 'Monday' WHEN LOWER(C1) LIKE '%tue%' THEN 'Tuesday' 
        WHEN LOWER(C1) LIKE '%wed%' THEN 'Wednesday' WHEN LOWER(C1) LIKE '%thu%' THEN 'Thursday' 
        WHEN LOWER(C1) LIKE '%fri%' THEN 'Friday' WHEN LOWER(C1) LIKE '%sat%' THEN 'Saturday' 
        WHEN LOWER(C1) LIKE '%sun%' THEN 'Sunday' ELSE 'Other' 
    END AS Clean_Day, 
    CAST(NULLIF(REPLACE(TRIM(C3), ',', ''), '') AS DECIMAL(10,2)) AS Ult_Unleaded, 
    CAST(NULLIF(REPLACE(TRIM(C4), ',', ''), '') AS DECIMAL(10,2)) AS Unleaded, 
    CAST(NULLIF(REPLACE(TRIM(C5), ',', ''), '') AS DECIMAL(10,2)) AS Ult_Derv, 
    CAST(NULLIF(REPLACE(TRIM(C7), ',', ''), '') AS DECIMAL(10,2)) AS Total_Fuel_Liters 
FROM stage_fuels 
WHERE C1 IS NOT NULL AND LOWER(C1) NOT LIKE '%tot%';

-- 4.3 Clean Valet (Aggregating Car Wash, Jet Wash, Air, Vacuum)
DROP TABLE IF EXISTS clean_valet;
CREATE TABLE clean_valet AS 
SELECT 
    TRIM(C2) AS Exact_Date, 
    CAST(NULLIF(REPLACE(TRIM(C3), ',', ''), '') AS DECIMAL(10,2)) AS Car_Wash_Sales, 
    CAST(NULLIF(REPLACE(TRIM(C6), ',', ''), '') AS DECIMAL(10,2)) AS Jet_Wash_Sales, 
    CAST(NULLIF(REPLACE(TRIM(C8), ',', ''), '') AS DECIMAL(10,2)) AS Air_Machine_Sales, 
    CAST(NULLIF(REPLACE(TRIM(C10), ',', ''), '') AS DECIMAL(10,2)) AS Vacuum_Sales
FROM stage_valet 
WHERE C1 IS NOT NULL AND LOWER(C1) NOT LIKE '%tot%';

-- 4.4 Clean Shop Categories (Unpivoting Wide Data to Deep Data)
DROP TABLE IF EXISTS clean_shop_categories;
CREATE TABLE clean_shop_categories AS
SELECT TRIM(C2) AS Exact_Date, 'Car Care' AS Category, CAST(NULLIF(REPLACE(TRIM(C3), ',', ''), '') AS DECIMAL(10,2)) AS Sales FROM stage_shop_data WHERE LOWER(C1) NOT LIKE '%tot%'
UNION ALL SELECT TRIM(C2), 'Chilled', CAST(NULLIF(REPLACE(TRIM(C4), ',', ''), '') AS DECIMAL(10,2)) FROM stage_shop_data WHERE LOWER(C1) NOT LIKE '%tot%'
UNION ALL SELECT TRIM(C2), 'Costa', CAST(NULLIF(REPLACE(TRIM(C5), ',', ''), '') AS DECIMAL(10,2)) FROM stage_shop_data WHERE LOWER(C1) NOT LIKE '%tot%'
UNION ALL SELECT TRIM(C2), 'Confectionery', CAST(NULLIF(REPLACE(TRIM(C6), ',', ''), '') AS DECIMAL(10,2)) FROM stage_shop_data WHERE LOWER(C1) NOT LIKE '%tot%'
UNION ALL SELECT TRIM(C2), 'Bakery', CAST(NULLIF(REPLACE(TRIM(C8), ',', ''), '') AS DECIMAL(10,2)) FROM stage_shop_data WHERE LOWER(C1) NOT LIKE '%tot%'
UNION ALL SELECT TRIM(C2), 'Tobacco', CAST(NULLIF(REPLACE(TRIM(C18), ',', ''), '') AS DECIMAL(10,2)) FROM stage_shop_data WHERE LOWER(C1) NOT LIKE '%tot%';

-- 4.5 Clean Summary Data
DROP TABLE IF EXISTS clean_summary;
CREATE TABLE clean_summary AS 
SELECT 
    TRIM(C1) AS Metric_Name, 
    CAST(NULLIF(REPLACE(TRIM(C2), ',', ''), '') AS DECIMAL(10,2)) AS Sales, 
    CAST(NULLIF(REPLACE(TRIM(C4), ',', ''), '') AS DECIMAL(10,2)) AS Target_Sales 
FROM stage_summary 
WHERE C1 IS NOT NULL AND TRIM(C1) != '';

-- ==============================================================================
-- PHASE 5: PRESENTATION LAYER (Power BI Views)
-- These provide permanent, clean windows for Power BI to connect to.
-- ==============================================================================
CREATE OR REPLACE VIEW v_dashboard_shop AS SELECT * FROM clean_shop_daily;
CREATE OR REPLACE VIEW v_dashboard_fuel AS SELECT * FROM clean_fuel_sales;
CREATE OR REPLACE VIEW v_dashboard_valet AS SELECT * FROM clean_valet;
CREATE OR REPLACE VIEW v_dashboard_categories AS SELECT * FROM clean_shop_categories;
CREATE OR REPLACE VIEW v_dashboard_summary AS SELECT * FROM clean_summary;

-- Note: 'shift_data' and 'other_sales' are securely staged in 'stage_shift_data' 
-- and 'stage_other_sales' and are ready whenever you want to query them!

-- ==============================================================================
-- PHASE 6: SYSTEM VERIFICATION (The Final Check)
-- ==============================================================================
SELECT 'SHOP DAILY' AS Table_Name, COUNT(*) AS Total_Rows FROM clean_shop_daily
UNION ALL SELECT 'FUEL SALES', COUNT(*) FROM clean_fuel_sales
UNION ALL SELECT 'VALET', COUNT(*) FROM clean_valet
UNION ALL SELECT 'CATEGORIES', COUNT(*) FROM clean_shop_categories
UNION ALL SELECT 'SUMMARY', COUNT(*) FROM clean_summary;