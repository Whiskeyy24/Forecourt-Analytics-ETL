-- 1. Create and select the database
CREATE DATABASE ForecourtAnalytics;
USE ForecourtAnalytics;

-- 2. Create Raw Table for the Summary Sheet
CREATE TABLE raw_summary (
    Metric_Name VARCHAR(100),
    Sales DECIMAL(10,2),
    Var_to_Prev_Wk DECIMAL(10,2),
    Target DECIMAL(10,2),
    Var_to_Target DECIMAL(10,2),
    Source_File VARCHAR(100)
);

-- 3. Create Raw Table for Daily Shop Sales
CREATE TABLE raw_shop_daily (
    Day_Name VARCHAR(10),
    Exact_Date DATE,
    Total_Shop DECIMAL(10,2),
    Cum_Shop DECIMAL(10,2),
    Cum_Shop_Var DECIMAL(10,2),
    Source_File VARCHAR(100)
);

-- 4. Create Raw Table for Fuel Sales
CREATE TABLE raw_fuel_sales (
    Day_Name VARCHAR(10),
    Exact_Date DATE,
    Ult_Unleaded DECIMAL(10,2),
    Unleaded DECIMAL(10,2),
    Ult_Derv DECIMAL(10,2),
    Derv_ex_KeyFuels DECIMAL(10,2),
    Daily_Total DECIMAL(10,2),
    Source_File VARCHAR(100)
);

-- 5. Create Raw Table for Shop Categories (Wide Format)
-- Notice how we create a column for every single category
CREATE TABLE raw_shop_categories (
    Day_Name VARCHAR(10),
    Exact_Date DATE,
    Car_Care DECIMAL(10,2),
    Chilled DECIMAL(10,2),
    Costa DECIMAL(10,2),
    Confect DECIMAL(10,2),
    Crisps DECIMAL(10,2),
    Bakery DECIMAL(10,2),
    Hot_Food DECIMAL(10,2),
    Grocery DECIMAL(10,2),
    Lubes DECIMAL(10,2),
    News DECIMAL(10,2),
    Non_Food DECIMAL(10,2),
    Off_Licence DECIMAL(10,2),
    Sandwiches DECIMAL(10,2),
    Soft_Drinks DECIMAL(10,2),
    Solid_Fuel DECIMAL(10,2),
    Tobacco DECIMAL(10,2),
    Vaping DECIMAL(10,2),
    Other_Sales DECIMAL(10,2),
    Source_File VARCHAR(100)
);

-- 6. Create Raw Table for Valet/Wash
CREATE TABLE raw_valet (
    Day_Name VARCHAR(10),
    Exact_Date DATE,
    CW_Sales DECIMAL(10,2),
    JW_Sales DECIMAL(10,2),
    Air_Sales DECIMAL(10,2),
    Vac_Sales DECIMAL(10,2),
    Source_File VARCHAR(100)
);