-- 1. The Busiest Days (Shop Revenue) == Business Question: Which days of the week drive the most shop sales?
SELECT 
    Clean_Day, 
    COUNT(Exact_Date) AS Total_Days_Recorded,
    SUM(Total_Sales) AS Total_Revenue,
    ROUND(AVG(Total_Sales), 2) AS Average_Revenue_Per_Day
FROM clean_shop_daily
GROUP BY Clean_Day
ORDER BY Total_Revenue DESC;

-- 2. Category Performance Leaderboard == Business Question: What is our best-selling product category across the entire dataset?
SELECT 
    Category, 
    SUM(Sales) AS Total_Category_Sales,
    ROUND(AVG(Sales), 2) AS Average_Daily_Sales
FROM clean_shop_categories
GROUP BY Category
ORDER BY Total_Category_Sales DESC;

-- 3. fuel Volume Breakdown == Business Question: What is the exact mix of fuel types being pumped?
SELECT 
    SUM(Ult_Unleaded) AS Total_Ultimate_Unleaded,
    SUM(Unleaded) AS Total_Standard_Unleaded,
    SUM(Ult_Derv) AS Total_Ultimate_Diesel,
    SUM(Total_Fuel_Liters) AS Grand_Total_Fuel_Liters
FROM clean_fuel_sales;

-- 4. The "Valet Profit Center" Analysis == Business Question: How much revenue is the automated wash & air section generating?
SELECT 
    SUM(Car_Wash_Sales) AS Total_Car_Wash,
    SUM(Jet_Wash_Sales) AS Total_Jet_Wash,
    SUM(Air_Machine_Sales) AS Total_Air_Machine,
    SUM(Vacuum_Sales) AS Total_Vacuum,
    SUM(Car_Wash_Sales + Jet_Wash_Sales + Air_Machine_Sales + Vacuum_Sales) AS Total_Valet_Revenue
FROM clean_valet;

-- 5. Advanced: Performance vs. Targets == Business Question: Based on our summary sheet, which metrics are beating our targets, and which are falling behind?
SELECT 
    Metric_Name, 
    Sales AS Actual_Performance, 
    Target_Sales AS Target, 
    (Sales - Target_Sales) AS Variance,
    CONCAT(ROUND((Sales / Target_Sales) * 100, 1), '%') AS Percent_To_Target
FROM clean_summary
WHERE Target_Sales > 0
ORDER BY (Sales / Target_Sales) DESC; 

-- 6. Advanced: The "Super Join" (Total Daily Forecourt Snapshot) == Business Question: What are the top 10 best days in our history across all departments combined?
SELECT 
    s.Exact_Date,
    s.Clean_Day,
    s.Total_Sales AS Shop_Revenue,
    (v.Car_Wash_Sales + v.Jet_Wash_Sales + v.Air_Machine_Sales + v.Vacuum_Sales) AS Valet_Revenue,
    (s.Total_Sales + (v.Car_Wash_Sales + v.Jet_Wash_Sales + v.Air_Machine_Sales + v.Vacuum_Sales)) AS Total_Site_Revenue,
    f.Total_Fuel_Liters
FROM clean_shop_daily s
LEFT JOIN clean_valet v ON s.Exact_Date = v.Exact_Date
LEFT JOIN clean_fuel_sales f ON s.Exact_Date = f.Exact_Date
ORDER BY Total_Site_Revenue DESC
LIMIT 10;

-- 7. Advanced: Shop vs. Fuel Correlation == Business Question: Do days with the highest fuel volume also result in the highest shop sales? (Checking to see if fuel customers go inside the shop).
SELECT 
    s.Exact_Date,
    s.Clean_Day,
    f.Total_Fuel_Liters,
    s.Total_Sales AS Shop_Revenue
FROM clean_shop_daily s
JOIN clean_fuel_sales f ON s.Exact_Date = f.Exact_Date
ORDER BY f.Total_Fuel_Liters DESC
LIMIT 15;

-- 8. Advanced: Weekend vs. Weekday Comparison == Business Question: Are weekends actually more profitable than weekdays for the shop?
SELECT 
    CASE 
        WHEN Clean_Day IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,
    COUNT(Exact_Date) AS Days_Count,
    SUM(Total_Sales) AS Total_Revenue,
    ROUND(SUM(Total_Sales) / COUNT(Exact_Date), 2) AS Average_Revenue_Per_Day
FROM clean_shop_daily
GROUP BY Day_Type
ORDER BY Average_Revenue_Per_Day DESC;