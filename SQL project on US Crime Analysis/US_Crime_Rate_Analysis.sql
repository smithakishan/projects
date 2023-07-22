CREATE DATABASE IF NOT EXISTS crime_rate;
USE crime_rate;

DROP TABLE IF EXISTS crime_us;
CREATE TABLE IF NOT EXISTS crime_us (
NUM VARCHAR(255),
ID VARCHAR (255),
Case_Number VARCHAR (10),
Date datetime,
Block VARCHAR (100),
IUCR VARCHAR(10),
Primary_Type VARCHAR(100),
Description VARCHAR(200),
Location_description VARCHAR(100),
Arrest VARCHAR(100),
Domestic VARCHAR (100),
Beat VARCHAR (100),
District VARCHAR (100),
Ward VARCHAR (100),
Community_Area VARCHAR (100),
FBI_Code VARCHAR (100),
X_Coordinate VARCHAR (100),
Y_Coordinate VARCHAR (100),
Year VARCHAR (10),
crime_Updated_On DATETIME,
Latitude VARCHAR (100),
Longitude VARCHAR (100),
Location VARCHAR (100)
);

LOAD DATA INFILE "\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\crime_us\\crime_1.csv" INTO TABLE crime_us
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SELECT * FROM crime_us; 

/*	Create a SQL database containing data related to the case number, primary crime category, crime description, 
crime location, and arrest status using the dataset. */
CREATE DATABASE IF NOT EXISTS sub_data;
DROP TABLE IF EXISTS sub_data.table_1;
CREATE TABLE IF NOT EXISTS sub_data.table_1 (
Case_Number VARCHAR(30), 
primary_crime_category VARCHAR (100), 
crime_description VARCHAR(200), 
crime_location VARCHAR(100),
Arrest_status VARCHAR(20)
);
INSERT INTO sub_data.table_1(Case_Number, primary_crime_category, crime_description, crime_location, Arrest_status)
SELECT Case_Number, Primary_Type, Description, Location_description, Arrest 
FROM crime_rate.crime_us;
SELECT * FROM sub_data.table_1;

-- Make a database in SQL where theft costs more than $500.
CREATE DATABASE IF NOT EXISTS theft;
DROP TABLE IF EXISTS theft.theft_table;
CREATE TABLE IF NOT EXISTS theft.theft_table (
ID VARCHAR (255),
Case_Number VARCHAR (10),
Primary_Type VARCHAR(100),
Description VARCHAR(200),
Location_description VARCHAR(100),
Arrest VARCHAR(100)
);
INSERT INTO theft.theft_table
SELECT ID, Case_Number, Primary_Type, Description, Location_description, Arrest FROM crime_rate.crime_us WHERE Description='OVER 500';
SELECT* FROM theft.theft_table;

-- Determine the overall number of cases for each major category of crime.
SELECT  Primary_Type, COUNT(ID) AS Overall_cases FROM crime_us 
GROUP BY Primary_Type WITH ROLLUP;
-- To find the type of crime with maximum number of cases.
SELECT  Primary_Type, COUNT(ID) AS Overall_cases FROM crime_us 
GROUP BY Primary_Type
ORDER BY Overall_cases DESC;

-- Apply 1NF normalization to the dataset provided.
 SELECT ID, Case_Number, Primary_Type, Location_description, Arrest, 
SUBSTRING_INDEX((SUBSTRING_INDEX(Description, ',', 1)), ',',-1) AS DESCRIPTION_NEW
FROM crime_us
UNION
SELECT ID, Case_Number, Primary_Type, Location_description, Arrest, 
SUBSTRING_INDEX((SUBSTRING_INDEX(Description, ',', 2)), ',', -1) AS DESCRIPTION_NEW
FROM crime_us
UNION
SELECT ID, Case_Number, Primary_Type, Location_description, Arrest, 
SUBSTRING_INDEX((SUBSTRING_INDEX(Description, ',', 3)), ',', -1) AS DESCRIPTION_NEW
FROM crime_us
UNION
SELECT ID, Case_Number, Primary_Type, Location_description, Arrest, 
SUBSTRING_INDEX((SUBSTRING_INDEX(Description, ',', 4)), ',', -1) AS DESCRIPTION_NEW
FROM crime_us;




 
