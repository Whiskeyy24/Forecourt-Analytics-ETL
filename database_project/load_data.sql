-- LOAD DATA 
LOAD DATA INFILE 'C:/Users/PRANAV/database_project/summary.csv' 
    INTO TABLE raw_summary 
    FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/Users/PRANAV/database_project/Shop_week.csv' 
    INTO TABLE raw_shop_daily 
    FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/Users/PRANAV/database_project/fuels.csv' 
    INTO TABLE raw_fuel_sales 
    FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/Users/PRANAV/database_project/valet.csv' 
    INTO TABLE raw_valet 
    FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/Users/PRANAV/database_project/shop_data.csv' 
    INTO TABLE raw_shop_categories 
    FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 ROWS;